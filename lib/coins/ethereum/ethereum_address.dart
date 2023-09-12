
import 'package:safepal_example/coins/base_address.dart';
import 'package:safepal_example/coins/hd_node.dart';
import 'package:safepal_example/utils/crypto_plugin.dart';

class EthereumAddress extends BaseAddress {

  final int accountIndex;
  final int index;

  EthereumAddress({
    required HDNode node,
    this.accountIndex = 0,
    this.index = 0,
  }) : super(node: node);
  

  @override
  Future<String> getAddress() async {
    final String curve = "secp256k1";
    HDNode result = await CryptoPlugin.getChildHDNode(node, accountIndex, curve);
    result = await CryptoPlugin.getChildHDNode(result, index, curve);
    final String? address = await CryptoPlugin.getEthAddressForNode(node: result);
    if (address == null) {
      throw "get address failed";
    }
    return address;
  }


}