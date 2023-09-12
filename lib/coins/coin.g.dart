// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coin _$CoinFromJson(Map<String, dynamic> json) => Coin(
      coinInfo:
          Coin._baseInfoFromJson(json['coinInfo'] as Map<String, dynamic>),
      node: Coin._nodeFromJson(json['node'] as Map<String, dynamic>),
      extNodes: Coin._extNodesFromJson(json['extNodes']),
      account: json['account'] as String?,
      balance: json['balance'] == null
          ? null
          : Decimal.fromJson(json['balance'] as String),
    )..curPurpose = json['curPurpose'] as int?;

Map<String, dynamic> _$CoinToJson(Coin instance) => <String, dynamic>{
      'coinInfo': Coin._baseInfoToJson(instance.coinInfo),
      'node': Coin._nodeToJson(instance.node),
      'extNodes': Coin._extNodesToJson(instance.extNodes),
      'account': instance.account,
      'curPurpose': instance.curPurpose,
      'balance': instance.balance,
    };
