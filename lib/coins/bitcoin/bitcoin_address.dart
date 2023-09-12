

import 'package:safepal_example/coins/base_address.dart';
import 'package:safepal_example/coins/hd_node.dart';
import 'package:safepal_example/utils/crypto_plugin.dart';

class BitcoinAddress extends BaseAddress {

  final int purpose;
  final int account;
  final int index;
  final int prefix;

  BitcoinAddress({
    required HDNode node,
    required this.purpose,
    required this.prefix,
    required this.account,
    required this.index
  }) : super(node:node);

  @override
  Future<String> getAddress() async {
    final String? address = await CryptoPlugin.generateBitcoinAddress(
        purpose : purpose,
        node: node,
        changeIndex: account,
        index: index,
        prefix: prefix,
        curve: "secp256k1");
    if (address == null) {
      throw "get address failed";
    }
    return address;
  }


}