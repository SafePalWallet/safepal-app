
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safepal_example/utils/style.dart';

import '../utils/utils_plugin.dart';
import '../widgets/qr_image_widget.dart';
import '../utils/toast_util.dart';

class ReceiveAddressWidget extends StatelessWidget {

  final String title;
  final String address;
  final String tokenIcon;
  final VoidCallback onClose;

  ReceiveAddressWidget({
    required this.title,
    required this.address,
    required this.tokenIcon,
    required this.onClose
  });

  @override
  Widget build(BuildContext context) {

    final Widget body = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      width: 280,
      height: 366,
      decoration: BoxDecoration(color: AppColor.mainBackground2, borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(this.title, style: AppTextStyle.headMedium,),
              ),
              Expanded(child: Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(onPressed: this.onClose, icon: Icon(Icons.close), iconSize: 20, color: Colors.white,),
                ),
              )),
            ],
          ),
          SizedBox(height: 10,),

          Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                QRImageWidget(
                  qrData: utf8.encode(this.address),
                  size: 230,
                  version: 8,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(13))),
                  width: 26,
                  height: 26,
                  child: Image.asset(tokenIcon, width: 20, height: 20,),
                )
              ],
            ),
          ),

          SizedBox(height: 10,),

          GestureDetector(
            child: Container(
              child: Text(this.address, style: AppTextStyle.bodyMedium, textAlign: TextAlign.center,),
            ),
            onTap: (){
              UtilsPlugin.copy(this.address);
              ToastUtil.show("Copy");
            },
          )
        ],
      ),
    );
    return body;
  }

}