import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:safepal_example/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletManager {
  static const String _walletKey = 'cached.wallet.key';

  static WalletManager get instance => _getInstance();
  static WalletManager? _instance;

  final Set<VoidCallback> _didChangeWalletCallbacks = Set();

  Wallet? curSelWallet;

  static WalletManager _getInstance() {
    if (_instance == null) {
      _instance = WalletManager();
    }
    return _instance!;
  }

  Future<void> initWalletManager() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String? message = pref.getString(_walletKey);
    if (message == null || message.isEmpty) {
      return;
    }
    final dynamic object = json.decode(message);
    if (object is! Map) {
      return;
    }
    this.curSelWallet = Wallet.fromJson(object as Map<String, dynamic>);
  }

  bool haveHwWallet() {
    return this.curSelWallet != null;
  }

  bool isBinded() {
    return this.curSelWallet != null;
  }

  Future<void> deleteWallet(Wallet wallet) async {
    this.curSelWallet = null;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove(_walletKey);
    _handleCallbacks();
  }

  Future<bool> updateWallet({required Wallet wallet}) async {
    this.curSelWallet = wallet;
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(_walletKey, json.encode(wallet.toJson()));
    _handleCallbacks();
    return true;
  }

  void _handleCallbacks() {
    for (VoidCallback item in _didChangeWalletCallbacks) {
      item();
    }
  }

  void addDidChangeWalletCallback({required VoidCallback callback}) {
    _didChangeWalletCallbacks.add(callback);
  }

  void removeDidChangeWalletCallback({required VoidCallback callback}) {
    _didChangeWalletCallbacks.remove(callback);
  }
}