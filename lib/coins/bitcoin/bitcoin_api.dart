
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:safepal_example/utils/api_util.dart';

import '../../manager/network_manager.dart';


class BitcoinApi {
  final String _host = "https://openapi.safepal.com/";

  Future<ApiResp> fetchBalance(String xpub) async {
    final Map<String, dynamic> paras = {
      "details" : "tokenBalances"
    };
    final NetworkManager manger = NetworkManager.newManager(_host, null);
    ApiResp resp = await manger.get(path:"wallet/v1/btc2/xpub/$xpub", queryParas: paras);
    return commonHandleResp(resp);
  }

  Future<ApiResp> fetchUtxo(String xpub) async {
    final NetworkManager manger = NetworkManager.newManager(_host, null);
    ApiResp resp = await manger.get(path: "wallet/v1/btc2/utxo/$xpub");
    return commonHandleResp(resp);
  }

  Future<ApiResp> fetchFee() async {
    final NetworkManager manger = NetworkManager.newManager(_host, null);
    ApiResp resp = await manger.get(path: "wallet/v1/btc/fee");
    return commonHandleResp(resp);
  }

  Future<ApiResp> sendtx(String rawdata) async {
    final NetworkManager manger = NetworkManager.newManager(_host, null);
    ApiResp resp = await manger.get(path: "wallet/v1/btc2/sendtx");
    return commonHandleResp(resp);
  }

}