import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:safepal_example/transport/qr_channel_transport.dart';

import '../model/wallet.dart';
import '../protobuf/Wallet.pb.dart';
import '../protobuf/Wallet.pbenum.dart';
import '../utils/app_util.dart';
import '../utils/crypto_plugin.dart';
import '../utils/debug_logger.dart';
import '../widgets/alert_dialog.dart';

typedef ChannelRespCheckHandler = void Function(Object? object, ValueChanged checkedCallback);

enum WalletTransportType {
  none,
  qrcode,
}

class WalletReqExtInfo {
  String? scanPageTitle;
  String? scanPageTips;
  String? qrcodePageTitle;
  String qrcodePageTips;
  String? signSucceeTips;
  String? strongReminderTips;
  final VoidCallback? showReqDetailCallback;
  final ValueChanged? getRespSuccessHandler;
  final VoidCallback? showRespDetailCallback;

  WalletReqExtInfo({
    this.scanPageTitle,
    this.scanPageTips,
    required this.qrcodePageTitle,
    required this.qrcodePageTips,
    this.strongReminderTips,
    this.signSucceeTips,
    this.showReqDetailCallback,
    this.getRespSuccessHandler,
    this.showRespDetailCallback
  }) {
    if (this.qrcodePageTitle == null) {
      this.qrcodePageTitle  = this.scanPageTitle ?? ' ';
    }
    if (this.scanPageTitle == null) {
      this.scanPageTitle = this.qrcodePageTitle ?? ' ';
    }
  }
}

typedef WalletAPIRespCheckHandler = Future<int> Function(Object object);

class TransportUtil {
  static const int errorCodeProtobufParseFailed = -5000;

  static Future<Object?> tryParseProtobufData({
    required BuildContext context,
    required MessageType respType,
    required List<int>? data
  }) async {
    try {
      return await createProtobufObject(context, data, respType.value);
    } on InvalidProtocolBufferException catch (e) {
      DebugLogger.v(e.toString());
    }
    return null;
  }

  @override
  static Future<Object?> commandRequest(
      WalletTransportType channelType, {
        required BuildContext context,
        required Wallet? wallet,
        required List<int>? data,
        required MessageType reqType,
        required MessageType respType,
        required ValueChanged respDataConfirmFinishHandler,
        required WalletReqExtInfo info,
        ChannelRespCheckHandler? checkRespHandler,
      }) async {
    final QRChannelTransport api = QRChannelTransport();
    var popHandler = () async {
      if (channelType == WalletTransportType.qrcode) {
        Navigator.of(context).pop();
      }
    };
    DebugLogger.v('commandRequest reqtype:${reqType.value} $reqType resptype:${respType.value} $respType wallet:${wallet?.name} wallet.client_id:${wallet?.clientId}');
    dynamic resp;
    try {
      resp = await api.commandRequest(
          context: context,
          wallet: wallet,
          data: data,
          cmdType: reqType.value,
          info: info
      );
    } on CryptoPluginRequestException catch(e) {
      DebugLogger.v(e.toString());
      await popHandler();
      return null;
    }
    final Object? respObject = await tryParseProtobufData(context:context, data:resp, respType: respType);
    if (respObject == null) {
      await popHandler();
      return null;
    }
    if (checkRespHandler == null) {
      await popHandler();
      respDataConfirmFinishHandler(respObject);
      return respObject;
    }

    checkRespHandler(respObject, (code) async {
      Alert.show(
          context: context,
          content: info.signSucceeTips ?? "Signing is completed. Confirm to broadcast onto the chain?",
          options: ["Cancel", "Confirm"],
          onPress: (idx){
            popHandler();
            if (idx == 0) {
              return;
            }
            if (info.showRespDetailCallback != null) {
              info.showRespDetailCallback!();
            }
            respDataConfirmFinishHandler(respObject);
          }
      );
    });
    return respObject;
  }

  static Future<Object?> createProtobufObject(BuildContext context, List<int>? data, int type) async {
    if (data == null || data.isEmpty) {
      return null;
    }
    final MessageType? messageType = MessageType.valueOf(type);
    if (messageType == null) {
      return null;
    }
    Object? model;
    switch (messageType) {
      case MessageType.MSG_UNKOWN:
        model = String.fromCharCodes(data);
        break;
      case MessageType.MSG_BIND_ACCOUNT_RESP:
        model = await _parseBindAccountResp(context, data);
        break;
      case MessageType.MSG_ETH_SIGN_RESP:
        model = EthSignRespone.fromBuffer(data);
        break;
      case MessageType.MSG_GET_PUBKEY_RESP:
        model = GetPubkeyResp.fromBuffer(data);
        break;
      case MessageType.MSG_BITCOIN_SIGN_RESP:
        model = BitcoinSignRespone.fromBuffer(data);
        break;
      case MessageType.MSG_CUSTOM_MSG_SIGN_RESP:
        model = CustmsgSignRespone.fromBuffer(data);
        break;
    }
    return model;
  }

  static Future<Object?> _parseBindAccountResp(BuildContext context, List<int> data) async {
    BindAccountResp? bindAccountResp;
    int errorCode = 0;
    BindAccountRespWrapper? wrapper;
    try {
      wrapper = BindAccountRespWrapper.fromBuffer(data);
    } on Exception catch (e) {
      errorCode = -499;
      wrapper = null;
    }
    if (wrapper != null && wrapper.version != 0) {
      List<int> encodedInfo = wrapper.encodedInfo;
      String? prvKeyStr = await appUtil.getClientPrivateKey();
      if(prvKeyStr==null){
        return -498;
      }
      List<int> prvKey = hex.decode(prvKeyStr);
      Uint8List? secKey = await CryptoPlugin.generateCryptoKey(
          pubKey: wrapper.secRandom, privateKey: prvKey);
      List<int>? decodedInfo =
      await CryptoPlugin.aes256CFBDecrypt(encodedInfo, secKey);
      if(decodedInfo==null){
        return -497;
      }
      List<int>? hashDigestInfo = await CryptoPlugin.sha256(Uint8List.fromList(decodedInfo));
      DeepCollectionEquality equality = DeepCollectionEquality();
      if (wrapper.encodedDigest.length != 8) {
        // no encrypt digest
        errorCode = -500;
      } else if (!equality.equals(hashDigestInfo!.sublist(0, 8), wrapper.encodedDigest)) {
        // verify failed
        errorCode = -501;
      } else {
        try {
          bindAccountResp = BindAccountResp.fromBuffer(decodedInfo);
        } on Exception catch (e) {
          // protobuf decode failed
          errorCode = -502;
          bindAccountResp = null;
        }
        if (bindAccountResp != null) {
          bindAccountResp.clientUniqueId = wrapper.clientUniqueId;
          bindAccountResp.secRandom = wrapper.secRandom;
          bindAccountResp.version = wrapper.version;
        }
      }
    } else {
      try {
        bindAccountResp = BindAccountResp.fromBuffer(data);
      } on Exception catch (e) {
        errorCode = -503;
      }
    }
    DebugLogger.v("_parseBindAccountResp error code:$errorCode");
    return bindAccountResp;
  }

}