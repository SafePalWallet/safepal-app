import 'dart:async';
import 'package:flutter/services.dart';


class HUDProgressPlugin {
  static MethodChannel _channel = MethodChannel('flutter.safepal.io/HUDProgress');
  static bool _tempDismiss = false;

  static Future<bool?> show({String? message, bool autoHide = true}) async {
    _tempDismiss = false;
    Map<String, dynamic> paras = {};
    if (message != null) {
      paras['message'] = message;
    }
    paras['auto_hide'] = autoHide;
    return await _channel.invokeMethod('show', paras);
  }

  static Future<bool?> dismiss() async {
    _tempDismiss = false;
    return await _channel.invokeMethod('dismiss');
  }

  static Future<bool?> tempDismiss() async {
    _tempDismiss = true;
    return await _channel.invokeMethod('dismiss');
  }

  static bool isTempDismiss() {
    return _tempDismiss;
  }

  static Future<bool?> isShow() async {
    return await _channel.invokeMethod('isShow');
  }


}