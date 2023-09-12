import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:safepal_example/utils/base_plugin.dart';
import 'package:safepal_example/model/models.dart';

class CryptoPluginRequestException implements Exception {
  int code;
  CryptoPluginRequestException(this.code);
  String toString() {
    return this.code.toString();
  }
}

class CryptoPlugin extends BasePlugin {
  static const String HASHER_SHA2 = "sha256";
  static const String HASHER_SHA2D = "sha256d";
  static const String HASHER_SHA2_RIPEMD = "sha256ripemd";
  static const String HASHER_RIPEMD160 = "ripemd160";

  static const MethodChannel _channel = const MethodChannel('flutter.safepal.io/crypto');

  static Future<T?> invokeMethod<T>(String method, dynamic argments) async {
    return await BasePlugin.invokeMethod<T>(channel: _channel, method: method, argments: argments);
  }

  // item0: pubkey;item1:private key
  static Future<List<String>> generateEcdsaKeypair({bool compressPubKey = false}) async {
    List<dynamic>? temps = await invokeMethod<List<dynamic>>('generateEcdsaKeypair', {"compress" : compressPubKey ? 1 : 0});
    List<String> results = List.from(temps!);
    return results;
  }

  static Future<String?> base58Encode(Uint8List data, {String? base58Hasher = HASHER_SHA2}) async {
    final Map<String, dynamic> argment = {};
    if (base58Hasher != null) {
      argment['base58Hasher'] = base58Hasher;
    }
    argment['data'] = data;
    return await invokeMethod<String>('base58Encode', argment);
  }

  // if base58Hasher is null, would not check
  static Future<List<int>?> base58Decode(String address, {String? base58Hasher, int? len}) async {
    final Map<String, dynamic> argment= {};
    argment['address'] = address;
    argment['characterSet'] = 0;
    if (base58Hasher != null) {
      argment["base58Hasher"] = base58Hasher;
    }
    if (len != null) {
      argment["len"] = len;
    }
    List<int>? result = await invokeMethod('base58Decode', argment);
    return result;
  }

  static Future<Uint8List?> generateCryptoKey({required List<int>pubKey, required List<int>privateKey}) async {
    final Map<String, dynamic> argment = {};
    argment['private_key'] = Uint8List.fromList(privateKey);
    argment['pub_key'] = Uint8List.fromList(pubKey);
    return await invokeMethod<Uint8List>('generateCryptoKey', argment);
  }

  static Map<String, dynamic> _toHdNodeMap(HDNode node) {
    Map<String, dynamic> nodeMap = {};
    nodeMap['depth'] = node.depth;
    nodeMap['childNum'] = node.childNum;
    nodeMap['fingerprint'] = node.fingerPrint;
    nodeMap['chainCode'] = Uint8List.fromList(node.chainCode!);
    nodeMap['publicKey'] = Uint8List.fromList(node.pubKey!);
    nodeMap['singleKey'] = node.isSingle() ? 1 : 0;
    return nodeMap;
  }

  static HDNode _toHDNodeFromMap(Map<String, dynamic> data) {
    Uint8List? chainCode = data["chainCode"] as Uint8List?;
    Uint8List? publicKey = data["publicKey"] as Uint8List?;
    HDNode node = HDNode(depth: data["depth"], childNum: data["childNum"], fingerPrint: data["fingerprint"], chainCode: chainCode?.toList(), pubKey: publicKey?.toList(), curve: null);
    return node;
  }

  static Future<String?> getEthAddressForNode({required HDNode node}) async {
    Map<String, dynamic> args = {};
    args['node'] = _toHdNodeMap(node);
    return await invokeMethod('getEthAddressForNode', args);
  }

  static Future<String?> getHDNodeXpub(HDNode? node, {String curve = "secp256k1", required int version}) async {
    Map<String, dynamic> args = {};
    args['node'] = _toHdNodeMap(node!);
    args['version'] = version;
    args['curve'] = curve;
    String? xpub = await invokeMethod('getHDNodeXpub', args);
    return xpub;
  }

  static Future<Uint8List?> sha256(Uint8List? data) async {
    if (data == null) {
      return null;
    }
    Uint8List? result = await invokeMethod('sha256', data);
    return result;
  }

  static Future<String?> generateBech32Address({
    required HDNode node,
    required int? index,
    required int change,
    required String hrp,
    required String? cure,
    int version = 0,
  }) async {
    final Map<String, dynamic> nodeMap = _toHdNodeMap(node);
    Map<String, dynamic> args = {};
    args['node'] = nodeMap;
    args['index'] = index;
    args['version'] = version;
    args['hrp'] = hrp;
    args['change'] = change;
    args['curve'] = cure;
    return await invokeMethod('generateBech32Address', args);
  }

  // generate bitcoin address, legacy | segwit
  static Future<String?> generateBitcoinAddress({
    required int purpose,
    required HDNode node,
    required int changeIndex,
    required int index,
    required int prefix,
    required String curve,
  }) async {
    final Map<String, dynamic> nodeMap = _toHdNodeMap(node);
    final Map<String, dynamic> args = {};
    args['node'] = nodeMap;
    args['index'] = index;
    args['curve'] = curve;
    args['prefix'] = prefix;
    args['changeIndex'] = changeIndex;
    args['purpose'] = purpose;
    return await invokeMethod("generateBitcoinAddress", args);
  }

  static Future<bool?> checkEthAddress({String? address}) async {
    if (address == null || address.isEmpty) {
      return false;
    }
    Map<String, dynamic> args = {};
    args['address'] = address;
    return invokeMethod("checkEthAddress", args);
  }

  static Future<List<int>?> aes256CFBEncrypt(List<int> data, List<int>? aesKey) async {
    if (data.isEmpty || aesKey == null || aesKey.isEmpty) {
      return null;
    }
    Map<String, dynamic> args = {};
    args['data'] = Uint8List.fromList(data);
    args['key'] = Uint8List.fromList(aesKey);
    return invokeMethod("aes256CFBEncrypt", args);
  }

  static Future<List<int>?> aes256CFBDecrypt(List<int>? data, List<int>? aesKey) async {
    if (data == null || data.isEmpty || aesKey == null || aesKey.isEmpty) {
      return null;
    }
    Map<String, dynamic> args = {};
    args['data'] = Uint8List.fromList(data);
    args['key'] = Uint8List.fromList(aesKey);
    return invokeMethod("aes256CFBDecrypt", args);
  }

  static Future<HDNode> getChildHDNode(HDNode hdnode, int chidIndex, String? curve) async {
    Map<String, dynamic> node = _toHdNodeMap(hdnode);
    Map<String, dynamic> args = {};
    args["node"] = node;
    args["childIndex"] = chidIndex;
    args["curve"] = curve;
    dynamic data = await invokeMethod("getChildHDNode", args);
    Map<String, dynamic> maps = Map<String, dynamic>.from(data);
    return _toHDNodeFromMap(maps);
  }

  static Future<HDNode> deserializeXpub(String xpub, int version, String? curve) async {
    Map<String, dynamic> args = {};
    args["xpub"] = xpub;
    args["version"] = version;
    args["curve"] = curve ?? 'secp256k1';
    dynamic data = await invokeMethod("deserializeXpub", args);
    Map<String, dynamic> maps = Map<String, dynamic>.from(data);
    return _toHDNodeFromMap(maps);
  }

}
