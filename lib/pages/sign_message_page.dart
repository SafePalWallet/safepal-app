import 'package:flutter/material.dart';
import 'package:convert/convert.dart';
import 'package:safepal_example/pages/root_page.dart';
import 'package:safepal_example/utils/coin_utils.dart';
import 'package:safepal_example/utils/style.dart';
import 'package:safepal_example/utils/utils_plugin.dart';
import 'package:safepal_example/widgets/alert_dialog.dart';

import '../coins/coin.dart';
import '../model/wallet.dart';
import '../protobuf/Wallet.pb.dart';
import '../transport/transport_util.dart';

class SignMessagePage extends StatefulWidget {

  final Wallet wallet;
  final Coin coin;

  SignMessagePage({
    required this.wallet,
    required this.coin,
  });

  @override
  State<StatefulWidget> createState() {
    return _SignMessagePageState();
  }
}

class _SignMessagePageState extends State<SignMessagePage> {

  final TextEditingController _controller = TextEditingController();

  late bool _isEvm;
  String? _address;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Future<void> _init() async {
    _isEvm = widget.coin.coinInfo.coinCatetory == CoinCategory.eth || widget.coin.coinInfo.coinCatetory == CoinCategory.erc20;
    _address = await widget.coin.generateAddress(accountIndex: 0, index: 0);
    _updateUI();
  }

  void _updateUI() {
    if (this.mounted) {
      setState(() {});
    }
  }

  Future<void> _startSign() async {
    final CustmsgSignRequest signRequest = CustmsgSignRequest();
    final CoinInfo coinInfo = CoinInfo();
    coinInfo.uname = widget.coin.coinInfo.uname;
    coinInfo.type = widget.coin.coinInfo.type;
    if (widget.coin.coinInfo.path != null) {
      coinInfo.path = widget.coin.coinInfo.path ?? "";
    }
    signRequest.coin = coinInfo;
    signRequest.msgType = 0;
    signRequest.msg = _controller.text;
    signRequest.myAddress = _address!;
    final List<int> signReData = signRequest.writeToBuffer().toList();

    final WalletReqExtInfo extInfo = WalletReqExtInfo(
      qrcodePageTitle: "Sign Message",
      qrcodePageTips: "Please scan the code with your wallet",
      scanPageTitle: "Sign Message",
    );
    await TransportUtil.commandRequest(
        widget.wallet.channelType,
        context: context,
        wallet: widget.wallet,
        data: signReData,
        reqType: MessageType.MSG_CUSTOM_MSG_SIGN_REQUEST,
        respType: MessageType.MSG_CUSTOM_MSG_SIGN_RESP,
        respDataConfirmFinishHandler: (object){
          final CustmsgSignRespone respone = object;
          final String result = "0x" + hex.encode(respone.signData);
          Alert.show(context: context, content: result, options: ["Copy", "Ok"], onPress: (idx){
            UtilsPlugin.copy(result);
          });
        },
        info: extInfo
    );

  }

  @override
  Widget build(BuildContext context) {
    return RootPage(
      title: _isEvm ? "Sign Etherum Message" : "Sign Bitcoin Message",
      child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Text(_address ?? "", style: AppTextStyle.bodyMedium,),
            SizedBox(height: 10,),
            SizedBox(
              height: 100,
              child: TextFormField(
                maxLines: 10,
                controller: _controller,
                decoration: InputDecoration(
                    fillColor: Colors.grey.withAlpha(100),
                    filled: true,
                    hintText: "Please enter message",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                onChanged: (text){
                  _updateUI();
                },
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 200,
              height: 44,
              child: ElevatedButton(
                  child: Text("Next", style: AppTextStyle.headMedium,),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    _startSign();
                  }
              ),
            )
          ],
        ),
      ),
    );
  }
}