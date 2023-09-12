
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:safepal_example/model/models.dart';
import 'package:safepal_example/pages/root_page.dart';
import 'package:safepal_example/utils/utils_plugin.dart';

import '../manager/wallet_manager.dart';
import '../protobuf/Wallet.pb.dart';
import '../transport/transport_util.dart';
import '../utils/coin_utils.dart';
import '../utils/app_util.dart';
import '../utils/crypto_plugin.dart';
import '../utils/debug_logger.dart';
import '../utils/hud_progress_plugin.dart';
import '../utils/qr_plugin.dart';
import '../utils/string_utils.dart';
import '../utils/style.dart';
import '../widgets/qr_image_widget.dart';
import '../utils/toast_util.dart';

class PairDevicePage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _PairDevicePageState();
  }

}


class _PairDevicePageState extends State<PairDevicePage> {

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  Uint8List? _qrdata;
  bool _isLoaded = false;

  @override
  void initState() {
    _initData();
    _tapGestureRecognizer.onTap = (){
      UtilsPlugin.openSystemBrowser("https://m.safepal.com/shop");
    };
    super.initState();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    await _loadQrdata();
    setState(() {
      _isLoaded = false;
    });
  }

  Future<void> _loadQrdata() async {
    final bool hasSec = await appUtil.hasClientKey();
    if (!hasSec) {
      final List<dynamic> result = await CryptoPlugin.generateEcdsaKeypair();
      final String pubKey = result[0] as String;
      final String privKey = result[1] as String;
      await appUtil.updateClientKey(pubkey: pubKey, privkey: privKey);
    }
    final String uid = await appUtil.clientUId();
    final String model = await appUtil.phoneModel();
    final String? pubkey = await appUtil.getClientPubKey();
    if(pubkey == null || pubkey.isEmpty) {
      return;
    }
    final BindAccountReq req = BindAccountReq();
    req.clientUniqueId = uid;
    req.clientName = model;
    req.secRandom = hex.decode(pubkey);
    req.version = 1;

    final CoinInfo bitcoinInfo = CoinInfo(type: CoinCategory.bitcoin.index, uname: "BTC");
    req.coin.add(bitcoinInfo);
    final CoinInfo ethInfo = CoinInfo(type: CoinCategory.eth.index, uname: "ETH");
    req.coin.add(ethInfo);
    final Uint8List data = req.writeToBuffer();

    final List<Uint8List> items = await QRPlugin.getQRImageData(
        clientId: 0,
        msgType: MessageType.MSG_BIND_ACCOUNT_REQUEST.value,
        aesFlag: false,
        base64Encode: false,
        data: data,
        exHeader: null,
        secKey: null
    );

    if (items.isEmpty) {
      print("get qr data failed!");
      return;
    }
    if (items.length != 1) {
      print("get qr data invalid!");
      return;
    }
    _qrdata = items.first;
  }

  Future<Wallet?> createHardwareWallet(BindAccountResp resp) async {
    final DeviceInfo deviceInfo = resp.deviceInfo;
    final List<CoinPubkey> pubkeys = resp.pubkey;
    if (pubkeys.isEmpty) {
      return null;
    }
    int time = DateTime.now().millisecondsSinceEpoch;
    time = time ~/ 1000;
    DebugLogger.v('deviceInfo.activeTimeZone:${deviceInfo.activeTimeZone}');

    String accountSuffix = "";
    if (deviceInfo.accountSuffix.isNotEmpty) {
      accountSuffix = deviceInfo.accountSuffix;
    } else if (resp.accountSuffix.isNotEmpty) {
      accountSuffix = resp.accountSuffix;
    }
    accountSuffix = StringUtils.trim0(accountSuffix);

    final List<Coin> newCoinList = [];
    for (CoinPubkey item in resp.pubkey) {
      final CoinBaseInfo coinInfo = CoinBaseInfo(type: item.coin.type, uname: StringUtils.trim0(item.coin.uname));
      // @todo current not support other coin
      if (coinInfo.coinCatetory != CoinCategory.bitcoin && coinInfo.coinCatetory != CoinCategory.eth) {
        continue;
      }
      var createHDNodeHandler = (PubHDNode inputNode){
        return HDNode(
            depth: inputNode.depth,
            childNum: inputNode.childNum,
            fingerPrint: inputNode.fingerprint,
            chainCode: inputNode.chainCode,
            pubKey: inputNode.publicKey,
            purpose: inputNode.purpose,
            curve: inputNode.curve,
            singleKey: inputNode.singleKey
        );
      };

      List<HDNode>? extNodes;
      if (item.extNodes.isNotEmpty) {
        extNodes = [];
        for (PubHDNode nodeItem in item.extNodes) {
          extNodes.add(createHDNodeHandler(nodeItem));
        }
      }
      final Coin coin = Coin(coinInfo: coinInfo, node: createHDNodeHandler(item.node), extNodes: extNodes);
      await coin.generateAccount();
      newCoinList.add(coin);
    }

    final Wallet newWallet = Wallet(
      id: deviceInfo.id.trim(),
      name: StringUtils.trim0(deviceInfo.name),
      version: deviceInfo.version,
      productSn: StringUtils.trim0(deviceInfo.productSn),

      seVersion: deviceInfo.seVersion,
      productBrand: StringUtils.trim0(deviceInfo.productBrand),
      productName: StringUtils.trim0(deviceInfo.productName),
      productType: StringUtils.trim0(deviceInfo.productType),
      productSeries: StringUtils.trim0(deviceInfo.productSeries),

      accountSuffix: accountSuffix,
      activeCode: StringUtils.trim0(deviceInfo.activeCode),
      activeTime: deviceInfo.activeTime.toInt(),
      activeTimeZone: deviceInfo.activeTimeZone,

      secRandom: resp.secRandom,
      clientId: resp.clientId,
      accountId: resp.accountId,
      accountType: resp.accountType,
      coins: newCoinList,

      addedTime: time,
    );
    DebugLogger.v('accountSufix:${newWallet.accountSuffix} activeCode:${newWallet.activeCode} activeTime:${newWallet.activeTime} activeTimeZone:${newWallet.activeTimeZone} accountId:${newWallet.accountId} id:${newWallet.id} accounType:${newWallet.accountType}');

    return newWallet;
  }

