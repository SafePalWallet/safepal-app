import 'package:meta/meta.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class BasePlugin {

  static Future<T?> invokeMethod<T>(
      {required MethodChannel channel,
      required String method,
      required dynamic argments}) async {
    try {
      T? result = await channel.invokeMethod<T>(method, argments);
      return result;
    } on PlatformException catch (e) {
      throw e;
    } on MissingPluginException catch (e) {
      throw e;
    }
  }

}
