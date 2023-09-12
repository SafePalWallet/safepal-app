
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:safepal_example/manager/managers.dart';
import 'package:safepal_example/coins/coin.dart';
import 'package:safepal_example/utils/decimal_util.dart';
import 'package:safepal_example/coins/ethereum/ethereum_api.dart';
import 'package:safepal_example/pages/receive_address_widget.dart';
import 'package:safepal_example/pages/root_page.dart';
import 'package:safepal_example/pages/sign_message_page.dart';
import 'package:safepal_example/manager/transfer_history_manager.dart';
import 'package:safepal_example/pages/transfer_page.dart';
import 'package:safepal_example/utils/coin_utils.dart';
import 'package:safepal_example/utils/style.dart';
import 'package:safepal_example/utils/utils_plugin.dart';
import 'package:safepal_example/widgets/alert_dialog.dart';

import '../coins/bitcoin/bitcoin_api.dart';
import '../model/wallet.dart';
import '../utils/toast_util.dart';
import '../model/transfer_history.dart';

class MainWalletPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MainWalletPageState();
  }
}

class _MainWalletPageState extends State<MainWalletPage> {

  final TransferHistoryManager historyManager = TransferHistoryManager();


  late Wallet wallet;
  late Coin btc;
  late Coin eth;

  String? btcAddr;
  String? ethAddr;

  Decimal? btcBalance;
  Decimal? ethBalance;

  @override
  void initState() {
    this.wallet = WalletManager.instance.curSelWallet!;
    _init();
    super.initState();
  }

  Future<void> _init() async  {
    for (Coin coin in this.wallet.coins) {
      if (coin.coinInfo.coinCatetory == CoinCategory.bitcoin && coin.coinInfo.uname == "BTC") {
        this.btc = coin;
      } else if (coin.coinInfo.coinCatetory == CoinCategory.eth) {
        this.eth = coin;
      }
    }
    _loadAddress();
    _fetchBalance();
    _loadHisotry();
  }

  Future<void> _loadAddress() async {
    for (Coin coin in this.wallet.coins) {
      final String address = await coin.generateAddress(accountIndex: 0, index: 0);
      if (coin.coinInfo.coinCatetory == CoinCategory.bitcoin) {
        btcAddr = address;
      } else if (coin.coinInfo.coinCatetory == CoinCategory.eth) {
        ethAddr = address;
      }
    }
    _updateUI();
  }

  Future<void> _loadHisotry() async {
    await historyManager.loadData();
    _updateUI();
  }

  Future<void> _fetchBitcoinBalance() async {
    final ApiResp resp = await BitcoinApi().fetchBalance(this.btc.account!);
    if (resp.error != null) {
      print("reponse error:${resp.error.toString()}");
      return;
    }
    if (resp.data is! Map) {
      return;
    }
    final balance = resp.data['balance'];
    this.btcBalance = Decimal.parse(balance) / DecimalUtil.decimal8;
    this.btc.balance = this.btcBalance;
  }

  Future<void> _fetchEthereumBalance() async {
    final String result = await EthereumApi().eth_balance(this.eth.account);
    this.ethBalance = Decimal.parse(result) / DecimalUtil.decimal18;
    this.eth.balance = this.ethBalance;
    print("eth balance:$ethBalance");
  }

  Future<void> _fetchBalance() async {
    await Future.wait([
      _fetchBitcoinBalance(),
      _fetchEthereumBalance()
    ]);
    _updateUI();
  }

  Future<void> _onRefresh() async {
    await _fetchBalance();
  }

  Widget _createButtonWidget({
    required String title,
    required VoidCallback onPress
  }) {
    return Expanded(
      child: ElevatedButton(
          style: TextButton.styleFrom(backgroundColor: Colors.green),
          onPressed: onPress,
          child: Container(
            child: Text(title, style: AppTextStyle.headMedium,),
            height: 35,
            width: double.infinity,
            alignment: Alignment.center,
            color: Colors.green,
          )
      ),
    );
  }

