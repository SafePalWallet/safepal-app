// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chain_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChainConfig _$ChainConfigFromJson(Map<String, dynamic> json) => ChainConfig(
      id: json['id'] as String,
      type: json['type'] as int,
      uname: json['uname'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      decimals: json['decimals'] as int,
      blockchain: json['blockchain'] as String,
      derivationPath: json['derivationPath'] as String,
      curve: json['curve'] as String?,
      publicKeyType: json['publicKeyType'] as String?,
      staticPrefix: json['staticPrefix'] as int?,
      p2pkhPrefix: json['p2pkhPrefix'] as int?,
      p2shPrefix: json['p2shPrefix'] as int?,
      hrp: json['hrp'] as String?,
      publicKeyHasher: json['publicKeyHasher'] as String?,
      base58Hasher: json['base58Hasher'] as String?,
      explorer: json['explorer'] as String?,
      account: json['account'] as String?,
      logo: json['logo'] as String?,
      chainLogo: json['chainLogo'] as String?,
      chainId: json['chainId'] as int?,
      supportedPurposes: json['supportedPurposes'] as String?,
    );

Map<String, dynamic> _$ChainConfigToJson(ChainConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'uname': instance.uname,
      'name': instance.name,
      'symbol': instance.symbol,
      'decimals': instance.decimals,
      'blockchain': instance.blockchain,
      'derivationPath': instance.derivationPath,
      'curve': instance.curve,
      'publicKeyType': instance.publicKeyType,
      'staticPrefix': instance.staticPrefix,
      'p2pkhPrefix': instance.p2pkhPrefix,
      'p2shPrefix': instance.p2shPrefix,
      'hrp': instance.hrp,
      'publicKeyHasher': instance.publicKeyHasher,
      'base58Hasher': instance.base58Hasher,
      'explorer': instance.explorer,
      'account': instance.account,
      'logo': instance.logo,
      'chainLogo': instance.chainLogo,
      'chainId': instance.chainId,
      'supportedPurposes': instance.supportedPurposes,
    };
