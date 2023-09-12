import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:safepal_example/coins/coin.dart';
import 'package:safepal_example/model/models.dart';

import '../transport/transport_util.dart';
import '../utils/coin_utils.dart';
import '../utils/app_util.dart';
import '../utils/crypto_plugin.dart';

import 'package:json_annotation/json_annotation.dart';
part 'wallet.g.dart';

@JsonSerializable()
class Wallet {
  final String id; // device id
  final String name; // device name
  int version; // device version
  final int seVersion; // device sn
  final String productSn;

  final String productSeries;
  final String productType;
  final String productName;
  final String productBrand;
  final String accountSuffix;

  final int activeTime;
  final String activeCode;
  final int activeTimeZone;

  final List<int> secRandom;
  final int clientId;
  final int accountId;
  final int accountType;

  final int addedTime;
  final List<Coin> coins;

  Wallet({
    required this.id,
    required this.name,
    required this.version,
    required this.seVersion,
    required this.productSn,

    required this.productSeries,
    required this.productType,
    required this.productName,
    required this.productBrand,
    required this.accountSuffix,

    required this.activeTime,
    required this.activeCode,
    required this.activeTimeZone,

    required this.secRandom,
    required this.clientId,
    required this.accountId,
    required this.accountType,

    required this.addedTime,

    @JsonKey(fromJson: _coinsFromJson, toJson: _coinsToJson)
    required this.coins,

  });

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
  Map<String, dynamic> toJson() => _$WalletToJson(this);

  WalletTransportType get channelType {
    return WalletTransportType.qrcode;
  }

  bool isHardwareWallet() {
    WalletTransportType type = this.channelType;
    return type == WalletTransportType.qrcode;
  }

  Future<Uint8List?> getAesKey() async {
    String? privateKey = await appUtil.getClientPrivateKey();
    if (privateKey == null || privateKey.isEmpty) {
      return null;
    }
    final Uint8List? secKey = await CryptoPlugin.generateCryptoKey(pubKey:this.secRandom, privateKey: hex.decode(privateKey));
    return secKey;
  }

  static dynamic _coinsToJson(List<Coin> coins) {
    return coins.map((e) => e.toJson());
  }
  
  static List<Coin> _coinsFromJson(dynamic data) {
    if (data is! List) {
      return [];
    }
    final List<Coin> coins = [];
    for (dynamic item in List.from(data)) {
      coins.add(Coin.fromJson(Map<String, dynamic>.from(item)));
    }
    return coins;
  }

}