import 'package:flutter/services.dart';
import 'dart:typed_data';

import 'package:safepal_example/utils/base_plugin.dart';


class UtilsPlugin extends BasePlugin {
  static const MethodChannel channel = const MethodChannel('flutter.safepal.io/util');
  
  static Future<T?> invokeMethod<T>(String method, dynamic argments) async {
    return await BasePlugin.invokeMethod<T>(channel: channel, method: method, argments: argments);
  }

  static Future<bool?> copy(String? text) async {
    return await invokeMethod("copy", text);
  }

  static Future<dynamic> paste() async {
    return await invokeMethod('paste', null);
  }

  static Future<bool?> openSystemBrowser(String? url) async {
    return await invokeMethod('openBrower', url);
  }
}