// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bitcoin_unspend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BitcoinUnspend _$BitcoinUnspendFromJson(Map<String, dynamic> json) =>
    BitcoinUnspend(
      txid: json['txid'] as String?,
      txIndex: json['vout'] as int?,
      amount: json['value'] as String?,
      confirmations: json['confirmations'] as int?,
      lockTime: json['lockTime'] as int?,
      address: json['address'] as String?,
      path: json['path'] as String?,
      coinbase: json['coinbase'] as int?,
    );

Map<String, dynamic> _$BitcoinUnspendToJson(BitcoinUnspend instance) =>
    <String, dynamic>{
      'txid': instance.txid,
      'vout': instance.txIndex,
      'value': instance.amount,
      'confirmations': instance.confirmations,
      'lockTime': instance.lockTime,
      'address': instance.address,
      'path': instance.path,
      'coinbase': instance.coinbase,
    };
