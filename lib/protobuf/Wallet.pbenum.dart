///
//  Generated code. Do not modify.
//  source: Wallet.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class MessageType extends $pb.ProtobufEnum {
  static const MessageType MSG_UNKOWN = MessageType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_UNKOWN');
  static const MessageType MSG_BIND_ACCOUNT_REQUEST = MessageType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_BIND_ACCOUNT_REQUEST');
  static const MessageType MSG_BIND_ACCOUNT_RESP = MessageType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_BIND_ACCOUNT_RESP');
  static const MessageType MSG_GET_PUBKEY_REQUEST = MessageType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_GET_PUBKEY_REQUEST');
  static const MessageType MSG_GET_PUBKEY_RESP = MessageType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_GET_PUBKEY_RESP');
  static const MessageType MSG_BITCOIN_SIGN_REQUEST = MessageType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_BITCOIN_SIGN_REQUEST');
  static const MessageType MSG_BITCOIN_SIGN_RESP = MessageType._(7, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_BITCOIN_SIGN_RESP');
  static const MessageType MSG_ETH_SIGN_REQUEST = MessageType._(8, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_ETH_SIGN_REQUEST');
  static const MessageType MSG_ETH_SIGN_RESP = MessageType._(9, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_ETH_SIGN_RESP');
  static const MessageType MSG_CUSTOM_MSG_SIGN_REQUEST = MessageType._(34, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_CUSTOM_MSG_SIGN_REQUEST');
  static const MessageType MSG_CUSTOM_MSG_SIGN_RESP = MessageType._(35, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'MSG_CUSTOM_MSG_SIGN_RESP');

  static const $core.List<MessageType> values = <MessageType> [
    MSG_UNKOWN,
    MSG_BIND_ACCOUNT_REQUEST,
    MSG_BIND_ACCOUNT_RESP,
    MSG_GET_PUBKEY_REQUEST,
    MSG_GET_PUBKEY_RESP,
    MSG_BITCOIN_SIGN_REQUEST,
    MSG_BITCOIN_SIGN_RESP,
    MSG_ETH_SIGN_REQUEST,
    MSG_ETH_SIGN_RESP,
    MSG_CUSTOM_MSG_SIGN_REQUEST,
    MSG_CUSTOM_MSG_SIGN_RESP,
  ];

  static final $core.Map<$core.int, MessageType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageType? valueOf($core.int value) => _byValue[value];

  const MessageType._($core.int v, $core.String n) : super(v, n);
}

class CoinType extends $pb.ProtobufEnum {
  static const CoinType COIN_TYPE_UNKOWN = CoinType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COIN_TYPE_UNKOWN');
  static const CoinType COIN_TYPE_BITCOIN = CoinType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COIN_TYPE_BITCOIN');
  static const CoinType COIN_TYPE_ETH = CoinType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COIN_TYPE_ETH');
  static const CoinType COIN_TYPE_ERC20 = CoinType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'COIN_TYPE_ERC20');

  static const $core.List<CoinType> values = <CoinType> [
    COIN_TYPE_UNKOWN,
    COIN_TYPE_BITCOIN,
    COIN_TYPE_ETH,
    COIN_TYPE_ERC20,
  ];

  static final $core.Map<$core.int, CoinType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static CoinType? valueOf($core.int value) => _byValue[value];

  const CoinType._($core.int v, $core.String n) : super(v, n);
}

class BitcoinOutputFlag extends $pb.ProtobufEnum {
  static const BitcoinOutputFlag BITCOIN_OUTPUT_FLAG_NO_CHANGE = BitcoinOutputFlag._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BITCOIN_OUTPUT_FLAG_NO_CHANGE');
  static const BitcoinOutputFlag BITCOIN_OUTPUT_FLAG_CHANGE = BitcoinOutputFlag._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'BITCOIN_OUTPUT_FLAG_CHANGE');

  static const $core.List<BitcoinOutputFlag> values = <BitcoinOutputFlag> [
    BITCOIN_OUTPUT_FLAG_NO_CHANGE,
    BITCOIN_OUTPUT_FLAG_CHANGE,
  ];

  static final $core.Map<$core.int, BitcoinOutputFlag> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BitcoinOutputFlag? valueOf($core.int value) => _byValue[value];

  const BitcoinOutputFlag._($core.int v, $core.String n) : super(v, n);
}

