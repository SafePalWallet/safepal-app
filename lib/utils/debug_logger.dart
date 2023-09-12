import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DebugLogger {
  static const String _TAG_DEF = '[Example]';
  static DateFormat dateformat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  static String TAG = _TAG_DEF;

  static void v(String object, {String? tag}) {
    String timeStr = dateformat.format(DateTime.now());
    _printLog('$timeStr', '  v  ', object);
  }

  static void e(Object object, {String? tag}) {
    _printLog((tag == null || tag.isEmpty) ? TAG : tag, '  e  ', object);
  }


  static void msg(String object, {String? tag}) {
    String timeStr = dateformat.format(DateTime.now());
    _printLog('$timeStr', '  msg  ', object);
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = getString(tag, stag, object);
    debugPrint(sb.toString());
  }

  static StringBuffer getString(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write(tag.isEmpty ? TAG : tag);
    sb.write(stag);
    sb.write(object);
    return sb;
  }

}