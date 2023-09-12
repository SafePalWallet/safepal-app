///
//  Generated code. Do not modify.
//  source: Wallet.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use messageTypeDescriptor instead')
const MessageType$json = const {
  '1': 'MessageType',
  '2': const [
    const {'1': 'MSG_UNKOWN', '2': 0},
    const {'1': 'MSG_BIND_ACCOUNT_REQUEST', '2': 2},
    const {'1': 'MSG_BIND_ACCOUNT_RESP', '2': 3},
    const {'1': 'MSG_GET_PUBKEY_REQUEST', '2': 4},
    const {'1': 'MSG_GET_PUBKEY_RESP', '2': 5},
    const {'1': 'MSG_BITCOIN_SIGN_REQUEST', '2': 6},
    const {'1': 'MSG_BITCOIN_SIGN_RESP', '2': 7},
    const {'1': 'MSG_ETH_SIGN_REQUEST', '2': 8},
    const {'1': 'MSG_ETH_SIGN_RESP', '2': 9},
    const {'1': 'MSG_CUSTOM_MSG_SIGN_REQUEST', '2': 34},
    const {'1': 'MSG_CUSTOM_MSG_SIGN_RESP', '2': 35},
  ],
};

/// Descriptor for `MessageType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messageTypeDescriptor = $convert.base64Decode('CgtNZXNzYWdlVHlwZRIOCgpNU0dfVU5LT1dOEAASHAoYTVNHX0JJTkRfQUNDT1VOVF9SRVFVRVNUEAISGQoVTVNHX0JJTkRfQUNDT1VOVF9SRVNQEAMSGgoWTVNHX0dFVF9QVUJLRVlfUkVRVUVTVBAEEhcKE01TR19HRVRfUFVCS0VZX1JFU1AQBRIcChhNU0dfQklUQ09JTl9TSUdOX1JFUVVFU1QQBhIZChVNU0dfQklUQ09JTl9TSUdOX1JFU1AQBxIYChRNU0dfRVRIX1NJR05fUkVRVUVTVBAIEhUKEU1TR19FVEhfU0lHTl9SRVNQEAkSHwobTVNHX0NVU1RPTV9NU0dfU0lHTl9SRVFVRVNUECISHAoYTVNHX0NVU1RPTV9NU0dfU0lHTl9SRVNQECM=');
@$core.Deprecated('Use coinTypeDescriptor instead')
const CoinType$json = const {
  '1': 'CoinType',
  '2': const [
    const {'1': 'COIN_TYPE_UNKOWN', '2': 0},
    const {'1': 'COIN_TYPE_BITCOIN', '2': 1},
    const {'1': 'COIN_TYPE_ETH', '2': 2},
    const {'1': 'COIN_TYPE_ERC20', '2': 3},
  ],
};

/// Descriptor for `CoinType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List coinTypeDescriptor = $convert.base64Decode('CghDb2luVHlwZRIUChBDT0lOX1RZUEVfVU5LT1dOEAASFQoRQ09JTl9UWVBFX0JJVENPSU4QARIRCg1DT0lOX1RZUEVfRVRIEAISEwoPQ09JTl9UWVBFX0VSQzIwEAM=');
@$core.Deprecated('Use bitcoinOutputFlagDescriptor instead')
const BitcoinOutputFlag$json = const {
  '1': 'BitcoinOutputFlag',
  '2': const [
    const {'1': 'BITCOIN_OUTPUT_FLAG_NO_CHANGE', '2': 0},
    const {'1': 'BITCOIN_OUTPUT_FLAG_CHANGE', '2': 1},
  ],
};

/// Descriptor for `BitcoinOutputFlag`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bitcoinOutputFlagDescriptor = $convert.base64Decode('ChFCaXRjb2luT3V0cHV0RmxhZxIhCh1CSVRDT0lOX09VVFBVVF9GTEFHX05PX0NIQU5HRRAAEh4KGkJJVENPSU5fT1VUUFVUX0ZMQUdfQ0hBTkdFEAE=');
@$core.Deprecated('Use packetHeaderDescriptor instead')
const PacketHeader$json = const {
  '1': 'PacketHeader',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 4, '10': 'time'},
    const {'1': 'time_zone', '3': 2, '4': 1, '5': 5, '10': 'timeZone'},
    const {'1': 'account_id', '3': 3, '4': 1, '5': 7, '10': 'accountId'},
    const {'1': 'version', '3': 4, '4': 1, '5': 13, '10': 'version'},
  ],
};

/// Descriptor for `PacketHeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetHeaderDescriptor = $convert.base64Decode('CgxQYWNrZXRIZWFkZXISEgoEdGltZRgBIAEoBFIEdGltZRIbCgl0aW1lX3pvbmUYAiABKAVSCHRpbWVab25lEh0KCmFjY291bnRfaWQYAyABKAdSCWFjY291bnRJZBIYCgd2ZXJzaW9uGAQgASgNUgd2ZXJzaW9u');
@$core.Deprecated('Use packetHeaderWrapperDescriptor instead')
const PacketHeaderWrapper$json = const {
  '1': 'PacketHeaderWrapper',
  '2': const [
    const {'1': 'header', '3': 15, '4': 1, '5': 11, '6': '.Wallet.PacketHeader', '10': 'header'},
  ],
};

