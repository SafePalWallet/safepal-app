// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hd_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HDNode _$HDNodeFromJson(Map<String, dynamic> json) => HDNode(
      depth: json['depth'] as int?,
      childNum: json['childNum'] as int?,
      fingerPrint: json['fingerPrint'] as int?,
      chainCode:
          (json['chainCode'] as List<dynamic>?)?.map((e) => e as int).toList(),
      pubKey: (json['pubKey'] as List<dynamic>?)?.map((e) => e as int).toList(),
      curve: json['curve'] as int?,
      singleKey: json['singleKey'] as int?,
      purpose: json['purpose'] as int?,
      usedRecvAddrIndex: json['usedRecvAddrIndex'] as int? ?? -1,
      usedChangeAddrsIndex: json['usedChangeAddrsIndex'] as int? ?? -1,
      addrType: json['addrType'] as int?,
      addressNode: json['addressNode'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HDNodeToJson(HDNode instance) => <String, dynamic>{
      'depth': instance.depth,
      'childNum': instance.childNum,
      'fingerPrint': instance.fingerPrint,
      'chainCode': instance.chainCode,
      'pubKey': instance.pubKey,
      'purpose': instance.purpose,
      'curve': instance.curve,
      'singleKey': instance.singleKey,
      'usedRecvAddrIndex': instance.usedRecvAddrIndex,
      'usedChangeAddrsIndex': instance.usedChangeAddrsIndex,
      'addrType': instance.addrType,
      'addressNode': instance.addressNode,
    };
