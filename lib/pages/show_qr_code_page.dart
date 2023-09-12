import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:convert/convert.dart';
import 'package:safepal_example/protobuf/Wallet.pb.dart';
import 'package:safepal_example/model/models.dart';

import 'root_page.dart';
import '../utils/debug_logger.dart';
import '../utils/qr_plugin.dart';
import '../utils/style.dart';
import '../widgets/qr_image_widget.dart';


enum QRCodeType { bin, base64 }

typedef void NextStepCallBack();

class ShowQrCodeListPage extends StatefulWidget {
  final String title;
  final String? tips;
  final String? strongReminderTips;

  final int clientId;
  final int? msgType;
  final Uint8List data;
  final Uint8List? secKey;
  final QRCodeType qrType;
  final Wallet? wallet;

  final NextStepCallBack? nextCallBack;
  final VoidCallback? moreDetailsCallback;

  ShowQrCodeListPage(
      {Key? key,
        required this.title,
        this.tips,
        this.strongReminderTips,
        required this.clientId,
        required this.msgType,
        required this.data,
        required this.wallet,
        this.qrType = QRCodeType.bin,
        this.secKey,
        this.nextCallBack,
        this.moreDetailsCallback,
      })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ShowQrCodeListPageState();
  }
}

class _ShowQrCodeListPageState extends State<ShowQrCodeListPage> {
  List<Uint8List>? images;
  double qrWidth = 250;

  int index = 0;
  Timer? timer;

  bool _isGetImages = true;

  void _timerAction() {
    setState(() {
      this.index = (this.index + 1) % this.images!.length;
    });
  }

  @override
  void initState() {
    super.initState();
    _getQRImages(widget.wallet);
  }

  @override
  void dispose() {
    super.dispose();
    if (this.timer != null) {
      this.timer!.cancel();
    }
  }

  Future<void> _getQRImages(Wallet? wallet) async {
    PacketHeaderWrapper? wrapper;
    if ( wallet != null) {
      PacketHeader header = PacketHeader();
      if (widget.msgType != MessageType.MSG_BIND_ACCOUNT_REQUEST.value) {
        header.accountId = wallet.accountId;
      }
      wrapper = PacketHeaderWrapper();
      wrapper.header = header;
    }

    List<Uint8List> items = await QRPlugin.getQRImageData(
        clientId: widget.clientId,
        msgType: widget.msgType,
        aesFlag: widget.secKey != null,
        base64Encode: widget.qrType == QRCodeType.base64,
        data: widget.data,
        secKey: widget.secKey,
        exHeader: wrapper?.writeToBuffer()
    );

    if (items.isEmpty) {
      DebugLogger.v('generate qr image failed: ${items}');
      return;
    }
    int count = items.length;
    DebugLogger.v('qr image data count:$count');

    _isGetImages = false;

    setState(() {
      this.images = items;
    });
    // update state
    if (this.images != null && this.images!.length > 1) {
      this.timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        _timerAction();
      });
    }
  }

  Widget _createButtons(BuildContext context) {
    Widget moreDetail = (widget.moreDetailsCallback == null)
        ? Container()
        : ElevatedButton(
        child: Text("Details"),
        onPressed: () {
          widget.moreDetailsCallback!();
        });

    Widget nextStepWidget = SizedBox(
      width: 200,
      height: 44,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Colors.green),
          child: Text("Next", style: AppTextStyle.headMedium),
          onPressed: () {
            if (widget.nextCallBack != null) {
              widget.nextCallBack!();
            }
          }
      ),
    );
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          moreDetail,
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: nextStepWidget,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Text progressText;
    int progress;
    int total;
    Widget topWidget = Container();

    if (this.images != null) {
      progress = this.index + 1;
      total = this.images!.length;
      progressText = Text.rich(
        TextSpan(children: [
          TextSpan(
              text: '$progress',
              style: TextStyle(
                  color: AppColor.blue, fontSize: 16)),
          TextSpan(
              text: ' / $total',
              style: TextStyle(
                  color: AppColor.textDarkColor1, fontSize: 16))
        ]),
        textAlign: TextAlign.center,
        textScaleFactor: 1,
      );
      List<int> qrData = this.images![index];
      DebugLogger.v("qrcode rawbytes:${hex.encode(qrData)} index:$index");
      topWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.up,
        children: <Widget>[
          (this.images!.length <= 1) ? Container() : Padding(
            padding: EdgeInsets.only(top: 3),
            child: progressText,
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: QRImageWidget(qrData: qrData), //二维码图片
              )
          )
        ],
      );
    // } else {
    } else if(_isGetImages == false) {
      topWidget = Text(
        "generate qr code failed",
        style: TextStyle(color: Colors.red),
      );
    }

    return RootPage(
      title: widget.title,
      onTapBack: () {
      },
      child: WillPopScope(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //上面部分
              Expanded(flex: 1, child: Center(child: topWidget)),
              //
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                EdgeInsets.only(top: 5, left: 20, right: 20),
                                child: Text(
                                  widget.tips ?? "Please scan the code with your SafePal wallet.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColor.textDarkColor2,
                                      fontSize: 14),
                                ),
                              ),
                              Padding(
                                padding:
                                EdgeInsets.only(top: 5, left: 20, right: 20),
                                child: Text(
                                  widget.strongReminderTips ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        ),
                        _createButtons(context)
                      ]))
            ],
          ), onWillPop: () async {
        return true;
      }),
    );
  }
}