/// Descriptor for `PacketHeaderWrapper`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetHeaderWrapperDescriptor = $convert.base64Decode('ChNQYWNrZXRIZWFkZXJXcmFwcGVyEiwKBmhlYWRlchgPIAEoCzIULldhbGxldC5QYWNrZXRIZWFkZXJSBmhlYWRlcg==');
@$core.Deprecated('Use packetRespHeaderDescriptor instead')
const PacketRespHeader$json = const {
  '1': 'PacketRespHeader',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 13, '10': 'version'},
  ],
};

/// Descriptor for `PacketRespHeader`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetRespHeaderDescriptor = $convert.base64Decode('ChBQYWNrZXRSZXNwSGVhZGVyEhgKB3ZlcnNpb24YASABKA1SB3ZlcnNpb24=');
@$core.Deprecated('Use packetRespHeaderWrapperDescriptor instead')
const PacketRespHeaderWrapper$json = const {
  '1': 'PacketRespHeaderWrapper',
  '2': const [
    const {'1': 'header', '3': 15, '4': 1, '5': 11, '6': '.Wallet.PacketRespHeader', '10': 'header'},
  ],
};

/// Descriptor for `PacketRespHeaderWrapper`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packetRespHeaderWrapperDescriptor = $convert.base64Decode('ChdQYWNrZXRSZXNwSGVhZGVyV3JhcHBlchIwCgZoZWFkZXIYDyABKAsyGC5XYWxsZXQuUGFja2V0UmVzcEhlYWRlclIGaGVhZGVy');
@$core.Deprecated('Use coinInfoDescriptor instead')
const CoinInfo$json = const {
  '1': 'CoinInfo',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    const {'1': 'uname', '3': 2, '4': 1, '5': 9, '10': 'uname'},
    const {'1': 'path', '3': 3, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `CoinInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinInfoDescriptor = $convert.base64Decode('CghDb2luSW5mbxISCgR0eXBlGAEgASgFUgR0eXBlEhQKBXVuYW1lGAIgASgJUgV1bmFtZRISCgRwYXRoGAMgASgJUgRwYXRo');
@$core.Deprecated('Use pubHDNodeDescriptor instead')
const PubHDNode$json = const {
  '1': 'PubHDNode',
  '2': const [
    const {'1': 'depth', '3': 1, '4': 1, '5': 13, '10': 'depth'},
    const {'1': 'fingerprint', '3': 2, '4': 1, '5': 13, '10': 'fingerprint'},
    const {'1': 'child_num', '3': 3, '4': 1, '5': 13, '10': 'childNum'},
    const {'1': 'chain_code', '3': 4, '4': 1, '5': 12, '10': 'chainCode'},
    const {'1': 'public_key', '3': 5, '4': 1, '5': 12, '10': 'publicKey'},
    const {'1': 'purpose', '3': 6, '4': 1, '5': 5, '10': 'purpose'},
    const {'1': 'curve', '3': 7, '4': 1, '5': 13, '10': 'curve'},
    const {'1': 'single_key', '3': 8, '4': 1, '5': 5, '10': 'singleKey'},
  ],
};

/// Descriptor for `PubHDNode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pubHDNodeDescriptor = $convert.base64Decode('CglQdWJIRE5vZGUSFAoFZGVwdGgYASABKA1SBWRlcHRoEiAKC2ZpbmdlcnByaW50GAIgASgNUgtmaW5nZXJwcmludBIbCgljaGlsZF9udW0YAyABKA1SCGNoaWxkTnVtEh0KCmNoYWluX2NvZGUYBCABKAxSCWNoYWluQ29kZRIdCgpwdWJsaWNfa2V5GAUgASgMUglwdWJsaWNLZXkSGAoHcHVycG9zZRgGIAEoBVIHcHVycG9zZRIUCgVjdXJ2ZRgHIAEoDVIFY3VydmUSHQoKc2luZ2xlX2tleRgIIAEoBVIJc2luZ2xlS2V5');
@$core.Deprecated('Use exchangeRateDescriptor instead')
const ExchangeRate$json = const {
  '1': 'ExchangeRate',
  '2': const [
    const {'1': 'amount', '3': 1, '4': 1, '5': 13, '10': 'amount'},
    const {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
    const {'1': 'symbol', '3': 3, '4': 1, '5': 9, '10': 'symbol'},
    const {'1': 'value', '3': 4, '4': 1, '5': 4, '10': 'value'},
  ],
};

/// Descriptor for `ExchangeRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeRateDescriptor = $convert.base64Decode('CgxFeGNoYW5nZVJhdGUSFgoGYW1vdW50GAEgASgNUgZhbW91bnQSGgoIY3VycmVuY3kYAiABKAlSCGN1cnJlbmN5EhYKBnN5bWJvbBgDIAEoCVIGc3ltYm9sEhQKBXZhbHVlGAQgASgEUgV2YWx1ZQ==');
@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = const {
  '1': 'DeviceInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'version', '3': 3, '4': 1, '5': 13, '10': 'version'},
    const {'1': 'se_version', '3': 4, '4': 1, '5': 13, '10': 'seVersion'},
    const {'1': 'product_sn', '3': 5, '4': 1, '5': 9, '10': 'productSn'},
    const {'1': 'product_series', '3': 6, '4': 1, '5': 9, '10': 'productSeries'},
    const {'1': 'product_type', '3': 7, '4': 1, '5': 9, '10': 'productType'},
    const {'1': 'product_name', '3': 8, '4': 1, '5': 9, '10': 'productName'},
    const {'1': 'product_brand', '3': 9, '4': 1, '5': 9, '10': 'productBrand'},
    const {'1': 'account_suffix', '3': 10, '4': 1, '5': 9, '10': 'accountSuffix'},
    const {'1': 'active_time', '3': 11, '4': 1, '5': 3, '10': 'activeTime'},
    const {'1': 'active_code', '3': 12, '4': 1, '5': 9, '10': 'activeCode'},
    const {'1': 'active_time_zone', '3': 13, '4': 1, '5': 5, '10': 'activeTimeZone'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode('CgpEZXZpY2VJbmZvEg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhgKB3ZlcnNpb24YAyABKA1SB3ZlcnNpb24SHQoKc2VfdmVyc2lvbhgEIAEoDVIJc2VWZXJzaW9uEh0KCnByb2R1Y3Rfc24YBSABKAlSCXByb2R1Y3RTbhIlCg5wcm9kdWN0X3NlcmllcxgGIAEoCVINcHJvZHVjdFNlcmllcxIhCgxwcm9kdWN0X3R5cGUYByABKAlSC3Byb2R1Y3RUeXBlEiEKDHByb2R1Y3RfbmFtZRgIIAEoCVILcHJvZHVjdE5hbWUSIwoNcHJvZHVjdF9icmFuZBgJIAEoCVIMcHJvZHVjdEJyYW5kEiUKDmFjY291bnRfc3VmZml4GAogASgJUg1hY2NvdW50U3VmZml4Eh8KC2FjdGl2ZV90aW1lGAsgASgDUgphY3RpdmVUaW1lEh8KC2FjdGl2ZV9jb2RlGAwgASgJUgphY3RpdmVDb2RlEigKEGFjdGl2ZV90aW1lX3pvbmUYDSABKAVSDmFjdGl2ZVRpbWVab25l');
@$core.Deprecated('Use coinPubkeyDescriptor instead')
const CoinPubkey$json = const {
  '1': 'CoinPubkey',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
    const {'1': 'node', '3': 2, '4': 1, '5': 11, '6': '.Wallet.PubHDNode', '10': 'node'},
    const {'1': 'ext_nodes', '3': 3, '4': 3, '5': 11, '6': '.Wallet.PubHDNode', '10': 'extNodes'},
  ],
};

/// Descriptor for `CoinPubkey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coinPubkeyDescriptor = $convert.base64Decode('CgpDb2luUHVia2V5EiQKBGNvaW4YASABKAsyEC5XYWxsZXQuQ29pbkluZm9SBGNvaW4SJQoEbm9kZRgCIAEoCzIRLldhbGxldC5QdWJIRE5vZGVSBG5vZGUSLgoJZXh0X25vZGVzGAMgAygLMhEuV2FsbGV0LlB1YkhETm9kZVIIZXh0Tm9kZXM=');
@$core.Deprecated('Use bindAccountReqDescriptor instead')
const BindAccountReq$json = const {
  '1': 'BindAccountReq',
  '2': const [
    const {'1': 'client_unique_id', '3': 1, '4': 1, '5': 9, '10': 'clientUniqueId'},
    const {'1': 'client_name', '3': 2, '4': 1, '5': 9, '10': 'clientName'},
    const {'1': 'sec_random', '3': 3, '4': 1, '5': 12, '10': 'secRandom'},
    const {'1': 'coin', '3': 4, '4': 3, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
    const {'1': 'version', '3': 5, '4': 1, '5': 5, '10': 'version'},
  ],
};

/// Descriptor for `BindAccountReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindAccountReqDescriptor = $convert.base64Decode('Cg5CaW5kQWNjb3VudFJlcRIoChBjbGllbnRfdW5pcXVlX2lkGAEgASgJUg5jbGllbnRVbmlxdWVJZBIfCgtjbGllbnRfbmFtZRgCIAEoCVIKY2xpZW50TmFtZRIdCgpzZWNfcmFuZG9tGAMgASgMUglzZWNSYW5kb20SJAoEY29pbhgEIAMoCzIQLldhbGxldC5Db2luSW5mb1IEY29pbhIYCgd2ZXJzaW9uGAUgASgFUgd2ZXJzaW9u');
@$core.Deprecated('Use bindAccountRespWrapperDescriptor instead')
const BindAccountRespWrapper$json = const {
  '1': 'BindAccountRespWrapper',
  '2': const [
    const {'1': 'client_unique_id', '3': 1, '4': 1, '5': 9, '10': 'clientUniqueId'},
    const {'1': 'sec_random', '3': 3, '4': 1, '5': 12, '10': 'secRandom'},
    const {'1': 'version', '3': 6, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'encoded_info', '3': 7, '4': 1, '5': 12, '10': 'encodedInfo'},
    const {'1': 'encoded_digest', '3': 8, '4': 1, '5': 12, '10': 'encodedDigest'},
  ],
};

/// Descriptor for `BindAccountRespWrapper`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindAccountRespWrapperDescriptor = $convert.base64Decode('ChZCaW5kQWNjb3VudFJlc3BXcmFwcGVyEigKEGNsaWVudF91bmlxdWVfaWQYASABKAlSDmNsaWVudFVuaXF1ZUlkEh0KCnNlY19yYW5kb20YAyABKAxSCXNlY1JhbmRvbRIYCgd2ZXJzaW9uGAYgASgFUgd2ZXJzaW9uEiEKDGVuY29kZWRfaW5mbxgHIAEoDFILZW5jb2RlZEluZm8SJQoOZW5jb2RlZF9kaWdlc3QYCCABKAxSDWVuY29kZWREaWdlc3Q=');
@$core.Deprecated('Use bindAccountRespDescriptor instead')
const BindAccountResp$json = const {
  '1': 'BindAccountResp',
  '2': const [
    const {'1': 'client_unique_id', '3': 1, '4': 1, '5': 9, '10': 'clientUniqueId'},
    const {'1': 'client_id', '3': 2, '4': 1, '5': 13, '10': 'clientId'},
    const {'1': 'sec_random', '3': 3, '4': 1, '5': 12, '10': 'secRandom'},
    const {'1': 'device_info', '3': 4, '4': 1, '5': 11, '6': '.Wallet.DeviceInfo', '10': 'deviceInfo'},
    const {'1': 'pubkey', '3': 5, '4': 3, '5': 11, '6': '.Wallet.CoinPubkey', '10': 'pubkey'},
    const {'1': 'version', '3': 6, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'account_id', '3': 9, '4': 1, '5': 13, '10': 'accountId'},
    const {'1': 'account_suffix', '3': 10, '4': 1, '5': 9, '10': 'accountSuffix'},
    const {'1': 'account_type', '3': 11, '4': 1, '5': 13, '10': 'accountType'},
  ],
};

/// Descriptor for `BindAccountResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bindAccountRespDescriptor = $convert.base64Decode('Cg9CaW5kQWNjb3VudFJlc3ASKAoQY2xpZW50X3VuaXF1ZV9pZBgBIAEoCVIOY2xpZW50VW5pcXVlSWQSGwoJY2xpZW50X2lkGAIgASgNUghjbGllbnRJZBIdCgpzZWNfcmFuZG9tGAMgASgMUglzZWNSYW5kb20SMwoLZGV2aWNlX2luZm8YBCABKAsyEi5XYWxsZXQuRGV2aWNlSW5mb1IKZGV2aWNlSW5mbxIqCgZwdWJrZXkYBSADKAsyEi5XYWxsZXQuQ29pblB1YmtleVIGcHVia2V5EhgKB3ZlcnNpb24YBiABKAVSB3ZlcnNpb24SHQoKYWNjb3VudF9pZBgJIAEoDVIJYWNjb3VudElkEiUKDmFjY291bnRfc3VmZml4GAogASgJUg1hY2NvdW50U3VmZml4EiEKDGFjY291bnRfdHlwZRgLIAEoDVILYWNjb3VudFR5cGU=');
@$core.Deprecated('Use getPubkeyReqDescriptor instead')
const GetPubkeyReq$json = const {
  '1': 'GetPubkeyReq',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 3, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
  ],
};

/// Descriptor for `GetPubkeyReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPubkeyReqDescriptor = $convert.base64Decode('CgxHZXRQdWJrZXlSZXESJAoEY29pbhgBIAMoCzIQLldhbGxldC5Db2luSW5mb1IEY29pbg==');
@$core.Deprecated('Use getPubkeyRespDescriptor instead')
const GetPubkeyResp$json = const {
  '1': 'GetPubkeyResp',
  '2': const [
    const {'1': 'pubkey', '3': 1, '4': 3, '5': 11, '6': '.Wallet.CoinPubkey', '10': 'pubkey'},
    const {'1': 'device_info', '3': 2, '4': 1, '5': 11, '6': '.Wallet.DeviceInfo', '10': 'deviceInfo'},
  ],
};

/// Descriptor for `GetPubkeyResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPubkeyRespDescriptor = $convert.base64Decode('Cg1HZXRQdWJrZXlSZXNwEioKBnB1YmtleRgBIAMoCzISLldhbGxldC5Db2luUHVia2V5UgZwdWJrZXkSMwoLZGV2aWNlX2luZm8YAiABKAsyEi5XYWxsZXQuRGV2aWNlSW5mb1IKZGV2aWNlSW5mbw==');
@$core.Deprecated('Use bitcoinInputDescriptor instead')
const BitcoinInput$json = const {
  '1': 'BitcoinInput',
  '2': const [
    const {'1': 'txid', '3': 1, '4': 1, '5': 12, '10': 'txid'},
    const {'1': 'script', '3': 2, '4': 1, '5': 12, '10': 'script'},
    const {'1': 'index', '3': 3, '4': 1, '5': 13, '10': 'index'},
    const {'1': 'path', '3': 4, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'value', '3': 5, '4': 1, '5': 4, '10': 'value'},
    const {'1': 'address', '3': 6, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `BitcoinInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bitcoinInputDescriptor = $convert.base64Decode('CgxCaXRjb2luSW5wdXQSEgoEdHhpZBgBIAEoDFIEdHhpZBIWCgZzY3JpcHQYAiABKAxSBnNjcmlwdBIUCgVpbmRleBgDIAEoDVIFaW5kZXgSEgoEcGF0aBgEIAEoCVIEcGF0aBIUCgV2YWx1ZRgFIAEoBFIFdmFsdWUSGAoHYWRkcmVzcxgGIAEoCVIHYWRkcmVzcw==');
@$core.Deprecated('Use bitcoinOutputDescriptor instead')
const BitcoinOutput$json = const {
  '1': 'BitcoinOutput',
  '2': const [
    const {'1': 'address', '3': 1, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'value', '3': 2, '4': 1, '5': 4, '10': 'value'},
    const {'1': 'flag', '3': 3, '4': 1, '5': 13, '10': 'flag'},
    const {'1': 'path', '3': 4, '4': 1, '5': 9, '10': 'path'},
  ],
};

/// Descriptor for `BitcoinOutput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bitcoinOutputDescriptor = $convert.base64Decode('Cg1CaXRjb2luT3V0cHV0EhgKB2FkZHJlc3MYASABKAlSB2FkZHJlc3MSFAoFdmFsdWUYAiABKARSBXZhbHVlEhIKBGZsYWcYAyABKA1SBGZsYWcSEgoEcGF0aBgEIAEoCVIEcGF0aA==');
@$core.Deprecated('Use bitcoinSignRequestDescriptor instead')
const BitcoinSignRequest$json = const {
  '1': 'BitcoinSignRequest',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
    const {'1': 'inputs', '3': 2, '4': 3, '5': 11, '6': '.Wallet.BitcoinInput', '10': 'inputs'},
    const {'1': 'outputs', '3': 3, '4': 3, '5': 11, '6': '.Wallet.BitcoinOutput', '10': 'outputs'},
    const {'1': 'exchange', '3': 4, '4': 1, '5': 11, '6': '.Wallet.ExchangeRate', '10': 'exchange'},
    const {'1': 'max_receive_index', '3': 5, '4': 1, '5': 3, '10': 'maxReceiveIndex'},
    const {'1': 'lock_time', '3': 6, '4': 1, '5': 13, '10': 'lockTime'},
    const {'1': 'expiry', '3': 7, '4': 1, '5': 13, '10': 'expiry'},
    const {'1': 'branch_id', '3': 8, '4': 1, '5': 13, '10': 'branchId'},
  ],
};

/// Descriptor for `BitcoinSignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bitcoinSignRequestDescriptor = $convert.base64Decode('ChJCaXRjb2luU2lnblJlcXVlc3QSJAoEY29pbhgBIAEoCzIQLldhbGxldC5Db2luSW5mb1IEY29pbhIsCgZpbnB1dHMYAiADKAsyFC5XYWxsZXQuQml0Y29pbklucHV0UgZpbnB1dHMSLwoHb3V0cHV0cxgDIAMoCzIVLldhbGxldC5CaXRjb2luT3V0cHV0UgdvdXRwdXRzEjAKCGV4Y2hhbmdlGAQgASgLMhQuV2FsbGV0LkV4Y2hhbmdlUmF0ZVIIZXhjaGFuZ2USKgoRbWF4X3JlY2VpdmVfaW5kZXgYBSABKANSD21heFJlY2VpdmVJbmRleBIbCglsb2NrX3RpbWUYBiABKA1SCGxvY2tUaW1lEhYKBmV4cGlyeRgHIAEoDVIGZXhwaXJ5EhsKCWJyYW5jaF9pZBgIIAEoDVIIYnJhbmNoSWQ=');
@$core.Deprecated('Use bitcoinSignResponeDescriptor instead')
const BitcoinSignRespone$json = const {
  '1': 'BitcoinSignRespone',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
    const {'1': 'result_code', '3': 2, '4': 1, '5': 5, '10': 'resultCode'},
    const {'1': 'tx_data', '3': 3, '4': 1, '5': 12, '10': 'txData'},
  ],
};

/// Descriptor for `BitcoinSignRespone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bitcoinSignResponeDescriptor = $convert.base64Decode('ChJCaXRjb2luU2lnblJlc3BvbmUSJAoEY29pbhgBIAEoCzIQLldhbGxldC5Db2luSW5mb1IEY29pbhIfCgtyZXN1bHRfY29kZRgCIAEoBVIKcmVzdWx0Q29kZRIXCgd0eF9kYXRhGAMgASgMUgZ0eERhdGE=');
@$core.Deprecated('Use ethTokenInfoDescriptor instead')
const EthTokenInfo$json = const {
  '1': 'EthTokenInfo',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 5, '10': 'type'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'symbol', '3': 3, '4': 1, '5': 9, '10': 'symbol'},
    const {'1': 'decimals', '3': 4, '4': 1, '5': 5, '10': 'decimals'},
  ],
};

/// Descriptor for `EthTokenInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ethTokenInfoDescriptor = $convert.base64Decode('CgxFdGhUb2tlbkluZm8SEgoEdHlwZRgBIAEoBVIEdHlwZRISCgRuYW1lGAIgASgJUgRuYW1lEhYKBnN5bWJvbBgDIAEoCVIGc3ltYm9sEhoKCGRlY2ltYWxzGAQgASgFUghkZWNpbWFscw==');
@$core.Deprecated('Use ethContractInfoDescriptor instead')
const EthContractInfo$json = const {
  '1': 'EthContractInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 12, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `EthContractInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ethContractInfoDescriptor = $convert.base64Decode('Cg9FdGhDb250cmFjdEluZm8SDgoCaWQYASABKAxSAmlkEhIKBG5hbWUYAiABKAlSBG5hbWU=');
@$core.Deprecated('Use ethEIP1559GasFeeDescriptor instead')
const EthEIP1559GasFee$json = const {
  '1': 'EthEIP1559GasFee',
  '2': const [
    const {'1': 'estimated_base_fee_per_gas', '3': 1, '4': 1, '5': 4, '10': 'estimatedBaseFeePerGas'},
    const {'1': 'max_priority_fee_per_gas', '3': 2, '4': 1, '5': 4, '10': 'maxPriorityFeePerGas'},
    const {'1': 'max_fee_per_gas', '3': 3, '4': 1, '5': 4, '10': 'maxFeePerGas'},
  ],
};

/// Descriptor for `EthEIP1559GasFee`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ethEIP1559GasFeeDescriptor = $convert.base64Decode('ChBFdGhFSVAxNTU5R2FzRmVlEjoKGmVzdGltYXRlZF9iYXNlX2ZlZV9wZXJfZ2FzGAEgASgEUhZlc3RpbWF0ZWRCYXNlRmVlUGVyR2FzEjYKGG1heF9wcmlvcml0eV9mZWVfcGVyX2dhcxgCIAEoBFIUbWF4UHJpb3JpdHlGZWVQZXJHYXMSJQoPbWF4X2ZlZV9wZXJfZ2FzGAMgASgEUgxtYXhGZWVQZXJHYXM=');
@$core.Deprecated('Use ethChainInfoDescriptor instead')
const EthChainInfo$json = const {
  '1': 'EthChainInfo',
  '2': const [
    const {'1': 'chain_name', '3': 1, '4': 1, '5': 9, '10': 'chainName'},
    const {'1': 'chain_id', '3': 2, '4': 1, '5': 4, '10': 'chainId'},
    const {'1': 'native_name', '3': 3, '4': 1, '5': 9, '10': 'nativeName'},
    const {'1': 'native_symbol', '3': 4, '4': 1, '5': 9, '10': 'nativeSymbol'},
    const {'1': 'native_decimals', '3': 5, '4': 1, '5': 13, '10': 'nativeDecimals'},
    const {'1': 'rpc_url', '3': 6, '4': 1, '5': 9, '10': 'rpcUrl'},
  ],
};

/// Descriptor for `EthChainInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ethChainInfoDescriptor = $convert.base64Decode('CgxFdGhDaGFpbkluZm8SHQoKY2hhaW5fbmFtZRgBIAEoCVIJY2hhaW5OYW1lEhkKCGNoYWluX2lkGAIgASgEUgdjaGFpbklkEh8KC25hdGl2ZV9uYW1lGAMgASgJUgpuYXRpdmVOYW1lEiMKDW5hdGl2ZV9zeW1ib2wYBCABKAlSDG5hdGl2ZVN5bWJvbBInCg9uYXRpdmVfZGVjaW1hbHMYBSABKA1SDm5hdGl2ZURlY2ltYWxzEhcKB3JwY191cmwYBiABKAlSBnJwY1VybA==');
@$core.Deprecated('Use ethSignRequestDescriptor instead')
const EthSignRequest$json = const {
  '1': 'EthSignRequest',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
    const {'1': 'nonce', '3': 2, '4': 1, '5': 4, '10': 'nonce'},
    const {'1': 'gas_price', '3': 3, '4': 1, '5': 4, '10': 'gasPrice'},
    const {'1': 'gas_limit', '3': 4, '4': 1, '5': 4, '10': 'gasLimit'},
    const {'1': 'to', '3': 5, '4': 1, '5': 12, '10': 'to'},
    const {'1': 'value', '3': 6, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'data', '3': 7, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'chain_id', '3': 8, '4': 1, '5': 4, '10': 'chainId'},
    const {'1': 'tx_type', '3': 9, '4': 1, '5': 13, '10': 'txType'},
    const {'1': 'exchange', '3': 10, '4': 1, '5': 11, '6': '.Wallet.ExchangeRate', '10': 'exchange'},
    const {'1': 'token', '3': 11, '4': 1, '5': 11, '6': '.Wallet.EthTokenInfo', '10': 'token'},
    const {'1': 'contract', '3': 12, '4': 1, '5': 11, '6': '.Wallet.EthContractInfo', '10': 'contract'},
    const {'1': 'sign_type', '3': 13, '4': 1, '5': 5, '10': 'signType'},
    const {'1': 'transaction_type', '3': 14, '4': 1, '5': 5, '10': 'transactionType'},
    const {'1': 'ext_req_data', '3': 15, '4': 1, '5': 12, '10': 'extReqData'},
    const {'1': 'chain_info', '3': 16, '4': 1, '5': 11, '6': '.Wallet.EthChainInfo', '10': 'chainInfo'},
  ],
};

/// Descriptor for `EthSignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ethSignRequestDescriptor = $convert.base64Decode('Cg5FdGhTaWduUmVxdWVzdBIkCgRjb2luGAEgASgLMhAuV2FsbGV0LkNvaW5JbmZvUgRjb2luEhQKBW5vbmNlGAIgASgEUgVub25jZRIbCglnYXNfcHJpY2UYAyABKARSCGdhc1ByaWNlEhsKCWdhc19saW1pdBgEIAEoBFIIZ2FzTGltaXQSDgoCdG8YBSABKAxSAnRvEhQKBXZhbHVlGAYgASgMUgV2YWx1ZRISCgRkYXRhGAcgASgMUgRkYXRhEhkKCGNoYWluX2lkGAggASgEUgdjaGFpbklkEhcKB3R4X3R5cGUYCSABKA1SBnR4VHlwZRIwCghleGNoYW5nZRgKIAEoCzIULldhbGxldC5FeGNoYW5nZVJhdGVSCGV4Y2hhbmdlEioKBXRva2VuGAsgASgLMhQuV2FsbGV0LkV0aFRva2VuSW5mb1IFdG9rZW4SMwoIY29udHJhY3QYDCABKAsyFy5XYWxsZXQuRXRoQ29udHJhY3RJbmZvUghjb250cmFjdBIbCglzaWduX3R5cGUYDSABKAVSCHNpZ25UeXBlEikKEHRyYW5zYWN0aW9uX3R5cGUYDiABKAVSD3RyYW5zYWN0aW9uVHlwZRIgCgxleHRfcmVxX2RhdGEYDyABKAxSCmV4dFJlcURhdGESMwoKY2hhaW5faW5mbxgQIAEoCzIULldhbGxldC5FdGhDaGFpbkluZm9SCWNoYWluSW5mbw==');
@$core.Deprecated('Use ethSignResponeDescriptor instead')
const EthSignRespone$json = const {
  '1': 'EthSignRespone',
  '2': const [
    const {'1': 'tx_data', '3': 1, '4': 1, '5': 12, '10': 'txData'},
    const {'1': 'sign_type', '3': 2, '4': 1, '5': 5, '10': 'signType'},
  ],
};

/// Descriptor for `EthSignRespone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ethSignResponeDescriptor = $convert.base64Decode('Cg5FdGhTaWduUmVzcG9uZRIXCgd0eF9kYXRhGAEgASgMUgZ0eERhdGESGwoJc2lnbl90eXBlGAIgASgFUghzaWduVHlwZQ==');
@$core.Deprecated('Use withdrawMessageDescriptor instead')
const WithdrawMessage$json = const {
  '1': 'WithdrawMessage',
  '2': const [
    const {'1': 'coin_name', '3': 1, '4': 1, '5': 9, '10': 'coinName'},
    const {'1': 'addrss', '3': 2, '4': 1, '5': 9, '10': 'addrss'},
    const {'1': 'address_tag', '3': 3, '4': 1, '5': 9, '10': 'addressTag'},
    const {'1': 'value', '3': 4, '4': 1, '5': 4, '10': 'value'},
    const {'1': 'tag_name', '3': 5, '4': 1, '5': 9, '10': 'tagName'},
  ],
};

/// Descriptor for `WithdrawMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawMessageDescriptor = $convert.base64Decode('Cg9XaXRoZHJhd01lc3NhZ2USGwoJY29pbl9uYW1lGAEgASgJUghjb2luTmFtZRIWCgZhZGRyc3MYAiABKAlSBmFkZHJzcxIfCgthZGRyZXNzX3RhZxgDIAEoCVIKYWRkcmVzc1RhZxIUCgV2YWx1ZRgEIAEoBFIFdmFsdWUSGQoIdGFnX25hbWUYBSABKAlSB3RhZ05hbWU=');
@$core.Deprecated('Use typedDataMessageDescriptor instead')
const TypedDataMessage$json = const {
  '1': 'TypedDataMessage',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'raw', '3': 2, '4': 1, '5': 9, '10': 'raw'},
    const {'1': 'hash_msg', '3': 3, '4': 1, '5': 12, '10': 'hashMsg'},
    const {'1': 'display_msg', '3': 4, '4': 1, '5': 9, '10': 'displayMsg'},
  ],
};

/// Descriptor for `TypedDataMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List typedDataMessageDescriptor = $convert.base64Decode('ChBUeXBlZERhdGFNZXNzYWdlEhgKB3ZlcnNpb24YASABKAVSB3ZlcnNpb24SEAoDcmF3GAIgASgJUgNyYXcSGQoIaGFzaF9tc2cYAyABKAxSB2hhc2hNc2cSHwoLZGlzcGxheV9tc2cYBCABKAlSCmRpc3BsYXlNc2c=');
@$core.Deprecated('Use custmsgSignRequestDescriptor instead')
const CustmsgSignRequest$json = const {
  '1': 'CustmsgSignRequest',
  '2': const [
    const {'1': 'coin', '3': 1, '4': 1, '5': 11, '6': '.Wallet.CoinInfo', '10': 'coin'},
    const {'1': 'path', '3': 2, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'msg_type', '3': 3, '4': 1, '5': 5, '10': 'msgType'},
    const {'1': 'msg', '3': 4, '4': 1, '5': 9, '10': 'msg'},
    const {'1': 'my_address', '3': 5, '4': 1, '5': 9, '10': 'myAddress'},
    const {'1': 'version', '3': 6, '4': 1, '5': 5, '10': 'version'},
    const {'1': 'app_name', '3': 7, '4': 1, '5': 9, '10': 'appName'},
    const {'1': 'withdraw', '3': 8, '4': 1, '5': 11, '6': '.Wallet.WithdrawMessage', '10': 'withdraw'},
    const {'1': 'bin_msg', '3': 9, '4': 1, '5': 12, '10': 'binMsg'},
    const {'1': 'typed_data', '3': 10, '4': 1, '5': 11, '6': '.Wallet.TypedDataMessage', '10': 'typedData'},
  ],
};

/// Descriptor for `CustmsgSignRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List custmsgSignRequestDescriptor = $convert.base64Decode('ChJDdXN0bXNnU2lnblJlcXVlc3QSJAoEY29pbhgBIAEoCzIQLldhbGxldC5Db2luSW5mb1IEY29pbhISCgRwYXRoGAIgASgJUgRwYXRoEhkKCG1zZ190eXBlGAMgASgFUgdtc2dUeXBlEhAKA21zZxgEIAEoCVIDbXNnEh0KCm15X2FkZHJlc3MYBSABKAlSCW15QWRkcmVzcxIYCgd2ZXJzaW9uGAYgASgFUgd2ZXJzaW9uEhkKCGFwcF9uYW1lGAcgASgJUgdhcHBOYW1lEjMKCHdpdGhkcmF3GAggASgLMhcuV2FsbGV0LldpdGhkcmF3TWVzc2FnZVIId2l0aGRyYXcSFwoHYmluX21zZxgJIAEoDFIGYmluTXNnEjcKCnR5cGVkX2RhdGEYCiABKAsyGC5XYWxsZXQuVHlwZWREYXRhTWVzc2FnZVIJdHlwZWREYXRh');
@$core.Deprecated('Use custmsgSignResponeDescriptor instead')
const CustmsgSignRespone$json = const {
  '1': 'CustmsgSignRespone',
  '2': const [
    const {'1': 'coin_type', '3': 1, '4': 1, '5': 5, '10': 'coinType'},
    const {'1': 'msg_type', '3': 2, '4': 1, '5': 5, '10': 'msgType'},
    const {'1': 'sign_data', '3': 3, '4': 1, '5': 12, '10': 'signData'},
  ],
};

/// Descriptor for `CustmsgSignRespone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List custmsgSignResponeDescriptor = $convert.base64Decode('ChJDdXN0bXNnU2lnblJlc3BvbmUSGwoJY29pbl90eXBlGAEgASgFUghjb2luVHlwZRIZCghtc2dfdHlwZRgCIAEoBVIHbXNnVHlwZRIbCglzaWduX2RhdGEYAyABKAxSCHNpZ25EYXRh');
