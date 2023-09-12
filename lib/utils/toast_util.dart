import 'package:flutter/material.dart';
import 'package:safepal_example/widgets/fluttertoast.dart';

import 'style.dart';

class ToastUtil {

  static Future<void> show(String? text, {bool showLong = false, bool autoHide = true}) async {
    await dimiss();
    Fluttertoast.showToast(
        msg: text,
        fontSize: 15,
        textColor: Colors.black,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        toastLength: showLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        timeInSecForIos: 0
    );
  }

  static Future dimiss() async {
    await Fluttertoast.cancel();
  }
}