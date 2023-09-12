import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:safepal_example/model/wallet.dart';
export 'package:safepal_example/utils/api_util.dart';

final Options urlEncodeFormOptions = Options(contentType: ContentType.parse("application/x-www-form-urlencoded").toString());
final Options jsonOptions =  Options(contentType: ContentType.parse("application/json").toString());
final Options multipartFormData =  Options(contentType: ContentType.parse("multipart/form-data").toString());

enum ApiErrorType {
  /// It occurs when url is opened timeout.
  CONNECT_TIMEOUT,

  /// It occurs when url is sent timeout.
  SEND_TIMEOUT,

  ///It occurs when receiving timeout.
  RECEIVE_TIMEOUT,

  /// When the server response, but with a incorrect status, such as 404, 503...
  RESPONSE,

  /// When the request is cancelled, dio will throw a error with this type.
  CANCEL,

  /// Default error type, Some other Error. In this case, you can
  /// read the DioError.error if it is not null.
  DEFAULT,
}

abstract class SFError extends Error {
  final ApiErrorType? type;

  static List<ApiErrorType> _timeouts = [ApiErrorType.CONNECT_TIMEOUT, ApiErrorType.RECEIVE_TIMEOUT, ApiErrorType.SEND_TIMEOUT];

  SFError({
    this.type = ApiErrorType.DEFAULT,
  });

  bool get isNetworkError {
    if (_timeouts.contains(this.type)) {
      return true;
    }
    return this.type == ApiErrorType.DEFAULT;
  }

  String errorDes(BuildContext context) {
    if (_timeouts.contains(this.type)) {
      return "Time out";
    }
    return "Network disconnected";
  }
}

class SFNetworkError extends SFError {
  final String? message;

  SFNetworkError({
    ApiErrorType? type,
    this.message
  }) : super(type: type);

  @override
  String toString() {
    if (this.isNetworkError) {
      return "Connection timed out";
    }
    return this.message!;
  }

}

class SFResonseError extends SFError {
  final int? statusCode;

  int? errCode;
  final String? message;

  final dynamic resp;

  final int? subcode;

  SFResonseError({
    ApiErrorType? type,
    this.statusCode,
    this.resp,
    this.errCode,
    this.message,
    this.subcode
  }) : super(type: type);

  @override
  String toString() {
    if (this.message != null && this.message!.isNotEmpty) {
      String errCodeDes = '';
      if (this.errCode != null) {
        if (this.errCode! >= 6600 && this.errCode! <= 6699) {
          errCodeDes = "";
        } else {
          errCodeDes = '(code=${this.errCode})';
        }
      }
      return '${this.message}${errCodeDes}';
    }
    if (this.resp != null) {
      return this.resp.toString();
    }
    String stError = '';
    if (this.statusCode != null) {
      stError = '(code=${this.statusCode})';
    }
    if (this.subcode != null) {
      stError = '(subcode=${this.subcode})';
    }

    return 'Request error ${stError}';
  }

  String errorDes(BuildContext context) {
    if (this.isNetworkError) {
      return super.errorDes(context);
    }
    return this.toString();
  }
}

class ApiResp {
  dynamic data;
  String? message;
  SFError? error;
  dynamic srcResp; // Response

  ApiResp({
    this.data,
    this.message,
    this.srcResp,
    this.error
  });

  @override
  String toString() {
    if (srcResp == null) {
      return 'resp is null';
    } else {
      return srcResp.toString();
    }
  }
}

enum _HTTPMethod{
  get,
  post,
  put,
  delete,
  head
}

class NetworkManager {
  static const int logSize = 1024 * 10;
  static const bool _enableProxy = true;

  late Dio dio;
  Wallet? _wallet;

  static NetworkManager newManager(String url, Wallet? wallet,{int? connectTimeout}) {
    var manager = NetworkManager();
    manager._wallet = wallet;
    manager.dio = Dio();
    manager.dio.options.baseUrl = url;
    if(connectTimeout!=null){
      manager.dio.options.connectTimeout = connectTimeout;
    }
    manager.dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    return manager;
  }

  Future<ApiResp> get({
    String? path,
    Map<String, dynamic>?queryParas,
    Options? options,
    CancelToken? cancelToken,
    bool headerClient = true,
    bool accountInfo = true,
    String? client,
    String? headerSandbox
  }) async {
    return await _req(_HTTPMethod.get, path: path, queryParas: queryParas, options: options, cancelToken: cancelToken, headerClient: headerClient, client: client, accountInfo: accountInfo, headerSandbox: headerSandbox);
  }

  Future<ApiResp> post({
    String? path,
    Map<String, dynamic>?queryParas,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool headerClient = true,
    bool accountInfo = true,
    String? client,
    String? headerSandbox
  }) async {
    return await _req(_HTTPMethod.post, path: path, queryParas: queryParas, data: data, options: options, client: client, cancelToken: cancelToken, headerClient: headerClient, accountInfo: accountInfo, headerSandbox: headerSandbox);
  }

