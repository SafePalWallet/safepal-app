

import 'package:safepal_example/coins/base_address.dart';

import '../hd_node.dart';
import '../../utils/crypto_plugin.dart';

class NativeSegwitAddress extends BaseAddress {

  final int account;
  final int index;
  final String hrp;

  NativeSegwitAddress({
    required HDNode node,
    required this.hrp,
    required this.account,
    required this.index
  }) : super(node:node);

  @override
  Future<String> getAddress() async {
     final String? address = await CryptoPlugin.generateBech32Address(
        node: node,
        index: index,
        change: account,
        hrp: "bc1",
        cure: "secp256k1",
        version: 0
    );
    if (address == null) {
      throw "get address failed";
    }
    return address;
  }
}