import 'package:json_annotation/json_annotation.dart';
import 'package:safepal_example/coins/coin_base_info.dart';
import 'package:safepal_example/coins/hd_purpose_util.dart';
import '../utils/coin_utils.dart';
import 'hd_derived_path.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

part 'chain_config.g.dart';

@JsonSerializable()
class ChainConfig {
  final String id;

  final int type;
  final String uname; // uname

  final String name;
  final String symbol;
  final int decimals;

  final String blockchain;
  final String derivationPath;
  String? curve;
  String? publicKeyType;
  int? staticPrefix;
  int? p2pkhPrefix;

  int? p2shPrefix;
  String? hrp;
  String? publicKeyHasher;
  String? base58Hasher;

  String? explorer;
  String? account;

  String? logo;
  String? chainLogo;

  int? chainId;

  String? supportedPurposes;


  Map<BIPPurposeType, String>? _supportedExtendedPublicKeys;
  Map<BIPPurposeType, String>? get supportedExtendedPublicKeys {
    return _supportedExtendedPublicKeys;
  }

  ChainConfig({
    required this.id,

    required this.type,
    required this.uname,

    required this.name,
    required this.symbol,
    required this.decimals,

    required this.blockchain,
    required this.derivationPath,
    this.curve,
    this.publicKeyType,
    this.staticPrefix,
    this.p2pkhPrefix,

    this.p2shPrefix,
    this.hrp,
    this.publicKeyHasher,
    this.base58Hasher,

    this.explorer,
    this.account,

    this.logo,
    this.chainLogo,
    this.chainId,

    this.supportedPurposes
  }) {
    if (this.supportedPurposes != null) {
      _supportedExtendedPublicKeys = _supportedExtendedFromString(this.supportedPurposes!);
    }
  }

  static Map<BIPPurposeType, String> _supportedExtendedFromString(String value) {
    final Map<BIPPurposeType, String> result = {};
    final List<String> pairs = value.split(";");
    for (String pair in pairs) {
      final List<String> items = pair.split(":");
      final BIPPurposeType? type = HDPurposeUtil.getPurposeTypeForDerivedValue(int.parse(items[0]));
      if (type == null) {
        continue;
      }
      result[type] = items[1];
    }
    return result;
  }

  static String _supportedExtendedToString(Map<BIPPurposeType, String> values) {
    String result = "";
    for (BIPPurposeType type in values.keys) {
      final typeValue = HDPurposeUtil.getDerivedValueForPurposeType(type);
      if (typeValue == null) {
        continue;
      }
      if (result.isNotEmpty) {
        result += ";";
      }
      result += "$typeValue:${values[type]}";
    }
    return result;
  }

  CoinCategory? get coinCategory {
    if (this.type > 0 && CoinCategory.values.length > this.type) {
      return CoinCategory.values[this.type];
    }
    return null;
  }

  int get hashCode {
    return this.id.hashCode;
  }

  bool operator ==(Object other) {
    if (other is! ChainConfig) {
      return false;
    }
    return this.id == other.id;
  }

  String get tid {
    return "${this.type}:${this.uname}";
  }

  bool? _isEvm;
  bool isStandardEvmChain() {
    if (_isEvm != null) {
      return _isEvm!;
    }
    if (this.blockchain != "Ethereum") {
      _isEvm = false;
      return _isEvm!;
    }
    HDDerivedPath? path = HDDerivedPath.derivedPathWithPath(this.derivationPath);
    if (path == null) {
      return false;
    }
    _isEvm = path.coin == 60;
    return _isEvm!;
  }

  String get pathPrefix {
    final HDDerivedPath path = HDDerivedPath.derivedPathWithPath(this.derivationPath)!;
    return path.prefix;
  }

  int? addressPrefixFromType(BIPPurposeType type) {
    switch (type){
      case BIPPurposeType.bip44:
        return this.p2pkhPrefix;
      case BIPPurposeType.bip49:
        return this.p2shPrefix;
      case BIPPurposeType.bip84:
        break;
      default:
        break;
    }
    return null;
  }

  factory ChainConfig.fromJson(Map<String, dynamic> json) => _$ChainConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ChainConfigToJson(this);

}

final ChainConfigManager chainConfigManager = ChainConfigManager();

class ChainConfigManager {

  List<ChainConfig>? _allChainConfigs;

  final Map<String, ChainConfig> _chainTidConfigMaps = {};

  Future<void> init() async {
    final String path = 'assets/json/blockchain.json';
    ByteData byteData = await rootBundle.load(path);
    Uint8List uint8list = byteData.buffer.asUint8List();
    dynamic jsons = json.decode(utf8.decode(uint8list as List<int>));
    if (jsons == null || jsons is! List) {
      return;
    }
    List<dynamic> datas = List.from(jsons);
    List<ChainConfig> configs = [];
    List<ChainConfig> evmConfigs = [];
    for (dynamic item in datas) {
      if (item is Map<String, dynamic>) {
        final ChainConfig config = ChainConfig.fromJson(item);
        configs.add(config);
        if (config.isStandardEvmChain()) {
          evmConfigs.add(config);
        }
      }
    }

    List<ChainConfig> allConfigs = [];
    allConfigs.addAll(configs);
    for (ChainConfig item in allConfigs) {
      _chainTidConfigMaps[item.tid] = item;
    }
    _allChainConfigs = allConfigs;
  }

  List<ChainConfig> coinConfigs() {
    return _allChainConfigs ?? [];
  }

  ChainConfig? coinConfigWithTid(String? tid) {
    CoinBaseInfo? baseInfo = CoinBaseInfo.fromTid(tid);
    List<ChainConfig>? configs = this.coinConfigs();
    if (configs.isEmpty) {
      return null;
    }
    for (ChainConfig item in configs) {
      if (item.uname == baseInfo?.uname && item.type == baseInfo?.type) {
        return item;
      }
    }
    return null;
  }

  ChainConfig? coinConfigWithChainId(int chainId) {
    for (ChainConfig item in coinConfigs()) {
      if (item.chainId == null){
        continue;
      }
      if (item.chainId == chainId) {
        return item;
      }
    }
    return null;
  }

  ChainConfig? coinConfigWithUname({required String uname, required int type}) {
    if (uname.isEmpty) {
      return null;
    }
    final String tid = "$type:$uname";
    final ChainConfig? result = _chainTidConfigMaps[tid];
    if (_chainTidConfigMaps.isEmpty || result == null) {
      for (ChainConfig item in _allChainConfigs!) {
        _chainTidConfigMaps[item.tid] = item;
      }
    }
    if (result != null) {
      return result;
    }
    return null;
  }

}
