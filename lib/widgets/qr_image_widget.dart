import 'package:flutter/material.dart';
import 'package:safepal_example/widgets/qr_image/qr_image.dart';

import '../widgets/qr/error_correct_level.dart';
import '../utils/style.dart';

export 'package:safepal_example/widgets/qr/error_correct_level.dart';

class QRImageWidget extends StatelessWidget {
  final List<int> qrData;
  final int version;
  final double? size;
  Color? backgroundColor;
  Color? foregroundColor;
  final EdgeInsets padding;
  final int errorLevel;


  QRImageWidget({
    Key? key,
    required this.qrData,
    this.size,
    this.version = 10,
    this.backgroundColor,
    this.foregroundColor,
    this.padding = const EdgeInsets.all(10.0),
    this.errorLevel = QrErrorCorrectLevel.L,
  }) : super(key:key){
    this.backgroundColor = this.backgroundColor?? Colors.white;
    this.foregroundColor = this.foregroundColor?? Colors.black;
  }

  static int getQrVersion(List<int> qrData) {
    if (qrData == null || qrData.isEmpty) {
      return 4;
    }
    int len = qrData.length;
    if (len <= 70) {
      return 4;
    } else if (len > 70 && len <= 105) {
      return 5;
    } else if (len > 105 && len <= 200) {
      return 9;
    } else {
      return 12;
    }
  }

  static double updateAddressHeight(String? address) {
    if (address == null || address.isEmpty) {
      return 25;
    }
    int len = address.length;
    if (len <= 90) {
      return 30;
    } else if (len <= 200) {
      return 50;
    } else {
      return 75;
    }
  }


  @override
  Widget build(BuildContext context) {
    QrImage qrImage = QrImage(
      data: this.qrData,
      size: this.size,
      backgroundColor: this.backgroundColor,
      foregroundColor: this.foregroundColor,
      version: this.version,
      padding: this.padding,
      errorCorrectionLevel: this.errorLevel,
    );
    return Center(
      child: qrImage,
    );
  }
}