  Widget _createTransferHistory({required List<TransferHistory> items}) {
    final List<Widget> children = [];
    children.add(Text("Submitted Transactions", style: AppTextStyle.bodySmall, textAlign: TextAlign.start,));
    if (items.isEmpty) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              "No data yet.",
              style: AppTextStyle.bodySmall.apply(color: AppColor.textDarkColor2),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ));
    } else {
      for (int idx = 0; idx < items.length; idx++) {
        final TransferHistory item = items[idx];
        children.add(Padding(
          padding: EdgeInsets.only(bottom: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("TxID", style: AppTextStyle.bodySmall,),
              SizedBox(width: 6,),
              GestureDetector(
                child: Text(
                  "${item.txid.substring(0, 10)}...${item.txid.substring(item.txid.length - 8)}",
                  style: AppTextStyle.bodySmall.apply(color: Colors.green),
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: (){
                  UtilsPlugin.copy(item.txid);
                  ToastUtil.show("Copy");
                },
              )
            ],
          ),
        ));
        children.add(Divider(height: 1.0, color: AppColor.lineButton,));
      }
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: AppColor.lineButton)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _createCoinInfo({
    required String icon,
    required String name,
    required String balance,
    required String title,
    required String address,
    required VoidCallback onSend,
    required VoidCallback onReceive,
    required List<TransferHistory> historys,
    VoidCallback? onSignMessage,
    VoidCallback? onPressTitle
  }) {

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColor.mainBackground2, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 32, height: 32,),
              SizedBox(width: 8,),
              Text(name, style: AppTextStyle.headMedium,),
              Expanded(child: Container(),),
              Text(balance, style: AppTextStyle.headMedium, textAlign: TextAlign.end,)
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyle.bodySmall,),
              Expanded(child: Container())
            ],
          ),
          SizedBox(height: 8,),
          GestureDetector(
            child: Text(address, style: AppTextStyle.bodyMedium, textAlign: TextAlign.start,),
            onTap: (){
              UtilsPlugin.copy(address);
              ToastUtil.show("Copy");
            },
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              _createButtonWidget(title: "Send", onPress: onSend),
              SizedBox(width: 10,),
              _createButtonWidget(title: "Receive", onPress: (){
                final child = ReceiveAddressWidget(
                  title: title,
                  address: address,
                  tokenIcon: icon,
                  onClose: (){
                    Navigator.of(this.context).pop();
                  },
                );
                Alert.showCustomWidget(context: this.context, contentWidget: child, options: [], onPress: (idx){});
              }),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            children: [
              onSignMessage != null ?
              _createButtonWidget(title: "Sign Message", onPress: (){
                onSignMessage();
              }) : Container()
            ],
          ),
          SizedBox(height: 8,),
          // _createTransferHistory(items: historys)
        ],
      ),
    );
  }

  void _showSignMessagePage(Coin coin) {
    Navigator.of(this.context).push(MaterialPageRoute(builder: (context){
      return SignMessagePage(wallet: wallet, coin: coin);
    }));
  }

  void _showTransferPage(Coin coin) {
    Navigator.of(this.context).push(MaterialPageRoute(builder: (context) {
      return TransferPage(
        historyManager: this.historyManager,
        wallet: wallet,
        coin: coin,
        onSendHandler: (){
          Navigator.of(this.context).pop();
          _updateUI();
        },);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return RootPage(
      showBackIcon: false,
      title: this.wallet.name + "-" + "${this.wallet.accountSuffix}",
      child: RefreshIndicator(
        child: ListView(
          padding: EdgeInsets.only(left: 15, right: 15),
          children: [
            _createCoinInfo(
                icon: "assets/images/coins/bitcoin.png",
                name: "BTC",
                balance: this.btcBalance?.toString() ?? "",
                title: "Legacy Address",
                address: this.btcAddr ?? "",
                historys:this.historyManager.historys(isBitcoin: true),
                onSend: (){
                  _showTransferPage(this.btc);
                },
                onReceive: (){

                },
                onPressTitle: (){

                },
                onSignMessage: (){
                  _showSignMessagePage(this.btc);
                }
            ),
            SizedBox(height: 10,),
            _createCoinInfo(
                icon: "assets/images/coins/ethereum.png",
                name: "ETH",
                balance: this.ethBalance?.toString() ?? "",
                title: "Ethereum Address",
                address: this.ethAddr ?? "",
                historys: this.historyManager.historys(isBitcoin: false),
                onSend: (){
                  _showTransferPage(this.eth);
                },
                onReceive: (){

                },
                onPressTitle: (){

                },
                onSignMessage: (){
                  _showSignMessagePage(this.eth);
                }
            )
          ],
        ),
        onRefresh: _onRefresh,
      ),
    );
  }

  void _updateUI() {
    if (this.mounted) {
      setState(() {});
    }
  }

}