  Future<void> _createWallet(BindAccountResp resp, BuildContext context) async {
    NavigatorState navigatorState = Navigator.of(context);
    await HUDProgressPlugin.show(autoHide: false);
    final Wallet? wallet = await createHardwareWallet(resp);
    await HUDProgressPlugin.dismiss();
    if (wallet == null) {
      ToastUtil.show("Bind wallet failed");
      return;
    }
    final WalletManager manager = WalletManager.instance;
    manager.updateWallet(wallet: wallet);
    navigatorState.popUntil(ModalRoute.withName('/'));
  }

  Future<void> _qrScan() async {
    final dynamic rawdata = await QRPlugin.launchQRCodeScan(
        context,
        showProgress: true,
        showNavbar: true,
        showGuideTips: true,
        clienId: 0,
        title: "SCAN",
        tips: "Please scan the dynamic codes on SafePal wallet.",
        resultHandler: (dynamic data) {
          DebugLogger.v('qr scan resultHandler finish');
        }
    );
    if (rawdata == null) {
      return;
    }
    dynamic result;
    if (rawdata is Uint8List) {
      result = rawdata.toList();
    } else {
      result = rawdata;
    }
    final Object? model = await TransportUtil.tryParseProtobufData(
        context: context,
        respType: MessageType.MSG_BIND_ACCOUNT_RESP,
        data: result
    );
    if (model == null || model is! BindAccountResp) {
      return;
    }
    _createWallet(model, context);
  }

  @override
  Widget build(BuildContext context) {
    late Widget qrWidget;

    if (_qrdata != null) {
      qrWidget = QRImageWidget(
        size: 250,
        qrData: _qrdata!.toList(),
      );
    } else {
      qrWidget = Container(
        width: 250,
        height: 250,
        alignment: Alignment.center,
        child: _isLoaded ? Text("Generate QR Code failed", style: AppTextStyle.headLarge.apply(color: Colors.red),) :
        CircularProgressIndicator(color: Colors.green,),
      );
    }

    return RootPage(
      title: "Pair Device",
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: ListView(
            padding: EdgeInsets.only(left: 15, right: 15),
            children: [
              SizedBox(height: 15,),
              Text(
                "1. Open the hardware wallet device, click 'Scan' in the menu and scan the QR code below:",
                style: AppTextStyle.bodyMedium,
                textAlign: TextAlign.start,
                maxLines: null,
              ),
              SizedBox(height: 15,),
              qrWidget,
              SizedBox(height: 15,),
              Text(
                "2. After doing so, you will see a set of dynamic QR codes on the device. Then click 'Next' below. ",
                style: AppTextStyle.bodyMedium,
                textAlign: TextAlign.start,
                maxLines: null,
              ),
              SizedBox(height: 15,),
              Text.rich(TextSpan(
                  text:"Not work? Check the",
                  style: AppTextStyle.bodySmall,
                  children: [TextSpan(
                    text: " Pairing Guide",
                    recognizer: _tapGestureRecognizer,
                    style: AppTextStyle.bodySmall.apply(color: Colors.green),
                  )])
              )
            ],
          )),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 25),
            child: SizedBox(
              height: 44,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Container(
                  child: Text("Next", style: AppTextStyle.headMedium,),
                ),
                onPressed: (){
                  _qrScan();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

}