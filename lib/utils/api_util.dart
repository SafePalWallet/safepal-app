
import 'package:safepal_example/manager/network_manager.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class ReqCanelToken extends CancelToken {}

ApiResp commonHandleResp(ApiResp resp) {
  dynamic data = resp.data;
  if (data == null) {
    return resp;
  }
  Map<String, dynamic> jsons = data;
  SFError? error;
  String? messgeTxt;
  final int? code = jsons['code'];
  final int? subcode = jsons['subcode'];
  if (code != null && code != 0) {
    dynamic msg = jsons['msg'];
    if (msg is Map) {
      messgeTxt = json.encode(msg);
    } else {
      messgeTxt = msg;
    }
    error = SFResonseError(
        type: ApiErrorType.RESPONSE,
        errCode: code,
        message: messgeTxt,
        subcode:subcode
    );
  }
  data = data['data'];
  ApiResp newResp = ApiResp(
    data: data,
    error:error,
    srcResp: resp.srcResp,
    message: messgeTxt
  );
  return newResp;
}