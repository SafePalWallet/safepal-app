// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_base_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinBaseInfo _$CoinBaseInfoFromJson(Map<String, dynamic> json) => CoinBaseInfo(
      type: json['type'] as int,
      uname: json['uname'] as String,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$CoinBaseInfoToJson(CoinBaseInfo instance) =>
    <String, dynamic>{
      'type': instance.type,
      'uname': instance.uname,
      'path': instance.path,
    };
