import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:safepal_example/coins/coin.dart';
import 'package:safepal_example/coins/hd_purpose_util.dart';

part 'hd_node.g.dart';

@JsonSerializable()
class HDNode {
  final int? depth;
  final int? childNum;
  final int? fingerPrint;

  final List<int>? chainCode;
  final List<int>? pubKey;

  final int? purpose;
  final int? curve;

  final int? singleKey;
  int? usedRecvAddrIndex;
  int? usedChangeAddrsIndex;
  int? addrType;
  Map<String,dynamic>? addressNode;

  HDNode({
    required this.depth,
    required this.childNum,
    required this.fingerPrint,
    required this.chainCode,
    required this.pubKey,
    this.curve,
    this.singleKey,
    this.purpose,
    this.usedRecvAddrIndex = -1,
    this.usedChangeAddrsIndex = -1,
    this.addrType,
    this.addressNode
  }){
    if(addressNode==null){
      addressNode = {};
    }
  }

  BIPPurposeType? get purposeType {
    if (purpose == null) {
      return null;
    }
    return HDPurposeUtil.getPurposeTypeForDerivedValue(purpose!);
  }

  bool isSingle() {
    if (this.singleKey == null) {
      return false;
    }
    return this.singleKey == 1;
  }

  factory HDNode.fromJson(Map<String, dynamic> json) => _$HDNodeFromJson(json);
  Map<String, dynamic> toJson() => _$HDNodeToJson(this);

  @override
  int get hashCode {
    return this.depth.hashCode ^
           this.childNum.hashCode ^
           this.fingerPrint.hashCode ^
           this.chainCode.hashCode ^
           this.pubKey.hashCode;
  }

  @override
  bool operator ==(other) {
    if (other is HDNode) {
      Function eq = const ListEquality().equals;
      bool? chainCodeEq = eq(other.chainCode, this.chainCode);
      bool? pubKeyEq = eq(other.pubKey, this.pubKey);
      return other.depth == this.depth &&
             other.childNum == this.childNum &&
             chainCodeEq! && pubKeyEq! &&
             other.fingerPrint == this.fingerPrint;
    }
    return false;
  }

}

