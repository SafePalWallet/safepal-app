// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: json['id'] as String,
      name: json['name'] as String,
      version: json['version'] as int,
      seVersion: json['seVersion'] as int,
      productSn: json['productSn'] as String,
      productSeries: json['productSeries'] as String,
      productType: json['productType'] as String,
      productName: json['productName'] as String,
      productBrand: json['productBrand'] as String,
      accountSuffix: json['accountSuffix'] as String,
      activeTime: json['activeTime'] as int,
      activeCode: json['activeCode'] as String,
      activeTimeZone: json['activeTimeZone'] as int,
      secRandom:
          (json['secRandom'] as List<dynamic>).map((e) => e as int).toList(),
      clientId: json['clientId'] as int,
      accountId: json['accountId'] as int,
      accountType: json['accountType'] as int,
      addedTime: json['addedTime'] as int,
      coins: (json['coins'] as List<dynamic>)
          .map((e) => Coin.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'version': instance.version,
      'seVersion': instance.seVersion,
      'productSn': instance.productSn,
      'productSeries': instance.productSeries,
      'productType': instance.productType,
      'productName': instance.productName,
      'productBrand': instance.productBrand,
      'accountSuffix': instance.accountSuffix,
      'activeTime': instance.activeTime,
      'activeCode': instance.activeCode,
      'activeTimeZone': instance.activeTimeZone,
      'secRandom': instance.secRandom,
      'clientId': instance.clientId,
      'accountId': instance.accountId,
      'accountType': instance.accountType,
      'addedTime': instance.addedTime,
      'coins': instance.coins,
    };
