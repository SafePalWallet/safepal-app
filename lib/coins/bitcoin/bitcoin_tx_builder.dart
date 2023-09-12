
import 'package:fixnum/fixnum.dart';
import 'package:safepal_example/model/models.dart';
import 'package:safepal_example/model/send_out_item.dart';
import 'package:safepal_example/protobuf/Wallet.pb.dart';

import '../hd_purpose_util.dart';
import 'bitcoin_unspend.dart';
import 'bitcoin_utxo_selector.dart';
import '../../utils/debug_logger.dart';

enum BitcoinTxBuidlerResult {
  success,
  insufficient,
  noUtxo,
  failed
}

class BitcoinTxBuilder {
  static const String TAG = "BitcoinTxBuilder";

  final Coin? coin;
  final int? bytefee;
  List<BitcoinOutput> outputs = [];
  final BIPPurposeType purpose;

  List<BitcoinUnspend> selectedUnspends = [];
  Wallet? wallet;
  BigInt? feeAmount;
  BitcoinSignRequest? uTxSignRequest;
  BitcoinTxBuidlerResult? result;

  BitcoinTxBuilder({
    required this.purpose,
    this.coin,
    this.bytefee,
    this.wallet
  });

  // 找零输出
  BitcoinOutput? findChangeOutput() {
    if (this.outputs == null || this.outputs.isEmpty) {
      return null;
    }
    for (BitcoinOutput item in this.outputs) {
      if (item.flag == 1) {
        return item;
      }
    }
    return null;
  }

  int? findChangeIndex() {
    BitcoinOutput? output = findChangeOutput();
    if (output == null) {
      return null;
    }
    if (output.path.isEmpty) {
      return null;
    }
    String path = output.path;
    List<String> items = path.split("/");
    if (items.length < 2) {
      return null;
    }
    int? last = int.tryParse(items.last);
    return last;
  }

  static Future<BitcoinTxBuilder> build({
    required Coin? coin,
    required List<SendOutItem>? outs,
    required int? bytefee,
    required List<BitcoinUnspend> utxos,
    required Wallet? wallet}) async {

    final BIPPurposeType purposeType = coin?.curPurposeType ?? BIPPurposeType.bip44;
    BitcoinTxBuilder builder = BitcoinTxBuilder(purpose: purposeType, coin: coin, bytefee: bytefee, wallet: wallet);
    if (utxos.isEmpty) {
      DebugLogger.v('not find any utxo');
      builder.result = BitcoinTxBuidlerResult.noUtxo;
      return builder;
    }
    BigInt totalBalance = BigInt.zero;
    totalBalance =  BitcoinUtxoSelector.sumAmount(utxos);
    List<BitcoinUnspend> selectedUnspends = [];
    BitcoinUtxoFeeCalculator calculator = BitcoinUtxoFeeCalculator(purpose: purposeType);

    BigInt totalOutput = BigInt.zero;
    for (SendOutItem item in outs!) {
      totalOutput += item.amount!;
    }
    DebugLogger.v('$TAG builder totalOutput:$totalOutput totalBalance:$totalBalance');
    if (totalOutput > totalBalance) {
      builder.result = BitcoinTxBuidlerResult.insufficient;
      return builder;
    }

    // 首先预计包含找零
    final int numOutput = outs.length + 1; // 先预算包含找零
    selectedUnspends = BitcoinUtxoSelector(
        purpose: purposeType,
        utxos: utxos,
        bytefee: BigInt.from(bytefee!),
        targetVal: totalOutput,
        numOutput: numOutput,
        dust: BitcoinUtxoSelector.dustThreshold).select();
    if (selectedUnspends == null || selectedUnspends.isEmpty) {
      builder.result = BitcoinTxBuidlerResult.insufficient;
      DebugLogger.v('${TAG}: error1 insufficient');
      return builder;
    }

    BigInt totalInput = BitcoinUtxoSelector.sumAmount(selectedUnspends);
    BigInt fee = calculator.calFee(numInput: selectedUnspends.length, numOutput: numOutput, bytefee: BigInt.from(bytefee));
    BigInt changeAmount = totalInput - totalOutput - fee;

    if (changeAmount < BigInt.zero) {
      builder.result = BitcoinTxBuidlerResult.insufficient;
      DebugLogger.v('$TAG: error2 insufficient');
      return builder;
    }
    builder.feeAmount = fee;
    builder.selectedUnspends = selectedUnspends;

    for (SendOutItem item in outs) {
      BitcoinOutput bitcoinOutput = BitcoinOutput();
      bitcoinOutput.address = item.address ?? '';
      bitcoinOutput.value =  Int64(item.amount!.toInt());
      bitcoinOutput.flag = 0;
      builder.outputs.add(bitcoinOutput);
    }
    if (changeAmount > BigInt.zero) {
      final int index = 0;
      final String path = "1/$index";
      final String? address = await coin!.generateAddress(accountIndex: 1, index: index);
      if (address == null || address.isEmpty) {
        builder.result = BitcoinTxBuidlerResult.failed;
        return builder;
      }
      BitcoinOutput changeOutput = BitcoinOutput();
      changeOutput.address = address;
      changeOutput.value = Int64.parseInt(changeAmount.toString());
      changeOutput.path = path;
      changeOutput.flag = 1;
      builder.outputs.add(changeOutput);
    }
    builder.result = BitcoinTxBuidlerResult.success;

    for (BitcoinUnspend item in selectedUnspends) {
      print('input amount:${item.amount}');
    }
    for (BitcoinOutput item in builder.outputs) {
      print('output address:${item.address} amount:${item.value} flag:${item.flag} path:${item.path}');
    }

    return builder;
  }
}