import 'package:convert/convert.dart';
import 'package:decimal/decimal.dart';
import 'package:safepal_example/coins/bitcoin/bitcoin_address.dart';
import 'package:safepal_example/coins/bitcoin/native_segwit_address.dart';

import 'package:safepal_example/coins/coin_base_info.dart';
import 'package:safepal_example/coins/hd_derived_path.dart';
import 'package:safepal_example/coins/hd_node.dart';
import 'package:safepal_example/model/models.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:safepal_example/utils/crypto_plugin.dart';

import '../utils/coin_utils.dart';
import '../utils/debug_logger.dart';
import 'bitcoin/extended_public_key.dart';
import 'ethereum/ethereum_address.dart';
import 'hd_magic_version.dart';
import 'hd_purpose_util.dart';

part 'coin.g.dart';

@JsonSerializable()
class Coin {

  @JsonKey(fromJson: _baseInfoFromJson, toJson:_baseInfoToJson)
  final CoinBaseInfo coinInfo;

  @JsonKey(fromJson:_nodeFromJson, toJson:_nodeToJson)
  final HDNode node;

  @JsonKey(fromJson: _extNodesFromJson, toJson: _extNodesToJson)
  final List<HDNode>? extNodes;

  String? account;
  int? curPurpose;
  Decimal? balance;

  Coin({
    required this.coinInfo,
    required this.node,
    this.extNodes,
    this.account,
    this.balance
  }) {
    this.curPurpose = this.node.purpose;
  }

  static HDNode _nodeFromJson(Map<String, dynamic> item) {
    return HDNode.fromJson(item);
  }

  static Map<String, dynamic> _nodeToJson(HDNode node) {
    return node.toJson();
  }

  static List<HDNode>? _extNodesFromJson(dynamic items) {
    if (items == null || items is! List) {
      return null;
    }
    List<Map<String, dynamic>> jsons = List.from(items);
    List<HDNode> nodes = [];
    for (Map<String, dynamic> item in jsons) {
      HDNode hdNode = HDNode.fromJson(item);
      nodes.add(hdNode);
    }
    return nodes;
  }

  static List<Map<String, dynamic>>? _extNodesToJson(List<HDNode>? nodes) {
    if (nodes == null || nodes.isEmpty) {
      return null;
    }
    List<Map<String, dynamic>> items = [];
    for (HDNode item in nodes){
      items.add(item.toJson());
    }
    return items;
  }

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
  Map<String, dynamic> toJson() => _$CoinToJson(this);

  int get hashCode {
    if (this.coinInfo != null) {
      return this.coinInfo.hashCode;
    }
    return 0;
  }

  List<HDNode> get allNodes {
    if (this.extNodes == null || this.extNodes!.isEmpty) {
      return [node];
    }
    List<HDNode> nodes = [];
    nodes.add(this.node);
    nodes.addAll(this.extNodes!);
    return nodes;
  }

  bool operator ==(Object other) {
    if (other is Coin) {
      return other.coinInfo == this.coinInfo;
    }
    return false;
  }

  static CoinBaseInfo _baseInfoFromJson(Map<String, dynamic> jsonData) {
    return CoinBaseInfo.fromJson(jsonData);
  }

  static Map<String, dynamic> _baseInfoToJson(CoinBaseInfo baseInfo) {
    return baseInfo.toJson();
  }

  HDNode? findNodeWithType(BIPPurposeType? desAddrType) {
    final List<HDNode> _allNodes = this.allNodes;
    for (HDNode item in _allNodes) {
      if (item.purposeType == desAddrType) {
        return item;
      }
    }
    return null;
  }

  BIPPurposeType? get curPurposeType {
    switch (this.curPurpose) {
      case 44:
        return BIPPurposeType.bip44;
      case 49:
        return BIPPurposeType.bip49;
      case 84:
        return BIPPurposeType.bip84;
    }
    if (this.chainConfig.derivationPath.isEmpty) {
      return null;
    }
    final HDDerivedPath? path = HDDerivedPath.derivedPathWithPath(this.chainConfig.derivationPath);
    if (path == null || path.purpose == null) {
      return null;
    }
    return HDPurposeUtil.getPurposeTypeForDerivedValue(path.purpose!);
  }

  String get curPath {
    int? purpose;
    switch (this.curPurposeType) {
      case BIPPurposeType.bip44:
        purpose = 44;
        break;
      case BIPPurposeType.bip84:
        purpose = 84;
        break;
      case BIPPurposeType.bip49:
        purpose = 49;
        break;
      default:
        break;
    }
    return 'm/${purpose}h/0h/0h';
  }

  ChainConfig get chainConfig {
    return chainConfigManager.coinConfigWithUname(uname: coinInfo.uname, type:coinInfo.type)!;
  }

  Future<String> generateAddress({int accountIndex = 0, int index = 0}) async {
    final ChainConfig chainConfig = this.chainConfig;
    if (chainConfig.coinCategory == CoinCategory.bitcoin) {
      if (this.curPurposeType == null) {
        throw("generate address failed, uname:${coinInfo.uname} type:${coinInfo.type}");
      }
      final HDNode selectedNode = this.findNodeWithType(this.curPurposeType)!;
      if (this.curPurposeType != BIPPurposeType.bip84) {
        final int? prefix = this.curPurposeType == BIPPurposeType.bip44 ? chainConfig.p2pkhPrefix : chainConfig.p2shPrefix;
        if (prefix == null) {
          throw("generate address failed, uname:${coinInfo.uname} type:${coinInfo.type}");
        }
        return BitcoinAddress(node: selectedNode, purpose: this.curPurpose!, prefix: prefix, account: accountIndex, index: index).getAddress();
      } else {
        return NativeSegwitAddress(node: selectedNode, hrp: chainConfig.hrp!, account: accountIndex, index: index).getAddress();
      }
    } else if (chainConfig.coinCategory == CoinCategory.eth) {
      return EthereumAddress(node: this.node, accountIndex: accountIndex, index: index).getAddress();
    }
    throw("generate address failed, uname:${coinInfo.uname} type:${coinInfo.type}");
  }

  Future<void> generateAccount() async {
    await this.updatePurpose(purposeType: curPurposeType!);
  }

  Future<void> updatePurpose({required BIPPurposeType purposeType}) async {
    this.curPurpose = HDPurposeUtil.getDerivedValueForPurposeType(purposeType);
    final ChainConfig chainConfig = this.chainConfig;
    if (chainConfig.coinCategory == CoinCategory.bitcoin) {
      final String name = chainConfig.supportedExtendedPublicKeys![purposeType]!;
      final int? version = HDMagicVersion.getExtendedMagicVersionFor(name: name);
      if (version == null) {
        throw("update purpose failed, invalid version type:${coinInfo.coinCatetory} uname:${coinInfo.uname} purposeType:$purposeType");
      }
      final ExtendedPublicKey publicKey = ExtendedPublicKey(node: node, magicVersion: version);
      this.account = await publicKey.getKey();
    } else {
      this.account = await EthereumAddress(node: node).getAddress();
    }
    if (this.account == null || this.account!.isEmpty) {
      throw("update purpose failed type:${coinInfo.coinCatetory} uname:${coinInfo.uname} purposeType:$purposeType");
    }
  }
}