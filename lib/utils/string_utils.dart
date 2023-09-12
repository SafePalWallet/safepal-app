import 'dart:math';
import 'dart:typed_data';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import 'debug_logger.dart';

class StringUtils {

  static String trim0(String string) {
    String result;
    if (string.contains('\u0000')) {
      result = string.replaceAll('\u0000', '');
    } else {
      result = string;
    }
    return result;
  }

 static bool isSafePalHost(String url) {
    if (url == null || url.isEmpty) {
      return false;
    }
    url = url.toLowerCase();
    if (!url.startsWith("http")) {
      return false;
    }
    final Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
    }
    if (uri.host.toLowerCase() == "safepal.io" || uri.host.toLowerCase() == "safepal.com") {
      return true;
    }
    return false;
 }

}