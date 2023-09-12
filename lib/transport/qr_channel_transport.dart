import 'package:flutter/material.dart';
import 'package:safepal_example/manager/managers.dart';
import 'dart:async';
import 'dart:typed_data';
import '../protobuf/Wallet.pb.dart';
import '../utils/crypto_plugin.dart';
import '../utils/qr_plugin.dart';
import '../widgets/alert_dialog.dart';
import 'transport_util.dart';
import 'package:safepal_example/model/models.dart';
import 'package:safepal_example/pages/show_qr_code_page.dart';

class QRChannelTransport {

  static int maxQrSize = 20 * 1024;

  @override
  Future<dynamic> commandRequest({
    required BuildContext context,
    Wallet? wallet,
    List<int>? data,
    int? cmdType,
    WalletReqExtInfo? info,
    ChannelRespCheckHandler? respCheckHandler
  }) async {
    final Completer completer = Completer();
    if (data != null && data.length > maxQrSize) {
      Alert.show(context: context, content: "Data size too big. QRcode loading failed.", options: ["OK"], onPress: (idx){});
      return null;
    }
    final int clientId = wallet?.clientId ?? 0;
    final Uint8List? secKey = await wallet?.getAesKey() ?? null;

    final ShowQrCodeListPage showQrCodeList = ShowQrCodeListPage(
      clientId: clientId,
      title: info!.qrcodePageTitle ?? ' ',
      tips: info.qrcodePageTips,
      strongReminderTips: info.strongReminderTips ?? '',
      msgType: cmdType,
      secKey: secKey,
      wallet: wallet,
      data: Uint8List.fromList(data!),
      nextCallBack: () async {
        final dynamic object = await QRPlugin.launchQRCodeScan(
            context,
            showProgress: true,
            showNavbar: true,
            showGuideTips: true,
            clienId: wallet?.clientId ?? 0,
            secKey: secKey,
            title: "SCAN",
            tips: "Please scan the dynamic codes on SafePal wallet.",
            resultHandler: (dynamic data) {
              if (info.getRespSuccessHandler != null) {
                info.getRespSuccessHandler!(data);
              }
            },
            extHeaderHandler: (dynamic data) async {
              if (data == null || data is! Uint8List) {
                return;
              }
              try {
                PacketRespHeaderWrapper wrapper = PacketRespHeaderWrapper.fromBuffer(data.toList());
                if (wallet != null) {
                  final int version = wrapper.header.version;
                  wallet.version = version;
                  WalletManager.instance.updateWallet(wallet: wallet);
                }
              } catch (e) {
                print("parser PacketRespHeaderWrapper failed, ${e.toString()}");
              }
            }
        );
        if (object == null) {
          return;
        }
        dynamic result;
        if (object is Uint8List) {
          result = object.toList();
        } else {
          result = object;
        }
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      },
      moreDetailsCallback: info.showReqDetailCallback,
    );
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return showQrCodeList;
    }));

    return completer.future;
  }
}
