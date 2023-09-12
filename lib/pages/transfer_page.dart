import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:safepal_example/model/models.dart';
import 'package:safepal_example/utils/decimal_util.dart';
import 'package:safepal_example/coins/ethereum/ethereum_api.dart';
import 'package:safepal_example/pages/root_page.dart';
import 'package:safepal_example/model/transfer_history.dart';
import 'package:safepal_example/manager/transfer_history_manager.dart';

import '../coins/bitcoin/bitcoin_api.dart';
import '../coins/bitcoin/bitcoin_tx_builder.dart';
import '../coins/bitcoin/bitcoin_unspend.dart';
import '../coins/hd_derived_path.dart';
import '../manager/network_manager.dart';
import '../protobuf/Wallet.pb.dart';
import '../transport/transport_util.dart';
import '../utils/coin_utils.dart';
import '../utils/style.dart';
import '../widgets/alert_dialog.dart';
import '../utils/toast_util.dart';

class TransferPage extends StatefulWidget {

  final TransferHistoryManager historyManager;
  final Wallet wallet;
  final Coin coin;
  final VoidCallback onSendHandler;

  TransferPage({
    required this.wallet,
    required this.coin,
    required this.historyManager,
    required this.onSendHandler
  });

  @override
  State<StatefulWidget> createState() {
    return _TransferPageState();
  }

}


class _TransferPageState extends State<TransferPage> {

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<int?> _fetchBitcoinFee() async {
    final BitcoinApi api = BitcoinApi();
    final ApiResp resp = await api.fetchFee();
    if (resp.data is! Map) {
      return null;
    }
    return resp.data['medium'];
  }

  Future<List<BitcoinUnspend>?> _fetchBitcoinUtxo() async {
    final BitcoinApi api = BitcoinApi();
    final ApiResp resp = await api.fetchUtxo(widget.coin.account!);
    if (resp.data is! List) {
      return null;
    }
    final List<BitcoinUnspend> unspends = [];
    final List<dynamic> items = resp.data;
    for (dynamic item in items) {
      final BitcoinUnspend object = BitcoinUnspend.fromJson(item);
      unspends.add(object);
    }
    return unspends;
  }

  Future<void> _sendBitcoin() async {
    final List<BitcoinUnspend>? utxos = await _fetchBitcoinUtxo();
    if (utxos == null || utxos.isEmpty) {
      ToastUtil.show("get utxo failed");
      return;
    }

    final int? fee = await _fetchBitcoinFee();
    if (fee == null) {
      ToastUtil.show("get fee failed");
      return;
    }
    int maxRecIndex = 0;
    for (BitcoinUnspend item in utxos) {
      if (item.isReceive! && item.index > maxRecIndex) {
        maxRecIndex = item.index;
      }
    }

    SendOutItem out = SendOutItem();
    out.address = _addressController.text;
    out.amountText = _amountController.text;
    out.amount = (Decimal.parse(_amountController.text) * DecimalUtil.decimal8).toBigInt();

    final BitcoinTxBuilder builder = await BitcoinTxBuilder.build(
        wallet: widget.wallet,
        coin: widget.coin,
        outs: [out],
        utxos: utxos,
        bytefee: fee);
    if (builder.result != BitcoinTxBuidlerResult.success) {
      switch (builder.result) {
        case BitcoinTxBuidlerResult.insufficient:
          ToastUtil.show("Build tx failed, insufficient");
          return;
        case BitcoinTxBuidlerResult.noUtxo:
          ToastUtil.show("Build tx failed, not found utxo");
          break;
        default:
          ToastUtil.show("Build tx failed");
          break;
      }
      return;
    }

    final BitcoinSignRequest signRequest = BitcoinSignRequest();
    final CoinInfo coinInfo = CoinInfo();
    coinInfo.uname = "BTC";
    coinInfo.type = CoinCategory.bitcoin.index;
    coinInfo.path = widget.coin.curPath;
    signRequest.coin = coinInfo;
    signRequest.maxReceiveIndex = Int64(maxRecIndex);

    for (BitcoinUnspend item in builder.selectedUnspends) {
      final BitcoinInput input = BitcoinInput();
      input.txid = hex.decode(item.txid!);
      input.index = item.txIndex!;
      HDDerivedPath coinDerivedPath = HDDerivedPath.derivedPathWithPath(item.path)!;
      input.path = coinDerivedPath.suffixPath;
      input.value = Int64.parseInt(item.amount!);
      input.address = item.address!;
      print('input address:${input.address} path:${input.path}');
      signRequest.inputs.add(input);
    }

    for (BitcoinOutput item in builder.outputs) {
      signRequest.outputs.add(item);
    }

    final List<int> result = await _sign(
        reqType: MessageType.MSG_BITCOIN_SIGN_REQUEST,
        respType: MessageType.MSG_BITCOIN_SIGN_RESP,
        reqdata: signRequest.writeToBuffer().toList()
    );
    if (result.isEmpty) {
      ToastUtil.show("Sign bitcoin failed");
      return;
    }
    final String rawdata = hex.encode(result);
    Alert.show(context: this.context, content: rawdata, options: ["Cancel", "Broadcast"], onPress: (idx) async {
      if (idx == 0) {
        return;
      }
      final ApiResp resp = await BitcoinApi().sendtx(rawdata);
      if (resp.error != null) {
        ToastUtil.show(resp.error.toString());
        return;
      }
      final String txid = resp.data['result'];
      ToastUtil.show("sendt bitcoin tx success, txid:$txid");
      final TransferHistory model = TransferHistory(
          amount: _amountController.text,
          timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          txid: txid,
          to: _addressController.text
      );
      widget.historyManager.addHistory(history: model, isBitcoin: true);
      widget.onSendHandler();
    });
  }