  Future<ApiResp> put({
    String? path,
    Map<String, dynamic>?queryParas,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool headerClient = true,
    bool accountInfo = true,
    String? headerSandbox,
    String? client,
  }) async {
    return await _req(_HTTPMethod.put, path: path, queryParas: queryParas, data: data, options: options, client: client, cancelToken: cancelToken, headerClient: headerClient, accountInfo: accountInfo, headerSandbox: headerSandbox);
  }

  Future<ApiResp> delete({
    String? path,
    Map<String, dynamic>?queryParas,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool headerClient = true,
    bool accountInfo = true,
    String? headerSandbox,
    String? client
  }) async {
    return await _req(_HTTPMethod.delete, path: path, queryParas: queryParas, data: data, options: options, client: client, cancelToken: cancelToken, headerClient: headerClient, accountInfo: accountInfo, headerSandbox: headerSandbox);
  }

  Future<ApiResp> head({
    String? path,
    Map<String, dynamic>?queryParas,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool headerClient = true,
    bool accountInfo = true,
    String? headerSandbox,
    String? client,
  }) async {
    return await _req(_HTTPMethod.head, path: path, queryParas: queryParas, data: data, options: options, client: client, cancelToken: cancelToken, headerClient: headerClient, accountInfo: accountInfo, headerSandbox: headerSandbox);
  }


  Future<ApiResp> _req(_HTTPMethod method, {
    String? path,
    Map<String, dynamic>?queryParas,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool headerClient = true,
    bool accountInfo = true,
    String? client,
    String? headerSandbox
  }) async {
    String baseUrl = this.dio.options.baseUrl;
    bool isEnd = baseUrl.endsWith('/');
    bool isStart = false;
    String _subPath = "";
    if (path != null && path.startsWith('/'))  {
      isStart = true;
    }
    if (isEnd && isStart) {
      _subPath = path!.substring(1,);
    } else if (!isEnd && !isStart) {
      if (path != null && path.isNotEmpty) {
        _subPath = "/" + path;
      }
    } else {
      _subPath = path!;
    }
    try {
      dio.options.headers[HttpHeaders.userAgentHeader] =
      dio.options.headers[HttpHeaders.connectionHeader] = 'keep-alive';
      late Response response;
      switch (method) {
        case _HTTPMethod.put:
          response = await dio.put(_subPath, queryParameters: queryParas,
              options: options,
              data: data,
              cancelToken: cancelToken);
          break;
        case _HTTPMethod.delete:
          response = await dio.delete(_subPath, queryParameters: queryParas,
              options: options,
              data: data,
              cancelToken: cancelToken);
          break;
        case _HTTPMethod.get:
          response = await dio.get(_subPath, queryParameters: queryParas,
              options: options,
              cancelToken: cancelToken);
          break;
        case _HTTPMethod.post:
          response = await dio.post(_subPath, queryParameters: queryParas,
              options: options,
              data: data,
              cancelToken: cancelToken);
          break;
        case _HTTPMethod.head:
          response = await dio.head(_subPath, queryParameters: queryParas,
              options: options,
              data: data,
              cancelToken: cancelToken);
          break;
        default:
          break;
      }
      ApiResp resp = _resp(_subPath, response);
      return resp;
    } on DioError catch(e) {
      ApiResp resp = ApiResp(error: _assureError(e), srcResp: e.response);
      return resp;
    } on FormatException catch(e) {
      SFNetworkError networkError = SFNetworkError(type: ApiErrorType.RESPONSE, message: e.toString());
      return ApiResp(error: networkError, srcResp: e.message);
    } on Exception catch(e) {
      SFNetworkError networkError = SFNetworkError(type: ApiErrorType.RESPONSE, message: e.toString());
      return ApiResp(error: networkError, srcResp: e.toString());
    }

  }

  ApiResp _resp(String? path,Response response) {
    dynamic respData = response.data;
    if (respData != null && respData is String) {
      String stringJson = respData;
      if (stringJson.isNotEmpty) {
        dynamic decodeData = json.decode(respData);
        respData = decodeData;
      } else {
        respData = null;
      }
    }
    response.data = respData;

    return ApiResp(
        data: respData,
        srcResp: response
    );
  }

  SFError _assureError(DioError e) {
    if(e.response != null || e.type == DioErrorType.response) {
      return SFResonseError(
          type: ApiErrorType.RESPONSE,
          statusCode: e.response!.statusCode,
          resp: e.response!.data
      );
    } else {
      ApiErrorType errorType = ApiErrorType.DEFAULT;
      switch (e.type) {
        case DioErrorType.connectTimeout:
          errorType = ApiErrorType.CONNECT_TIMEOUT;
          break;
        case DioErrorType.receiveTimeout:
          errorType = ApiErrorType.RECEIVE_TIMEOUT;
          break;
        case DioErrorType.sendTimeout:
          errorType = ApiErrorType.SEND_TIMEOUT;
          break;
        case DioErrorType.cancel:
          errorType = ApiErrorType.CANCEL;
          break;
        default:
          errorType = ApiErrorType.DEFAULT;
          break;
      }
      return SFNetworkError(
          type: errorType,
          message: e.message
      );
    }
  }

}