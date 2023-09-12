///
//  Generated code. Do not modify.
//  source: Wallet.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'Wallet.pbenum.dart';

class PacketHeader extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PacketHeader', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timeZone', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountId', $pb.PbFieldType.OF3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  PacketHeader._() : super();
  factory PacketHeader({
    $fixnum.Int64? time,
    $core.int? timeZone,
    $core.int? accountId,
    $core.int? version,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (timeZone != null) {
      _result.timeZone = timeZone;
    }
    if (accountId != null) {
      _result.accountId = accountId;
    }
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory PacketHeader.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PacketHeader.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PacketHeader clone() => PacketHeader()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PacketHeader copyWith(void Function(PacketHeader) updates) => super.copyWith((message) => updates(message as PacketHeader)) as PacketHeader; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PacketHeader create() => PacketHeader._();
  PacketHeader createEmptyInstance() => create();
  static $pb.PbList<PacketHeader> createRepeated() => $pb.PbList<PacketHeader>();
  @$core.pragma('dart2js:noInline')
  static PacketHeader getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PacketHeader>(create);
  static PacketHeader? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get time => $_getI64(0);
  @$pb.TagNumber(1)
  set time($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get timeZone => $_getIZ(1);
  @$pb.TagNumber(2)
  set timeZone($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimeZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimeZone() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get accountId => $_getIZ(2);
  @$pb.TagNumber(3)
  set accountId($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAccountId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAccountId() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get version => $_getIZ(3);
  @$pb.TagNumber(4)
  set version($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => clearField(4);
}

class PacketHeaderWrapper extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PacketHeaderWrapper', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<PacketHeader>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'header', subBuilder: PacketHeader.create)
    ..hasRequiredFields = false
  ;

  PacketHeaderWrapper._() : super();
  factory PacketHeaderWrapper({
    PacketHeader? header,
  }) {
    final _result = create();
    if (header != null) {
      _result.header = header;
    }
    return _result;
  }
  factory PacketHeaderWrapper.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PacketHeaderWrapper.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PacketHeaderWrapper clone() => PacketHeaderWrapper()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PacketHeaderWrapper copyWith(void Function(PacketHeaderWrapper) updates) => super.copyWith((message) => updates(message as PacketHeaderWrapper)) as PacketHeaderWrapper; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PacketHeaderWrapper create() => PacketHeaderWrapper._();
  PacketHeaderWrapper createEmptyInstance() => create();
  static $pb.PbList<PacketHeaderWrapper> createRepeated() => $pb.PbList<PacketHeaderWrapper>();
  @$core.pragma('dart2js:noInline')
  static PacketHeaderWrapper getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PacketHeaderWrapper>(create);
  static PacketHeaderWrapper? _defaultInstance;

  @$pb.TagNumber(15)
  PacketHeader get header => $_getN(0);
  @$pb.TagNumber(15)
  set header(PacketHeader v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(15)
  void clearHeader() => clearField(15);
  @$pb.TagNumber(15)
  PacketHeader ensureHeader() => $_ensure(0);
}

class PacketRespHeader extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PacketRespHeader', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  PacketRespHeader._() : super();
  factory PacketRespHeader({
    $core.int? version,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory PacketRespHeader.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PacketRespHeader.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PacketRespHeader clone() => PacketRespHeader()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PacketRespHeader copyWith(void Function(PacketRespHeader) updates) => super.copyWith((message) => updates(message as PacketRespHeader)) as PacketRespHeader; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PacketRespHeader create() => PacketRespHeader._();
  PacketRespHeader createEmptyInstance() => create();
  static $pb.PbList<PacketRespHeader> createRepeated() => $pb.PbList<PacketRespHeader>();
  @$core.pragma('dart2js:noInline')
  static PacketRespHeader getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PacketRespHeader>(create);
  static PacketRespHeader? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);
}

class PacketRespHeaderWrapper extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PacketRespHeaderWrapper', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<PacketRespHeader>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'header', subBuilder: PacketRespHeader.create)
    ..hasRequiredFields = false
  ;

  PacketRespHeaderWrapper._() : super();
  factory PacketRespHeaderWrapper({
    PacketRespHeader? header,
  }) {
    final _result = create();
    if (header != null) {
      _result.header = header;
    }
    return _result;
  }
  factory PacketRespHeaderWrapper.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PacketRespHeaderWrapper.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PacketRespHeaderWrapper clone() => PacketRespHeaderWrapper()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PacketRespHeaderWrapper copyWith(void Function(PacketRespHeaderWrapper) updates) => super.copyWith((message) => updates(message as PacketRespHeaderWrapper)) as PacketRespHeaderWrapper; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PacketRespHeaderWrapper create() => PacketRespHeaderWrapper._();
  PacketRespHeaderWrapper createEmptyInstance() => create();
  static $pb.PbList<PacketRespHeaderWrapper> createRepeated() => $pb.PbList<PacketRespHeaderWrapper>();
  @$core.pragma('dart2js:noInline')
  static PacketRespHeaderWrapper getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PacketRespHeaderWrapper>(create);
  static PacketRespHeaderWrapper? _defaultInstance;

  @$pb.TagNumber(15)
  PacketRespHeader get header => $_getN(0);
  @$pb.TagNumber(15)
  set header(PacketRespHeader v) { setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(15)
  void clearHeader() => clearField(15);
  @$pb.TagNumber(15)
  PacketRespHeader ensureHeader() => $_ensure(0);
}

class CoinInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uname')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..hasRequiredFields = false
  ;

  CoinInfo._() : super();
  factory CoinInfo({
    $core.int? type,
    $core.String? uname,
    $core.String? path,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (uname != null) {
      _result.uname = uname;
    }
    if (path != null) {
      _result.path = path;
    }
    return _result;
  }
  factory CoinInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoinInfo clone() => CoinInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoinInfo copyWith(void Function(CoinInfo) updates) => super.copyWith((message) => updates(message as CoinInfo)) as CoinInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinInfo create() => CoinInfo._();
  CoinInfo createEmptyInstance() => create();
  static $pb.PbList<CoinInfo> createRepeated() => $pb.PbList<CoinInfo>();
  @$core.pragma('dart2js:noInline')
  static CoinInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinInfo>(create);
  static CoinInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get uname => $_getSZ(1);
  @$pb.TagNumber(2)
  set uname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUname() => $_has(1);
  @$pb.TagNumber(2)
  void clearUname() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get path => $_getSZ(2);
  @$pb.TagNumber(3)
  set path($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPath() => $_has(2);
  @$pb.TagNumber(3)
  void clearPath() => clearField(3);
}

class PubHDNode extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PubHDNode', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'depth', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fingerprint', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'childNum', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainCode', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey', $pb.PbFieldType.OY)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purpose', $pb.PbFieldType.O3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'curve', $pb.PbFieldType.OU3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'singleKey', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  PubHDNode._() : super();
  factory PubHDNode({
    $core.int? depth,
    $core.int? fingerprint,
    $core.int? childNum,
    $core.List<$core.int>? chainCode,
    $core.List<$core.int>? publicKey,
    $core.int? purpose,
    $core.int? curve,
    $core.int? singleKey,
  }) {
    final _result = create();
    if (depth != null) {
      _result.depth = depth;
    }
    if (fingerprint != null) {
      _result.fingerprint = fingerprint;
    }
    if (childNum != null) {
      _result.childNum = childNum;
    }
    if (chainCode != null) {
      _result.chainCode = chainCode;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (purpose != null) {
      _result.purpose = purpose;
    }
    if (curve != null) {
      _result.curve = curve;
    }
    if (singleKey != null) {
      _result.singleKey = singleKey;
    }
    return _result;
  }
  factory PubHDNode.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PubHDNode.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PubHDNode clone() => PubHDNode()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PubHDNode copyWith(void Function(PubHDNode) updates) => super.copyWith((message) => updates(message as PubHDNode)) as PubHDNode; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PubHDNode create() => PubHDNode._();
  PubHDNode createEmptyInstance() => create();
  static $pb.PbList<PubHDNode> createRepeated() => $pb.PbList<PubHDNode>();
  @$core.pragma('dart2js:noInline')
  static PubHDNode getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PubHDNode>(create);
  static PubHDNode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get depth => $_getIZ(0);
  @$pb.TagNumber(1)
  set depth($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDepth() => $_has(0);
  @$pb.TagNumber(1)
  void clearDepth() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get fingerprint => $_getIZ(1);
  @$pb.TagNumber(2)
  set fingerprint($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearFingerprint() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get childNum => $_getIZ(2);
  @$pb.TagNumber(3)
  set childNum($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChildNum() => $_has(2);
  @$pb.TagNumber(3)
  void clearChildNum() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get chainCode => $_getN(3);
  @$pb.TagNumber(4)
  set chainCode($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChainCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearChainCode() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get publicKey => $_getN(4);
  @$pb.TagNumber(5)
  set publicKey($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPublicKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearPublicKey() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get purpose => $_getIZ(5);
  @$pb.TagNumber(6)
  set purpose($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPurpose() => $_has(5);
  @$pb.TagNumber(6)
  void clearPurpose() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get curve => $_getIZ(6);
  @$pb.TagNumber(7)
  set curve($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurve() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurve() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get singleKey => $_getIZ(7);
  @$pb.TagNumber(8)
  set singleKey($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSingleKey() => $_has(7);
  @$pb.TagNumber(8)
  void clearSingleKey() => clearField(8);
}

class ExchangeRate extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ExchangeRate', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount', $pb.PbFieldType.OU3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currency')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'symbol')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  ExchangeRate._() : super();
  factory ExchangeRate({
    $core.int? amount,
    $core.String? currency,
    $core.String? symbol,
    $fixnum.Int64? value,
  }) {
    final _result = create();
    if (amount != null) {
      _result.amount = amount;
    }
    if (currency != null) {
      _result.currency = currency;
    }
    if (symbol != null) {
      _result.symbol = symbol;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory ExchangeRate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExchangeRate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExchangeRate clone() => ExchangeRate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExchangeRate copyWith(void Function(ExchangeRate) updates) => super.copyWith((message) => updates(message as ExchangeRate)) as ExchangeRate; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ExchangeRate create() => ExchangeRate._();
  ExchangeRate createEmptyInstance() => create();
  static $pb.PbList<ExchangeRate> createRepeated() => $pb.PbList<ExchangeRate>();
  @$core.pragma('dart2js:noInline')
  static ExchangeRate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExchangeRate>(create);
  static ExchangeRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get amount => $_getIZ(0);
  @$pb.TagNumber(1)
  set amount($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAmount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAmount() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get symbol => $_getSZ(2);
  @$pb.TagNumber(3)
  set symbol($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSymbol() => $_has(2);
  @$pb.TagNumber(3)
  void clearSymbol() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get value => $_getI64(3);
  @$pb.TagNumber(4)
  set value($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);
}

class DeviceInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeviceInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'seVersion', $pb.PbFieldType.OU3)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productSn')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productSeries')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productType')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productName')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'productBrand')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountSuffix')
    ..aInt64(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeTime')
    ..aOS(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeCode')
    ..a<$core.int>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeTimeZone', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DeviceInfo._() : super();
  factory DeviceInfo({
    $core.String? id,
    $core.String? name,
    $core.int? version,
    $core.int? seVersion,
    $core.String? productSn,
    $core.String? productSeries,
    $core.String? productType,
    $core.String? productName,
    $core.String? productBrand,
    $core.String? accountSuffix,
    $fixnum.Int64? activeTime,
    $core.String? activeCode,
    $core.int? activeTimeZone,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (version != null) {
      _result.version = version;
    }
    if (seVersion != null) {
      _result.seVersion = seVersion;
    }
    if (productSn != null) {
      _result.productSn = productSn;
    }
    if (productSeries != null) {
      _result.productSeries = productSeries;
    }
    if (productType != null) {
      _result.productType = productType;
    }
    if (productName != null) {
      _result.productName = productName;
    }
    if (productBrand != null) {
      _result.productBrand = productBrand;
    }
    if (accountSuffix != null) {
      _result.accountSuffix = accountSuffix;
    }
    if (activeTime != null) {
      _result.activeTime = activeTime;
    }
    if (activeCode != null) {
      _result.activeCode = activeCode;
    }
    if (activeTimeZone != null) {
      _result.activeTimeZone = activeTimeZone;
    }
    return _result;
  }
  factory DeviceInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) => super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(3)
  set version($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get seVersion => $_getIZ(3);
  @$pb.TagNumber(4)
  set seVersion($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSeVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeVersion() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get productSn => $_getSZ(4);
  @$pb.TagNumber(5)
  set productSn($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasProductSn() => $_has(4);
  @$pb.TagNumber(5)
  void clearProductSn() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get productSeries => $_getSZ(5);
  @$pb.TagNumber(6)
  set productSeries($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProductSeries() => $_has(5);
  @$pb.TagNumber(6)
  void clearProductSeries() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get productType => $_getSZ(6);
  @$pb.TagNumber(7)
  set productType($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasProductType() => $_has(6);
  @$pb.TagNumber(7)
  void clearProductType() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get productName => $_getSZ(7);
  @$pb.TagNumber(8)
  set productName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasProductName() => $_has(7);
  @$pb.TagNumber(8)
  void clearProductName() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get productBrand => $_getSZ(8);
  @$pb.TagNumber(9)
  set productBrand($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasProductBrand() => $_has(8);
  @$pb.TagNumber(9)
  void clearProductBrand() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get accountSuffix => $_getSZ(9);
  @$pb.TagNumber(10)
  set accountSuffix($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAccountSuffix() => $_has(9);
  @$pb.TagNumber(10)
  void clearAccountSuffix() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get activeTime => $_getI64(10);
  @$pb.TagNumber(11)
  set activeTime($fixnum.Int64 v) { $_setInt64(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasActiveTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearActiveTime() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get activeCode => $_getSZ(11);
  @$pb.TagNumber(12)
  set activeCode($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasActiveCode() => $_has(11);
  @$pb.TagNumber(12)
  void clearActiveCode() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get activeTimeZone => $_getIZ(12);
  @$pb.TagNumber(13)
  set activeTimeZone($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasActiveTimeZone() => $_has(12);
  @$pb.TagNumber(13)
  void clearActiveTimeZone() => clearField(13);
}

class CoinPubkey extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CoinPubkey', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<CoinInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: CoinInfo.create)
    ..aOM<PubHDNode>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'node', subBuilder: PubHDNode.create)
    ..pc<PubHDNode>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extNodes', $pb.PbFieldType.PM, subBuilder: PubHDNode.create)
    ..hasRequiredFields = false
  ;

  CoinPubkey._() : super();
  factory CoinPubkey({
    CoinInfo? coin,
    PubHDNode? node,
    $core.Iterable<PubHDNode>? extNodes,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin = coin;
    }
    if (node != null) {
      _result.node = node;
    }
    if (extNodes != null) {
      _result.extNodes.addAll(extNodes);
    }
    return _result;
  }
  factory CoinPubkey.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CoinPubkey.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CoinPubkey clone() => CoinPubkey()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CoinPubkey copyWith(void Function(CoinPubkey) updates) => super.copyWith((message) => updates(message as CoinPubkey)) as CoinPubkey; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CoinPubkey create() => CoinPubkey._();
  CoinPubkey createEmptyInstance() => create();
  static $pb.PbList<CoinPubkey> createRepeated() => $pb.PbList<CoinPubkey>();
  @$core.pragma('dart2js:noInline')
  static CoinPubkey getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CoinPubkey>(create);
  static CoinPubkey? _defaultInstance;

  @$pb.TagNumber(1)
  CoinInfo get coin => $_getN(0);
  @$pb.TagNumber(1)
  set coin(CoinInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);
  @$pb.TagNumber(1)
  CoinInfo ensureCoin() => $_ensure(0);

  @$pb.TagNumber(2)
  PubHDNode get node => $_getN(1);
  @$pb.TagNumber(2)
  set node(PubHDNode v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNode() => $_has(1);
  @$pb.TagNumber(2)
  void clearNode() => clearField(2);
  @$pb.TagNumber(2)
  PubHDNode ensureNode() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<PubHDNode> get extNodes => $_getList(2);
}

class BindAccountReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BindAccountReq', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientUniqueId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientName')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secRandom', $pb.PbFieldType.OY)
    ..pc<CoinInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', $pb.PbFieldType.PM, subBuilder: CoinInfo.create)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  BindAccountReq._() : super();
  factory BindAccountReq({
    $core.String? clientUniqueId,
    $core.String? clientName,
    $core.List<$core.int>? secRandom,
    $core.Iterable<CoinInfo>? coin,
    $core.int? version,
  }) {
    final _result = create();
    if (clientUniqueId != null) {
      _result.clientUniqueId = clientUniqueId;
    }
    if (clientName != null) {
      _result.clientName = clientName;
    }
    if (secRandom != null) {
      _result.secRandom = secRandom;
    }
    if (coin != null) {
      _result.coin.addAll(coin);
    }
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory BindAccountReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BindAccountReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BindAccountReq clone() => BindAccountReq()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BindAccountReq copyWith(void Function(BindAccountReq) updates) => super.copyWith((message) => updates(message as BindAccountReq)) as BindAccountReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BindAccountReq create() => BindAccountReq._();
  BindAccountReq createEmptyInstance() => create();
  static $pb.PbList<BindAccountReq> createRepeated() => $pb.PbList<BindAccountReq>();
  @$core.pragma('dart2js:noInline')
  static BindAccountReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindAccountReq>(create);
  static BindAccountReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientUniqueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientUniqueId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientUniqueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientUniqueId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientName => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientName() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get secRandom => $_getN(2);
  @$pb.TagNumber(3)
  set secRandom($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSecRandom() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecRandom() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<CoinInfo> get coin => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get version => $_getIZ(4);
  @$pb.TagNumber(5)
  set version($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => clearField(5);
}

class BindAccountRespWrapper extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BindAccountRespWrapper', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientUniqueId')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secRandom', $pb.PbFieldType.OY)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encodedInfo', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'encodedDigest', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  BindAccountRespWrapper._() : super();
  factory BindAccountRespWrapper({
    $core.String? clientUniqueId,
    $core.List<$core.int>? secRandom,
    $core.int? version,
    $core.List<$core.int>? encodedInfo,
    $core.List<$core.int>? encodedDigest,
  }) {
    final _result = create();
    if (clientUniqueId != null) {
      _result.clientUniqueId = clientUniqueId;
    }
    if (secRandom != null) {
      _result.secRandom = secRandom;
    }
    if (version != null) {
      _result.version = version;
    }
    if (encodedInfo != null) {
      _result.encodedInfo = encodedInfo;
    }
    if (encodedDigest != null) {
      _result.encodedDigest = encodedDigest;
    }
    return _result;
  }
  factory BindAccountRespWrapper.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BindAccountRespWrapper.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BindAccountRespWrapper clone() => BindAccountRespWrapper()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BindAccountRespWrapper copyWith(void Function(BindAccountRespWrapper) updates) => super.copyWith((message) => updates(message as BindAccountRespWrapper)) as BindAccountRespWrapper; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BindAccountRespWrapper create() => BindAccountRespWrapper._();
  BindAccountRespWrapper createEmptyInstance() => create();
  static $pb.PbList<BindAccountRespWrapper> createRepeated() => $pb.PbList<BindAccountRespWrapper>();
  @$core.pragma('dart2js:noInline')
  static BindAccountRespWrapper getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindAccountRespWrapper>(create);
  static BindAccountRespWrapper? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientUniqueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientUniqueId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientUniqueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientUniqueId() => clearField(1);

  @$pb.TagNumber(3)
  $core.List<$core.int> get secRandom => $_getN(1);
  @$pb.TagNumber(3)
  set secRandom($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasSecRandom() => $_has(1);
  @$pb.TagNumber(3)
  void clearSecRandom() => clearField(3);

  @$pb.TagNumber(6)
  $core.int get version => $_getIZ(2);
  @$pb.TagNumber(6)
  set version($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get encodedInfo => $_getN(3);
  @$pb.TagNumber(7)
  set encodedInfo($core.List<$core.int> v) { $_setBytes(3, v); }
  @$pb.TagNumber(7)
  $core.bool hasEncodedInfo() => $_has(3);
  @$pb.TagNumber(7)
  void clearEncodedInfo() => clearField(7);

  @$pb.TagNumber(8)
  $core.List<$core.int> get encodedDigest => $_getN(4);
  @$pb.TagNumber(8)
  set encodedDigest($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(8)
  $core.bool hasEncodedDigest() => $_has(4);
  @$pb.TagNumber(8)
  void clearEncodedDigest() => clearField(8);
}

class BindAccountResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BindAccountResp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientUniqueId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clientId', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'secRandom', $pb.PbFieldType.OY)
    ..aOM<DeviceInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceInfo', subBuilder: DeviceInfo.create)
    ..pc<CoinPubkey>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.PM, subBuilder: CoinPubkey.create)
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountId', $pb.PbFieldType.OU3)
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountSuffix')
    ..a<$core.int>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'accountType', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  BindAccountResp._() : super();
  factory BindAccountResp({
    $core.String? clientUniqueId,
    $core.int? clientId,
    $core.List<$core.int>? secRandom,
    DeviceInfo? deviceInfo,
    $core.Iterable<CoinPubkey>? pubkey,
    $core.int? version,
    $core.int? accountId,
    $core.String? accountSuffix,
    $core.int? accountType,
  }) {
    final _result = create();
    if (clientUniqueId != null) {
      _result.clientUniqueId = clientUniqueId;
    }
    if (clientId != null) {
      _result.clientId = clientId;
    }
    if (secRandom != null) {
      _result.secRandom = secRandom;
    }
    if (deviceInfo != null) {
      _result.deviceInfo = deviceInfo;
    }
    if (pubkey != null) {
      _result.pubkey.addAll(pubkey);
    }
    if (version != null) {
      _result.version = version;
    }
    if (accountId != null) {
      _result.accountId = accountId;
    }
    if (accountSuffix != null) {
      _result.accountSuffix = accountSuffix;
    }
    if (accountType != null) {
      _result.accountType = accountType;
    }
    return _result;
  }
  factory BindAccountResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BindAccountResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BindAccountResp clone() => BindAccountResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BindAccountResp copyWith(void Function(BindAccountResp) updates) => super.copyWith((message) => updates(message as BindAccountResp)) as BindAccountResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BindAccountResp create() => BindAccountResp._();
  BindAccountResp createEmptyInstance() => create();
  static $pb.PbList<BindAccountResp> createRepeated() => $pb.PbList<BindAccountResp>();
  @$core.pragma('dart2js:noInline')
  static BindAccountResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BindAccountResp>(create);
  static BindAccountResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientUniqueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientUniqueId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasClientUniqueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientUniqueId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get clientId => $_getIZ(1);
  @$pb.TagNumber(2)
  set clientId($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientId() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get secRandom => $_getN(2);
  @$pb.TagNumber(3)
  set secRandom($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSecRandom() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecRandom() => clearField(3);

  @$pb.TagNumber(4)
  DeviceInfo get deviceInfo => $_getN(3);
  @$pb.TagNumber(4)
  set deviceInfo(DeviceInfo v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDeviceInfo() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeviceInfo() => clearField(4);
  @$pb.TagNumber(4)
  DeviceInfo ensureDeviceInfo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.List<CoinPubkey> get pubkey => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get version => $_getIZ(5);
  @$pb.TagNumber(6)
  set version($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(9)
  $core.int get accountId => $_getIZ(6);
  @$pb.TagNumber(9)
  set accountId($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(9)
  $core.bool hasAccountId() => $_has(6);
  @$pb.TagNumber(9)
  void clearAccountId() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get accountSuffix => $_getSZ(7);
  @$pb.TagNumber(10)
  set accountSuffix($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(10)
  $core.bool hasAccountSuffix() => $_has(7);
  @$pb.TagNumber(10)
  void clearAccountSuffix() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get accountType => $_getIZ(8);
  @$pb.TagNumber(11)
  set accountType($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(11)
  $core.bool hasAccountType() => $_has(8);
  @$pb.TagNumber(11)
  void clearAccountType() => clearField(11);
}

class GetPubkeyReq extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetPubkeyReq', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..pc<CoinInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', $pb.PbFieldType.PM, subBuilder: CoinInfo.create)
    ..hasRequiredFields = false
  ;

  GetPubkeyReq._() : super();
  factory GetPubkeyReq({
    $core.Iterable<CoinInfo>? coin,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin.addAll(coin);
    }
    return _result;
  }
  factory GetPubkeyReq.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPubkeyReq.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPubkeyReq clone() => GetPubkeyReq()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPubkeyReq copyWith(void Function(GetPubkeyReq) updates) => super.copyWith((message) => updates(message as GetPubkeyReq)) as GetPubkeyReq; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetPubkeyReq create() => GetPubkeyReq._();
  GetPubkeyReq createEmptyInstance() => create();
  static $pb.PbList<GetPubkeyReq> createRepeated() => $pb.PbList<GetPubkeyReq>();
  @$core.pragma('dart2js:noInline')
  static GetPubkeyReq getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPubkeyReq>(create);
  static GetPubkeyReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CoinInfo> get coin => $_getList(0);
}

class GetPubkeyResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetPubkeyResp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..pc<CoinPubkey>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pubkey', $pb.PbFieldType.PM, subBuilder: CoinPubkey.create)
    ..aOM<DeviceInfo>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceInfo', subBuilder: DeviceInfo.create)
    ..hasRequiredFields = false
  ;

  GetPubkeyResp._() : super();
  factory GetPubkeyResp({
    $core.Iterable<CoinPubkey>? pubkey,
    DeviceInfo? deviceInfo,
  }) {
    final _result = create();
    if (pubkey != null) {
      _result.pubkey.addAll(pubkey);
    }
    if (deviceInfo != null) {
      _result.deviceInfo = deviceInfo;
    }
    return _result;
  }
  factory GetPubkeyResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPubkeyResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPubkeyResp clone() => GetPubkeyResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPubkeyResp copyWith(void Function(GetPubkeyResp) updates) => super.copyWith((message) => updates(message as GetPubkeyResp)) as GetPubkeyResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetPubkeyResp create() => GetPubkeyResp._();
  GetPubkeyResp createEmptyInstance() => create();
  static $pb.PbList<GetPubkeyResp> createRepeated() => $pb.PbList<GetPubkeyResp>();
  @$core.pragma('dart2js:noInline')
  static GetPubkeyResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPubkeyResp>(create);
  static GetPubkeyResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<CoinPubkey> get pubkey => $_getList(0);

  @$pb.TagNumber(2)
  DeviceInfo get deviceInfo => $_getN(1);
  @$pb.TagNumber(2)
  set deviceInfo(DeviceInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceInfo() => clearField(2);
  @$pb.TagNumber(2)
  DeviceInfo ensureDeviceInfo() => $_ensure(1);
}

class BitcoinInput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BitcoinInput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txid', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'script', $pb.PbFieldType.OY)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'index', $pb.PbFieldType.OU3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..a<$fixnum.Int64>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  BitcoinInput._() : super();
  factory BitcoinInput({
    $core.List<$core.int>? txid,
    $core.List<$core.int>? script,
    $core.int? index,
    $core.String? path,
    $fixnum.Int64? value,
    $core.String? address,
  }) {
    final _result = create();
    if (txid != null) {
      _result.txid = txid;
    }
    if (script != null) {
      _result.script = script;
    }
    if (index != null) {
      _result.index = index;
    }
    if (path != null) {
      _result.path = path;
    }
    if (value != null) {
      _result.value = value;
    }
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory BitcoinInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BitcoinInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BitcoinInput clone() => BitcoinInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BitcoinInput copyWith(void Function(BitcoinInput) updates) => super.copyWith((message) => updates(message as BitcoinInput)) as BitcoinInput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BitcoinInput create() => BitcoinInput._();
  BitcoinInput createEmptyInstance() => create();
  static $pb.PbList<BitcoinInput> createRepeated() => $pb.PbList<BitcoinInput>();
  @$core.pragma('dart2js:noInline')
  static BitcoinInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BitcoinInput>(create);
  static BitcoinInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txid => $_getN(0);
  @$pb.TagNumber(1)
  set txid($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxid() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxid() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get script => $_getN(1);
  @$pb.TagNumber(2)
  set script($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScript() => $_has(1);
  @$pb.TagNumber(2)
  void clearScript() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get index => $_getIZ(2);
  @$pb.TagNumber(3)
  set index($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndex() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get path => $_getSZ(3);
  @$pb.TagNumber(4)
  set path($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearPath() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get value => $_getI64(4);
  @$pb.TagNumber(5)
  set value($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get address => $_getSZ(5);
  @$pb.TagNumber(6)
  set address($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAddress() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddress() => clearField(6);
}

class BitcoinOutput extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BitcoinOutput', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'flag', $pb.PbFieldType.OU3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..hasRequiredFields = false
  ;

  BitcoinOutput._() : super();
  factory BitcoinOutput({
    $core.String? address,
    $fixnum.Int64? value,
    $core.int? flag,
    $core.String? path,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    if (value != null) {
      _result.value = value;
    }
    if (flag != null) {
      _result.flag = flag;
    }
    if (path != null) {
      _result.path = path;
    }
    return _result;
  }
  factory BitcoinOutput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BitcoinOutput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BitcoinOutput clone() => BitcoinOutput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BitcoinOutput copyWith(void Function(BitcoinOutput) updates) => super.copyWith((message) => updates(message as BitcoinOutput)) as BitcoinOutput; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BitcoinOutput create() => BitcoinOutput._();
  BitcoinOutput createEmptyInstance() => create();
  static $pb.PbList<BitcoinOutput> createRepeated() => $pb.PbList<BitcoinOutput>();
  @$core.pragma('dart2js:noInline')
  static BitcoinOutput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BitcoinOutput>(create);
  static BitcoinOutput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get value => $_getI64(1);
  @$pb.TagNumber(2)
  set value($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get flag => $_getIZ(2);
  @$pb.TagNumber(3)
  set flag($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFlag() => $_has(2);
  @$pb.TagNumber(3)
  void clearFlag() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get path => $_getSZ(3);
  @$pb.TagNumber(4)
  set path($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearPath() => clearField(4);
}

class BitcoinSignRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BitcoinSignRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<CoinInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: CoinInfo.create)
    ..pc<BitcoinInput>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'inputs', $pb.PbFieldType.PM, subBuilder: BitcoinInput.create)
    ..pc<BitcoinOutput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'outputs', $pb.PbFieldType.PM, subBuilder: BitcoinOutput.create)
    ..aOM<ExchangeRate>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'exchange', subBuilder: ExchangeRate.create)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxReceiveIndex')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lockTime', $pb.PbFieldType.OU3)
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'expiry', $pb.PbFieldType.OU3)
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'branchId', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  BitcoinSignRequest._() : super();
  factory BitcoinSignRequest({
    CoinInfo? coin,
    $core.Iterable<BitcoinInput>? inputs,
    $core.Iterable<BitcoinOutput>? outputs,
    ExchangeRate? exchange,
    $fixnum.Int64? maxReceiveIndex,
    $core.int? lockTime,
    $core.int? expiry,
    $core.int? branchId,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin = coin;
    }
    if (inputs != null) {
      _result.inputs.addAll(inputs);
    }
    if (outputs != null) {
      _result.outputs.addAll(outputs);
    }
    if (exchange != null) {
      _result.exchange = exchange;
    }
    if (maxReceiveIndex != null) {
      _result.maxReceiveIndex = maxReceiveIndex;
    }
    if (lockTime != null) {
      _result.lockTime = lockTime;
    }
    if (expiry != null) {
      _result.expiry = expiry;
    }
    if (branchId != null) {
      _result.branchId = branchId;
    }
    return _result;
  }
  factory BitcoinSignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BitcoinSignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BitcoinSignRequest clone() => BitcoinSignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BitcoinSignRequest copyWith(void Function(BitcoinSignRequest) updates) => super.copyWith((message) => updates(message as BitcoinSignRequest)) as BitcoinSignRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BitcoinSignRequest create() => BitcoinSignRequest._();
  BitcoinSignRequest createEmptyInstance() => create();
  static $pb.PbList<BitcoinSignRequest> createRepeated() => $pb.PbList<BitcoinSignRequest>();
  @$core.pragma('dart2js:noInline')
  static BitcoinSignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BitcoinSignRequest>(create);
  static BitcoinSignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CoinInfo get coin => $_getN(0);
  @$pb.TagNumber(1)
  set coin(CoinInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);
  @$pb.TagNumber(1)
  CoinInfo ensureCoin() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<BitcoinInput> get inputs => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<BitcoinOutput> get outputs => $_getList(2);

  @$pb.TagNumber(4)
  ExchangeRate get exchange => $_getN(3);
  @$pb.TagNumber(4)
  set exchange(ExchangeRate v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasExchange() => $_has(3);
  @$pb.TagNumber(4)
  void clearExchange() => clearField(4);
  @$pb.TagNumber(4)
  ExchangeRate ensureExchange() => $_ensure(3);

  @$pb.TagNumber(5)
  $fixnum.Int64 get maxReceiveIndex => $_getI64(4);
  @$pb.TagNumber(5)
  set maxReceiveIndex($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxReceiveIndex() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxReceiveIndex() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get lockTime => $_getIZ(5);
  @$pb.TagNumber(6)
  set lockTime($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLockTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearLockTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get expiry => $_getIZ(6);
  @$pb.TagNumber(7)
  set expiry($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasExpiry() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpiry() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get branchId => $_getIZ(7);
  @$pb.TagNumber(8)
  set branchId($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasBranchId() => $_has(7);
  @$pb.TagNumber(8)
  void clearBranchId() => clearField(8);
}

class BitcoinSignRespone extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'BitcoinSignRespone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<CoinInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: CoinInfo.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resultCode', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  BitcoinSignRespone._() : super();
  factory BitcoinSignRespone({
    CoinInfo? coin,
    $core.int? resultCode,
    $core.List<$core.int>? txData,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin = coin;
    }
    if (resultCode != null) {
      _result.resultCode = resultCode;
    }
    if (txData != null) {
      _result.txData = txData;
    }
    return _result;
  }
  factory BitcoinSignRespone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BitcoinSignRespone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BitcoinSignRespone clone() => BitcoinSignRespone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BitcoinSignRespone copyWith(void Function(BitcoinSignRespone) updates) => super.copyWith((message) => updates(message as BitcoinSignRespone)) as BitcoinSignRespone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BitcoinSignRespone create() => BitcoinSignRespone._();
  BitcoinSignRespone createEmptyInstance() => create();
  static $pb.PbList<BitcoinSignRespone> createRepeated() => $pb.PbList<BitcoinSignRespone>();
  @$core.pragma('dart2js:noInline')
  static BitcoinSignRespone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BitcoinSignRespone>(create);
  static BitcoinSignRespone? _defaultInstance;

  @$pb.TagNumber(1)
  CoinInfo get coin => $_getN(0);
  @$pb.TagNumber(1)
  set coin(CoinInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);
  @$pb.TagNumber(1)
  CoinInfo ensureCoin() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get resultCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set resultCode($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasResultCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearResultCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get txData => $_getN(2);
  @$pb.TagNumber(3)
  set txData($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTxData() => $_has(2);
  @$pb.TagNumber(3)
  void clearTxData() => clearField(3);
}

class EthTokenInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EthTokenInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'type', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'symbol')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'decimals', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  EthTokenInfo._() : super();
  factory EthTokenInfo({
    $core.int? type,
    $core.String? name,
    $core.String? symbol,
    $core.int? decimals,
  }) {
    final _result = create();
    if (type != null) {
      _result.type = type;
    }
    if (name != null) {
      _result.name = name;
    }
    if (symbol != null) {
      _result.symbol = symbol;
    }
    if (decimals != null) {
      _result.decimals = decimals;
    }
    return _result;
  }
  factory EthTokenInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EthTokenInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EthTokenInfo clone() => EthTokenInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EthTokenInfo copyWith(void Function(EthTokenInfo) updates) => super.copyWith((message) => updates(message as EthTokenInfo)) as EthTokenInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EthTokenInfo create() => EthTokenInfo._();
  EthTokenInfo createEmptyInstance() => create();
  static $pb.PbList<EthTokenInfo> createRepeated() => $pb.PbList<EthTokenInfo>();
  @$core.pragma('dart2js:noInline')
  static EthTokenInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EthTokenInfo>(create);
  static EthTokenInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get type => $_getIZ(0);
  @$pb.TagNumber(1)
  set type($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get symbol => $_getSZ(2);
  @$pb.TagNumber(3)
  set symbol($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSymbol() => $_has(2);
  @$pb.TagNumber(3)
  void clearSymbol() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get decimals => $_getIZ(3);
  @$pb.TagNumber(4)
  set decimals($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDecimals() => $_has(3);
  @$pb.TagNumber(4)
  void clearDecimals() => clearField(4);
}

class EthContractInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EthContractInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OY)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..hasRequiredFields = false
  ;

  EthContractInfo._() : super();
  factory EthContractInfo({
    $core.List<$core.int>? id,
    $core.String? name,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    return _result;
  }
  factory EthContractInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EthContractInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EthContractInfo clone() => EthContractInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EthContractInfo copyWith(void Function(EthContractInfo) updates) => super.copyWith((message) => updates(message as EthContractInfo)) as EthContractInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EthContractInfo create() => EthContractInfo._();
  EthContractInfo createEmptyInstance() => create();
  static $pb.PbList<EthContractInfo> createRepeated() => $pb.PbList<EthContractInfo>();
  @$core.pragma('dart2js:noInline')
  static EthContractInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EthContractInfo>(create);
  static EthContractInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get id => $_getN(0);
  @$pb.TagNumber(1)
  set id($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class EthEIP1559GasFee extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EthEIP1559GasFee', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'estimatedBaseFeePerGas', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxPriorityFeePerGas', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxFeePerGas', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  EthEIP1559GasFee._() : super();
  factory EthEIP1559GasFee({
    $fixnum.Int64? estimatedBaseFeePerGas,
    $fixnum.Int64? maxPriorityFeePerGas,
    $fixnum.Int64? maxFeePerGas,
  }) {
    final _result = create();
    if (estimatedBaseFeePerGas != null) {
      _result.estimatedBaseFeePerGas = estimatedBaseFeePerGas;
    }
    if (maxPriorityFeePerGas != null) {
      _result.maxPriorityFeePerGas = maxPriorityFeePerGas;
    }
    if (maxFeePerGas != null) {
      _result.maxFeePerGas = maxFeePerGas;
    }
    return _result;
  }
  factory EthEIP1559GasFee.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EthEIP1559GasFee.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EthEIP1559GasFee clone() => EthEIP1559GasFee()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EthEIP1559GasFee copyWith(void Function(EthEIP1559GasFee) updates) => super.copyWith((message) => updates(message as EthEIP1559GasFee)) as EthEIP1559GasFee; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EthEIP1559GasFee create() => EthEIP1559GasFee._();
  EthEIP1559GasFee createEmptyInstance() => create();
  static $pb.PbList<EthEIP1559GasFee> createRepeated() => $pb.PbList<EthEIP1559GasFee>();
  @$core.pragma('dart2js:noInline')
  static EthEIP1559GasFee getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EthEIP1559GasFee>(create);
  static EthEIP1559GasFee? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get estimatedBaseFeePerGas => $_getI64(0);
  @$pb.TagNumber(1)
  set estimatedBaseFeePerGas($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEstimatedBaseFeePerGas() => $_has(0);
  @$pb.TagNumber(1)
  void clearEstimatedBaseFeePerGas() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get maxPriorityFeePerGas => $_getI64(1);
  @$pb.TagNumber(2)
  set maxPriorityFeePerGas($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxPriorityFeePerGas() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxPriorityFeePerGas() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get maxFeePerGas => $_getI64(2);
  @$pb.TagNumber(3)
  set maxFeePerGas($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxFeePerGas() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxFeePerGas() => clearField(3);
}

class EthChainInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EthChainInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainName')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nativeName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nativeSymbol')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nativeDecimals', $pb.PbFieldType.OU3)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rpcUrl')
    ..hasRequiredFields = false
  ;

  EthChainInfo._() : super();
  factory EthChainInfo({
    $core.String? chainName,
    $fixnum.Int64? chainId,
    $core.String? nativeName,
    $core.String? nativeSymbol,
    $core.int? nativeDecimals,
    $core.String? rpcUrl,
  }) {
    final _result = create();
    if (chainName != null) {
      _result.chainName = chainName;
    }
    if (chainId != null) {
      _result.chainId = chainId;
    }
    if (nativeName != null) {
      _result.nativeName = nativeName;
    }
    if (nativeSymbol != null) {
      _result.nativeSymbol = nativeSymbol;
    }
    if (nativeDecimals != null) {
      _result.nativeDecimals = nativeDecimals;
    }
    if (rpcUrl != null) {
      _result.rpcUrl = rpcUrl;
    }
    return _result;
  }
  factory EthChainInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EthChainInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EthChainInfo clone() => EthChainInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EthChainInfo copyWith(void Function(EthChainInfo) updates) => super.copyWith((message) => updates(message as EthChainInfo)) as EthChainInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EthChainInfo create() => EthChainInfo._();
  EthChainInfo createEmptyInstance() => create();
  static $pb.PbList<EthChainInfo> createRepeated() => $pb.PbList<EthChainInfo>();
  @$core.pragma('dart2js:noInline')
  static EthChainInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EthChainInfo>(create);
  static EthChainInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chainName => $_getSZ(0);
  @$pb.TagNumber(1)
  set chainName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChainName() => $_has(0);
  @$pb.TagNumber(1)
  void clearChainName() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get chainId => $_getI64(1);
  @$pb.TagNumber(2)
  set chainId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChainId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChainId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get nativeName => $_getSZ(2);
  @$pb.TagNumber(3)
  set nativeName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNativeName() => $_has(2);
  @$pb.TagNumber(3)
  void clearNativeName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get nativeSymbol => $_getSZ(3);
  @$pb.TagNumber(4)
  set nativeSymbol($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNativeSymbol() => $_has(3);
  @$pb.TagNumber(4)
  void clearNativeSymbol() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get nativeDecimals => $_getIZ(4);
  @$pb.TagNumber(5)
  set nativeDecimals($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNativeDecimals() => $_has(4);
  @$pb.TagNumber(5)
  void clearNativeDecimals() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get rpcUrl => $_getSZ(5);
  @$pb.TagNumber(6)
  set rpcUrl($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRpcUrl() => $_has(5);
  @$pb.TagNumber(6)
  void clearRpcUrl() => clearField(6);
}

class EthSignRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EthSignRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<CoinInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: CoinInfo.create)
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nonce', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gasPrice', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'gasLimit', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.List<$core.int>>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'to', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txType', $pb.PbFieldType.OU3)
    ..aOM<ExchangeRate>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'exchange', subBuilder: ExchangeRate.create)
    ..aOM<EthTokenInfo>(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'token', subBuilder: EthTokenInfo.create)
    ..aOM<EthContractInfo>(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'contract', subBuilder: EthContractInfo.create)
    ..a<$core.int>(13, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signType', $pb.PbFieldType.O3)
    ..a<$core.int>(14, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'transactionType', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(15, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'extReqData', $pb.PbFieldType.OY)
    ..aOM<EthChainInfo>(16, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chainInfo', subBuilder: EthChainInfo.create)
    ..hasRequiredFields = false
  ;

  EthSignRequest._() : super();
  factory EthSignRequest({
    CoinInfo? coin,
    $fixnum.Int64? nonce,
    $fixnum.Int64? gasPrice,
    $fixnum.Int64? gasLimit,
    $core.List<$core.int>? to,
    $core.List<$core.int>? value,
    $core.List<$core.int>? data,
    $fixnum.Int64? chainId,
    $core.int? txType,
    ExchangeRate? exchange,
    EthTokenInfo? token,
    EthContractInfo? contract,
    $core.int? signType,
    $core.int? transactionType,
    $core.List<$core.int>? extReqData,
    EthChainInfo? chainInfo,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin = coin;
    }
    if (nonce != null) {
      _result.nonce = nonce;
    }
    if (gasPrice != null) {
      _result.gasPrice = gasPrice;
    }
    if (gasLimit != null) {
      _result.gasLimit = gasLimit;
    }
    if (to != null) {
      _result.to = to;
    }
    if (value != null) {
      _result.value = value;
    }
    if (data != null) {
      _result.data = data;
    }
    if (chainId != null) {
      _result.chainId = chainId;
    }
    if (txType != null) {
      _result.txType = txType;
    }
    if (exchange != null) {
      _result.exchange = exchange;
    }
    if (token != null) {
      _result.token = token;
    }
    if (contract != null) {
      _result.contract = contract;
    }
    if (signType != null) {
      _result.signType = signType;
    }
    if (transactionType != null) {
      _result.transactionType = transactionType;
    }
    if (extReqData != null) {
      _result.extReqData = extReqData;
    }
    if (chainInfo != null) {
      _result.chainInfo = chainInfo;
    }
    return _result;
  }
  factory EthSignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EthSignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EthSignRequest clone() => EthSignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EthSignRequest copyWith(void Function(EthSignRequest) updates) => super.copyWith((message) => updates(message as EthSignRequest)) as EthSignRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EthSignRequest create() => EthSignRequest._();
  EthSignRequest createEmptyInstance() => create();
  static $pb.PbList<EthSignRequest> createRepeated() => $pb.PbList<EthSignRequest>();
  @$core.pragma('dart2js:noInline')
  static EthSignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EthSignRequest>(create);
  static EthSignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CoinInfo get coin => $_getN(0);
  @$pb.TagNumber(1)
  set coin(CoinInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);
  @$pb.TagNumber(1)
  CoinInfo ensureCoin() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get nonce => $_getI64(1);
  @$pb.TagNumber(2)
  set nonce($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNonce() => $_has(1);
  @$pb.TagNumber(2)
  void clearNonce() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get gasPrice => $_getI64(2);
  @$pb.TagNumber(3)
  set gasPrice($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearGasPrice() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get gasLimit => $_getI64(3);
  @$pb.TagNumber(4)
  set gasLimit($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGasLimit() => $_has(3);
  @$pb.TagNumber(4)
  void clearGasLimit() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get to => $_getN(4);
  @$pb.TagNumber(5)
  set to($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get value => $_getN(5);
  @$pb.TagNumber(6)
  set value($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearValue() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get data => $_getN(6);
  @$pb.TagNumber(7)
  set data($core.List<$core.int> v) { $_setBytes(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasData() => $_has(6);
  @$pb.TagNumber(7)
  void clearData() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get chainId => $_getI64(7);
  @$pb.TagNumber(8)
  set chainId($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasChainId() => $_has(7);
  @$pb.TagNumber(8)
  void clearChainId() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get txType => $_getIZ(8);
  @$pb.TagNumber(9)
  set txType($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTxType() => $_has(8);
  @$pb.TagNumber(9)
  void clearTxType() => clearField(9);

  @$pb.TagNumber(10)
  ExchangeRate get exchange => $_getN(9);
  @$pb.TagNumber(10)
  set exchange(ExchangeRate v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasExchange() => $_has(9);
  @$pb.TagNumber(10)
  void clearExchange() => clearField(10);
  @$pb.TagNumber(10)
  ExchangeRate ensureExchange() => $_ensure(9);

  @$pb.TagNumber(11)
  EthTokenInfo get token => $_getN(10);
  @$pb.TagNumber(11)
  set token(EthTokenInfo v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasToken() => $_has(10);
  @$pb.TagNumber(11)
  void clearToken() => clearField(11);
  @$pb.TagNumber(11)
  EthTokenInfo ensureToken() => $_ensure(10);

  @$pb.TagNumber(12)
  EthContractInfo get contract => $_getN(11);
  @$pb.TagNumber(12)
  set contract(EthContractInfo v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasContract() => $_has(11);
  @$pb.TagNumber(12)
  void clearContract() => clearField(12);
  @$pb.TagNumber(12)
  EthContractInfo ensureContract() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.int get signType => $_getIZ(12);
  @$pb.TagNumber(13)
  set signType($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasSignType() => $_has(12);
  @$pb.TagNumber(13)
  void clearSignType() => clearField(13);

  @$pb.TagNumber(14)
  $core.int get transactionType => $_getIZ(13);
  @$pb.TagNumber(14)
  set transactionType($core.int v) { $_setSignedInt32(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasTransactionType() => $_has(13);
  @$pb.TagNumber(14)
  void clearTransactionType() => clearField(14);

  @$pb.TagNumber(15)
  $core.List<$core.int> get extReqData => $_getN(14);
  @$pb.TagNumber(15)
  set extReqData($core.List<$core.int> v) { $_setBytes(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasExtReqData() => $_has(14);
  @$pb.TagNumber(15)
  void clearExtReqData() => clearField(15);

  @$pb.TagNumber(16)
  EthChainInfo get chainInfo => $_getN(15);
  @$pb.TagNumber(16)
  set chainInfo(EthChainInfo v) { setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasChainInfo() => $_has(15);
  @$pb.TagNumber(16)
  void clearChainInfo() => clearField(16);
  @$pb.TagNumber(16)
  EthChainInfo ensureChainInfo() => $_ensure(15);
}

class EthSignRespone extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EthSignRespone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'txData', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signType', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  EthSignRespone._() : super();
  factory EthSignRespone({
    $core.List<$core.int>? txData,
    $core.int? signType,
  }) {
    final _result = create();
    if (txData != null) {
      _result.txData = txData;
    }
    if (signType != null) {
      _result.signType = signType;
    }
    return _result;
  }
  factory EthSignRespone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EthSignRespone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EthSignRespone clone() => EthSignRespone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EthSignRespone copyWith(void Function(EthSignRespone) updates) => super.copyWith((message) => updates(message as EthSignRespone)) as EthSignRespone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EthSignRespone create() => EthSignRespone._();
  EthSignRespone createEmptyInstance() => create();
  static $pb.PbList<EthSignRespone> createRepeated() => $pb.PbList<EthSignRespone>();
  @$core.pragma('dart2js:noInline')
  static EthSignRespone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EthSignRespone>(create);
  static EthSignRespone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get txData => $_getN(0);
  @$pb.TagNumber(1)
  set txData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTxData() => $_has(0);
  @$pb.TagNumber(1)
  void clearTxData() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get signType => $_getIZ(1);
  @$pb.TagNumber(2)
  set signType($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSignType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSignType() => clearField(2);
}

class WithdrawMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WithdrawMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinName')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addrss')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addressTag')
    ..a<$fixnum.Int64>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tagName')
    ..hasRequiredFields = false
  ;

  WithdrawMessage._() : super();
  factory WithdrawMessage({
    $core.String? coinName,
    $core.String? addrss,
    $core.String? addressTag,
    $fixnum.Int64? value,
    $core.String? tagName,
  }) {
    final _result = create();
    if (coinName != null) {
      _result.coinName = coinName;
    }
    if (addrss != null) {
      _result.addrss = addrss;
    }
    if (addressTag != null) {
      _result.addressTag = addressTag;
    }
    if (value != null) {
      _result.value = value;
    }
    if (tagName != null) {
      _result.tagName = tagName;
    }
    return _result;
  }
  factory WithdrawMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WithdrawMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WithdrawMessage clone() => WithdrawMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WithdrawMessage copyWith(void Function(WithdrawMessage) updates) => super.copyWith((message) => updates(message as WithdrawMessage)) as WithdrawMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WithdrawMessage create() => WithdrawMessage._();
  WithdrawMessage createEmptyInstance() => create();
  static $pb.PbList<WithdrawMessage> createRepeated() => $pb.PbList<WithdrawMessage>();
  @$core.pragma('dart2js:noInline')
  static WithdrawMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WithdrawMessage>(create);
  static WithdrawMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get coinName => $_getSZ(0);
  @$pb.TagNumber(1)
  set coinName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoinName() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoinName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get addrss => $_getSZ(1);
  @$pb.TagNumber(2)
  set addrss($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAddrss() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddrss() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get addressTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set addressTag($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAddressTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearAddressTag() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get value => $_getI64(3);
  @$pb.TagNumber(4)
  set value($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get tagName => $_getSZ(4);
  @$pb.TagNumber(5)
  set tagName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTagName() => $_has(4);
  @$pb.TagNumber(5)
  void clearTagName() => clearField(5);
}

class TypedDataMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TypedDataMessage', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'raw')
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hashMsg', $pb.PbFieldType.OY)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'displayMsg')
    ..hasRequiredFields = false
  ;

  TypedDataMessage._() : super();
  factory TypedDataMessage({
    $core.int? version,
    $core.String? raw,
    $core.List<$core.int>? hashMsg,
    $core.String? displayMsg,
  }) {
    final _result = create();
    if (version != null) {
      _result.version = version;
    }
    if (raw != null) {
      _result.raw = raw;
    }
    if (hashMsg != null) {
      _result.hashMsg = hashMsg;
    }
    if (displayMsg != null) {
      _result.displayMsg = displayMsg;
    }
    return _result;
  }
  factory TypedDataMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TypedDataMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TypedDataMessage clone() => TypedDataMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TypedDataMessage copyWith(void Function(TypedDataMessage) updates) => super.copyWith((message) => updates(message as TypedDataMessage)) as TypedDataMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TypedDataMessage create() => TypedDataMessage._();
  TypedDataMessage createEmptyInstance() => create();
  static $pb.PbList<TypedDataMessage> createRepeated() => $pb.PbList<TypedDataMessage>();
  @$core.pragma('dart2js:noInline')
  static TypedDataMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TypedDataMessage>(create);
  static TypedDataMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get version => $_getIZ(0);
  @$pb.TagNumber(1)
  set version($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get raw => $_getSZ(1);
  @$pb.TagNumber(2)
  set raw($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRaw() => $_has(1);
  @$pb.TagNumber(2)
  void clearRaw() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get hashMsg => $_getN(2);
  @$pb.TagNumber(3)
  set hashMsg($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHashMsg() => $_has(2);
  @$pb.TagNumber(3)
  void clearHashMsg() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayMsg => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayMsg($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDisplayMsg() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayMsg() => clearField(4);
}

class CustmsgSignRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CustmsgSignRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..aOM<CoinInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coin', subBuilder: CoinInfo.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgType', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msg')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'myAddress')
    ..a<$core.int>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'version', $pb.PbFieldType.O3)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'appName')
    ..aOM<WithdrawMessage>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'withdraw', subBuilder: WithdrawMessage.create)
    ..a<$core.List<$core.int>>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'binMsg', $pb.PbFieldType.OY)
    ..aOM<TypedDataMessage>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'typedData', subBuilder: TypedDataMessage.create)
    ..hasRequiredFields = false
  ;

  CustmsgSignRequest._() : super();
  factory CustmsgSignRequest({
    CoinInfo? coin,
    $core.String? path,
    $core.int? msgType,
    $core.String? msg,
    $core.String? myAddress,
    $core.int? version,
    $core.String? appName,
    WithdrawMessage? withdraw,
    $core.List<$core.int>? binMsg,
    TypedDataMessage? typedData,
  }) {
    final _result = create();
    if (coin != null) {
      _result.coin = coin;
    }
    if (path != null) {
      _result.path = path;
    }
    if (msgType != null) {
      _result.msgType = msgType;
    }
    if (msg != null) {
      _result.msg = msg;
    }
    if (myAddress != null) {
      _result.myAddress = myAddress;
    }
    if (version != null) {
      _result.version = version;
    }
    if (appName != null) {
      _result.appName = appName;
    }
    if (withdraw != null) {
      _result.withdraw = withdraw;
    }
    if (binMsg != null) {
      _result.binMsg = binMsg;
    }
    if (typedData != null) {
      _result.typedData = typedData;
    }
    return _result;
  }
  factory CustmsgSignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CustmsgSignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CustmsgSignRequest clone() => CustmsgSignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CustmsgSignRequest copyWith(void Function(CustmsgSignRequest) updates) => super.copyWith((message) => updates(message as CustmsgSignRequest)) as CustmsgSignRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CustmsgSignRequest create() => CustmsgSignRequest._();
  CustmsgSignRequest createEmptyInstance() => create();
  static $pb.PbList<CustmsgSignRequest> createRepeated() => $pb.PbList<CustmsgSignRequest>();
  @$core.pragma('dart2js:noInline')
  static CustmsgSignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CustmsgSignRequest>(create);
  static CustmsgSignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CoinInfo get coin => $_getN(0);
  @$pb.TagNumber(1)
  set coin(CoinInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoin() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoin() => clearField(1);
  @$pb.TagNumber(1)
  CoinInfo ensureCoin() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get path => $_getSZ(1);
  @$pb.TagNumber(2)
  set path($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearPath() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get msgType => $_getIZ(2);
  @$pb.TagNumber(3)
  set msgType($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMsgType() => $_has(2);
  @$pb.TagNumber(3)
  void clearMsgType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get msg => $_getSZ(3);
  @$pb.TagNumber(4)
  set msg($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMsg() => $_has(3);
  @$pb.TagNumber(4)
  void clearMsg() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get myAddress => $_getSZ(4);
  @$pb.TagNumber(5)
  set myAddress($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMyAddress() => $_has(4);
  @$pb.TagNumber(5)
  void clearMyAddress() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get version => $_getIZ(5);
  @$pb.TagNumber(6)
  set version($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get appName => $_getSZ(6);
  @$pb.TagNumber(7)
  set appName($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAppName() => $_has(6);
  @$pb.TagNumber(7)
  void clearAppName() => clearField(7);

  @$pb.TagNumber(8)
  WithdrawMessage get withdraw => $_getN(7);
  @$pb.TagNumber(8)
  set withdraw(WithdrawMessage v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasWithdraw() => $_has(7);
  @$pb.TagNumber(8)
  void clearWithdraw() => clearField(8);
  @$pb.TagNumber(8)
  WithdrawMessage ensureWithdraw() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.List<$core.int> get binMsg => $_getN(8);
  @$pb.TagNumber(9)
  set binMsg($core.List<$core.int> v) { $_setBytes(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasBinMsg() => $_has(8);
  @$pb.TagNumber(9)
  void clearBinMsg() => clearField(9);

  @$pb.TagNumber(10)
  TypedDataMessage get typedData => $_getN(9);
  @$pb.TagNumber(10)
  set typedData(TypedDataMessage v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasTypedData() => $_has(9);
  @$pb.TagNumber(10)
  void clearTypedData() => clearField(10);
  @$pb.TagNumber(10)
  TypedDataMessage ensureTypedData() => $_ensure(9);
}

class CustmsgSignRespone extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CustmsgSignRespone', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Wallet'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'coinType', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msgType', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signData', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  CustmsgSignRespone._() : super();
  factory CustmsgSignRespone({
    $core.int? coinType,
    $core.int? msgType,
    $core.List<$core.int>? signData,
  }) {
    final _result = create();
    if (coinType != null) {
      _result.coinType = coinType;
    }
    if (msgType != null) {
      _result.msgType = msgType;
    }
    if (signData != null) {
      _result.signData = signData;
    }
    return _result;
  }
  factory CustmsgSignRespone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CustmsgSignRespone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CustmsgSignRespone clone() => CustmsgSignRespone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CustmsgSignRespone copyWith(void Function(CustmsgSignRespone) updates) => super.copyWith((message) => updates(message as CustmsgSignRespone)) as CustmsgSignRespone; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CustmsgSignRespone create() => CustmsgSignRespone._();
  CustmsgSignRespone createEmptyInstance() => create();
  static $pb.PbList<CustmsgSignRespone> createRepeated() => $pb.PbList<CustmsgSignRespone>();
  @$core.pragma('dart2js:noInline')
  static CustmsgSignRespone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CustmsgSignRespone>(create);
  static CustmsgSignRespone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get coinType => $_getIZ(0);
  @$pb.TagNumber(1)
  set coinType($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCoinType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoinType() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get msgType => $_getIZ(1);
  @$pb.TagNumber(2)
  set msgType($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsgType() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsgType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get signData => $_getN(2);
  @$pb.TagNumber(3)
  set signData($core.List<$core.int> v) { $_setBytes(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSignData() => $_has(2);
  @$pb.TagNumber(3)
  void clearSignData() => clearField(3);
}

