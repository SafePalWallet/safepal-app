
import 'package:safepal_example/coins/hd_node.dart';
import 'package:safepal_example/utils/crypto_plugin.dart';

class ExtendedPublicKey {

  final HDNode node;
  final int magicVersion;

  ExtendedPublicKey({
    required this.node,
    required this.magicVersion
  });

  Future<String> getKey() async {
    final String? key = await CryptoPlugin.getHDNodeXpub(node, curve: "secp256k1", version: this.magicVersion);
    if (key == null) {
      throw "get extended public key failed";
    }
    return key;
  }

}