  Future<void> _sendEthereum() async {
    final String addr = _addressController.text.toLowerCase();
    if (!addr.startsWith("0x")) {
      ToastUtil.show("invalid address");
      return;
    }
    List<int>? toAddress;
    try {
      toAddress = hex.decode(addr.substring(2));
    } catch (e) {
    }
    if (toAddress?.length != 20) {
      ToastUtil.show("invalid address");
    }
    final int gas = 21000;
    final Decimal amount = Decimal.parse(_amountController.text);
    final Decimal rate = DecimalUtil.decimal18;

    try {
      final EthereumApi api = EthereumApi();
      final int nonce = await api.eth_getTransactionCount(widget.coin.account);
      final int gasPrice = await api.eth_gasPrice();
      final EthSignRequest signRequest = EthSignRequest();

      final CoinInfo coinInfo = CoinInfo();
      coinInfo.uname = widget.coin.coinInfo.uname;
      coinInfo.type = widget.coin.coinInfo.type;
      if (widget.coin.coinInfo.path != null) {
        coinInfo.path = widget.coin.coinInfo.path!;
      }
      signRequest.chainId = Int64(1);
      signRequest.txType = 0;
      signRequest.coin = coinInfo;
      signRequest.nonce = Int64(nonce);
      signRequest.gasPrice = Int64(gasPrice);
      signRequest.gasLimit = Int64(gas);
      signRequest.to = toAddress!;
      signRequest.value = hex.decode((amount * rate).toBigInt().toRadixString(16));

      final EthTokenInfo tokenInfo = EthTokenInfo();
      tokenInfo.type = coinInfo.type;
      tokenInfo.name = "Ethereum";
      tokenInfo.symbol = "ETH";
      tokenInfo.decimals = 18;
      signRequest.token = tokenInfo;

      final List<int> result = await _sign(
          reqType: MessageType.MSG_ETH_SIGN_REQUEST,
          respType: MessageType.MSG_ETH_SIGN_RESP,
          reqdata: signRequest.writeToBuffer().toList()
      );
      if (result.isEmpty) {
        ToastUtil.show("Sign ethereum failed");
        return;
      }
      final String rawdata = "0x" + hex.encode(result);
      Alert.show(context: this.context, content: rawdata, options: ["Cancel", "Broadcast"], onPress: (idx) async {
        if (idx == 0) {
          return;
        }
        final String txid = await api.eth_sendRawTransaction(rawdata);
        ToastUtil.show("sendt ethereum tx success, txid:$txid");
        final TransferHistory model = TransferHistory(
            amount: _amountController.text,
            timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            txid: txid, to: _addressController.text);
        widget.historyManager.addHistory(history: model, isBitcoin: false);
        widget.onSendHandler();
      });
    } catch (e) {
      ToastUtil.show(e.toString());
      return;
    }
  }

  Future<List<int>> _sign({
    required MessageType reqType,
    required MessageType respType,
    required List<int> reqdata
  }) async {
    final WalletReqExtInfo extInfo = WalletReqExtInfo(
      qrcodePageTitle: "Sign Transfer",
      qrcodePageTips: "Please scan the code with your wallet",
      scanPageTitle: "Sign Transfer",
    );
    final Completer<List<int>> completer = Completer();
    await TransportUtil.commandRequest(
        widget.wallet.channelType,
        context: context,
        wallet: widget.wallet,
        data: reqdata,
        reqType: reqType,
        respType: respType,
        respDataConfirmFinishHandler: (object){
          if (object is EthSignRespone) {
            completer.complete(object.txData);
          } else if (object is BitcoinSignRespone) {
            completer.complete(object.txData);
          }
        },
        info: extInfo
    );
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return RootPage(
      title: "Transfer ${widget.coin.coinInfo.uname}",
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Receive Address", style: AppTextStyle.bodyMedium.apply(color: Colors.grey),),
            SizedBox(
              height: 44,
              child: TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    fillColor: Colors.grey.withAlpha(100),
                    filled: true,
                    hintText: "Please enter receive address",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("Amount", style: AppTextStyle.bodyMedium.apply(color: Colors.grey),),
            SizedBox(
              height: 44,
              child: TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    fillColor: Colors.grey.withAlpha(100),
                    filled: true,
                    hintText: "Please enter amount",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    suffixText: widget.coin.coinInfo.uname,
                    suffixStyle: AppTextStyle.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(child: Container()),
                SizedBox(
                  width: 200,
                  height: 44,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      child: Text("Next", style: AppTextStyle.headMedium),
                      onPressed: () {
                        if (_addressController.text.isEmpty) {
                          ToastUtil.show("Please enter address");
                          return;
                        }
                        if (_amountController.text.isEmpty) {
                          ToastUtil.show("Please enter amount");
                          return;
                        }
                        final Decimal? amount = Decimal.tryParse(_amountController.text);
                        if (amount == null) {
                          ToastUtil.show("Invalid amount");
                          return;
                        }
                        if (amount > (widget.coin.balance ?? Decimal.zero)) {
                          ToastUtil.show("Insufficient balance");
                          return;
                        }
                        switch (widget.coin.coinInfo.coinCatetory) {
                          case CoinCategory.eth:
                          case CoinCategory.erc20:
                            _sendEthereum();
                            break;
                          case CoinCategory.bitcoin:
                            _sendBitcoin();
                            break;
                          default:
                            break;
                        }
                      }
                  ),
                ),
                Expanded(child: Container())
              ],
            ),
          ],
        ),
      ),
    );
  }

}