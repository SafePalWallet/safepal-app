import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:safepal_example/utils/base_plugin.dart';
import 'package:safepal_example/model/models.dart';
import 'package:safepal_example/utils/string_utils.dart';
import 'package:safepal_example/utils/utils_plugin.dart';

import '../manager/wallet_manager.dart';
import '../protobuf/Wallet.pbenum.dart';
import '../widgets/alert_dialog.dart';

typedef QRScanRespResultHandler = Function(dynamic data);
typedef QRScanRespExtHeaderHandler = Function(dynamic data);

class QRPlugin extends BasePlugin {
  static const MethodChannel _channel = const MethodChannel('flutter.safepal.io/qr');

  static Future<T?> invokeMethod<T>(String method, dynamic argments) async {
    return await BasePlugin.invokeMethod<T>(channel: _channel, method: method, argments: argments);
  }

  static Future<List<Uint8List>>getQRImageData({
    required int clientId,
    required int? msgType,
    required bool aesFlag,
    required bool base64Encode,
    required Uint8List data,
    required Uint8List? secKey,
    required Uint8List? exHeader,
  }) async {
    Map<String, dynamic> paras = Map();

    paras['client_id'] = (clientId == null) ? 0 : clientId;
    paras['msg_type'] = (msgType == null) ? MessageType.MSG_UNKOWN.value : msgType;
    paras['aes_flag'] = aesFlag;
    paras['qr_type'] = base64Encode;

    if (exHeader != null) {
      paras['exHeader'] = exHeader;
    }
    paras['data'] = data;
    if (secKey != null) {
      paras['sec_key'] = secKey;
    }
    Wallet? wallet = WalletManager.instance.curSelWallet;

    int? version = 0;
    if (wallet != null) {
      version = wallet.version;
    }
    paras['version'] = version;

    List<dynamic>? result = await invokeMethod<List<dynamic>>('split_qr_data', paras);
    return List.from(result!);
  }

  static Future<dynamic> launchQRCodeScan(
      BuildContext context,
      {
        bool showProgress = true,
        bool showNavbar = true,
        bool showGuideTips = true,
        int? clienId,
        String? title,
        String? tips,
        Uint8List? secKey,
        QRScanRespResultHandler? resultHandler,
        QRScanRespExtHeaderHandler? extHeaderHandler
      }) async {

    Map args = {};
    args['show_progress'] = showProgress;
    args['show_nav_bar'] = showNavbar;
    args['show_guide_tips'] = showGuideTips;
    if (clienId != null) {
      args['client_id'] = clienId;
    }
    if (secKey != null) {
      args['sec_key'] = secKey;
    }
    if (title != null) {
      args['title'] = title;
    }
    if (tips != null) {
      args['tips'] = tips;
    }
    args['scan_photo_error'] = "No QRcode is detected.";
    args['no_photo_permission'] = "The access to Album is disabled. Please approve the access first. ";
    args['ok'] = "OK";

    if (Platform.isIOS) {
      args["iosCameraPermissionsTips"] = "Allow Safepal to access your camera and microphone on Settings-privacy on your iPhone";
    }

    Map<dynamic, dynamic>? qrResp = await invokeMethod<Map<dynamic, dynamic>>('show_qr_scan', args);
    if (qrResp == null) {
      return null;
    }
    if (qrResp["cancel"] == 1) {
      return null;
    }

    if (qrResp['message_type'] != null) {
      int? type = qrResp['message_type'] as int?;
      int? errorCode = qrResp['errorCode'] as int?;
      if (errorCode != null && errorCode != 0) {
        Alert.show(context: context, content: "System Error(code=$errorCode)", options: ["OK"], onPress: (idx){});
        return null;
      }
      dynamic data = qrResp['data'];
      dynamic extHeader = qrResp['ext_header'];
      MessageType? messageType = MessageType.valueOf(type!);
      String? string;
      if (data != null && (data is String) && messageType == MessageType.MSG_UNKOWN) {
        string = data;
      } else if (data != null && (data is Uint8List || data is List<int>) && messageType == MessageType.MSG_UNKOWN) {
        List<int> listData = data.toList();
        // String ret = String.fromCharCodes(listData);
        string =  utf8.decode(listData);
      }
      if (string != null) {
        bool isSafePalHost = StringUtils.isSafePalHost(string);
        if (isSafePalHost) {
          UtilsPlugin.openSystemBrowser(string);
          return null;
        } else {
          data = string;
        }
      }
      if (resultHandler != null) {
        resultHandler(data);
      }
      if (extHeaderHandler != null && extHeader != null) {
        extHeaderHandler(extHeader);
      }
      return data;
    }
  }

}