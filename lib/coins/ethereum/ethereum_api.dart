
import 'dart:math';

import '../../manager/network_manager.dart';

class EthereumApi {
  String _url = "https://rpc.ankr.com/eth";

  EthereumApi({
    String? url
  }) {
    if (url != null) {
      _url = url;
    }
  }

  Future<String> _post(String method, dynamic params) async {
    NetworkManager manager = NetworkManager.newManager(_url, null);
    int randomVal = Random.secure().nextInt(10000000);
    Map<String, dynamic> body = {};
    body['id'] = randomVal;
    body['jsonrpc'] = '2.0';
    body['method'] = method;
    body['params'] = params;
    ApiResp obj = await manager.post(path: "", data: body, headerClient: false, accountInfo: false, options: jsonOptions);
    return processRPCResp(obj);
  }

  static String processRPCResp(ApiResp resp) {
    if (resp.error != null) {
      throw resp.error!;
    }
    dynamic data = resp.data;
    if (data is! Map) {
      SFResonseError respError = SFResonseError(type: ApiErrorType.RESPONSE, errCode: -800, message: "invalid resp");
      throw respError;
    }
    dynamic error = data['error'];
    if (error != null) {
      SFResonseError respError = SFResonseError(type: ApiErrorType.RESPONSE, errCode: error['code'], message: error['message']);
      throw respError;
    }
    dynamic result = data['result'];
    return result;
  }

  Future<int> eth_chainId() async {
    final String result = await _post("eth_chainId", []) as String;
    final int nonce = int.parse(result.substring(2), radix: 16);
    return nonce;
  }

  Future<int> net_version() async {
    final String result = await _post("net_version", []);
    return int.parse(result, radix: 16);
  }

  Future<String> eth_balance(String? address, {String tag = "latest"}) async {
    final String bal = await _post("eth_getBalance", [address, tag]);
    return BigInt.tryParse(bal.substring(2), radix: 16)!.toString();
  }

  Future<String> eth_call(String? to, String data, {String tag = "latest", String? from}) async {
    Map<String, dynamic> params = {
      "to" : to,
      "data" : data
    };
    if (from != null) {
      params['from'] = from;
    }

    final String result = await _post("eth_call", [params, tag]);
    return result;
  }

  Future<int> eth_getTransactionCount(String? address, {String tag = "latest"}) async {
    final String result = await _post("eth_getTransactionCount", [address, tag]) as String;
    return int.parse(result.substring(2), radix: 16);
  }

  Future<int> eth_estimateGas(Map<String, dynamic>? args) async {
    final String result = await _post('eth_estimateGas', [args]) as String;
    return int.parse(result.substring(2), radix: 16);
  }

  Future<int> eth_gasPrice() async {
    final String result = await _post("eth_gasPrice", []) as String;
    final gasPrice = int.parse(result.substring(2), radix: 16);
    return gasPrice;
  }

  Future<String> eth_sendRawTransaction(String data) async {
    if (!data.startsWith('0x')) {
      data = '0x' + data;
    }
    return await _post("eth_sendRawTransaction", [data]);
  }

  // Future<Str> eth_getTransactionByHash(String hash) async {
  //   ApiResp resp = await _post("eth_getTransactionByHash", [hash]);
  //   return resp;
  // }

}