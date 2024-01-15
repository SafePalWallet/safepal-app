import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

enum ToastGravity { TOP, BOTTOM, CENTER }

class Fluttertoast {
  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  static Future<bool?> cancel() async {
    bool? res = await _channel.invokeMethod("cancel");
    return res;
  }

  static Future<bool?> showToast({
    required String? msg,
    Toast? toastLength,
    int timeInSecForIos = 1,
    double fontSize = 16.0,
    ToastGravity? gravity,
    Color? backgroundColor,
    Color? textColor,
    // Function(bool) didTap,
  }) async {
    await cancel();

    String toast = "short";
    if (toastLength == Toast.LENGTH_LONG) {
      toast = "long";
    }

    String gravityToast = "bottom";
    if (gravity == ToastGravity.TOP) {
      gravityToast = "top";
    } else if (gravity == ToastGravity.CENTER) {
      gravityToast = "center";
    } else {
      gravityToast = "bottom";
    }

    if (backgroundColor == null &&
        defaultTargetPlatform == TargetPlatform.iOS) {
      backgroundColor = Colors.black;
    }
    if (textColor == null && defaultTargetPlatform == TargetPlatform.iOS) {
      textColor = Colors.white;
    }
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': timeInSecForIos,
      'gravity': gravityToast,
      'bgcolor': backgroundColor != null ? backgroundColor.value : null,
      'textcolor': textColor != null ? textColor.value : null,
      'fontSize': fontSize,
    };

    bool? res = await _channel.invokeMethod('showToast', params);
    return res;
  }
}
