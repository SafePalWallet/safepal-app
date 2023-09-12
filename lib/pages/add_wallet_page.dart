
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:safepal_example/pages/pair_device_page.dart';
import 'package:safepal_example/pages/root_page.dart';
import 'package:safepal_example/utils/style.dart';
import 'package:safepal_example/utils/utils_plugin.dart';

import '../widgets/card_widget.dart';


class AddWalletPage extends StatelessWidget {

  final VoidCallback onPress;


  AddWalletPage({
    required this.onPress
  });

  @override
  Widget build(BuildContext context) {

    final Widget richTextWidget = Text.rich(TextSpan(
        text:"Don’t have a SafePal hardware wallet?",
        style: AppTextStyle.bodySmall,
      children: [TextSpan(
          text: " Go get one",
          recognizer: TapGestureRecognizer()..onTap = (){
            UtilsPlugin.openSystemBrowser("https://m.safepal.com/shop");
          },
          style: AppTextStyle.bodySmall.apply(color: Colors.green),
      )])
    );

    return RootPage(
      title: "SafePal",
      showBackIcon: false,
      child: ListView(
        padding: EdgeInsets.only(left: 15, right: 15),
        children: [
          Padding(padding: EdgeInsets.only(top: 40, bottom: 40),
            child: Text("Add a Wallet to Start\n Your Crypto Journey", style: AppTextStyle.headLarge, textAlign: TextAlign.center,),
          ),
          CardWidget(
            width: double.infinity,
            padding: EdgeInsets.only(left: 0, right: 0),
            height: 56,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 15,),
                    Text("Hardware Wallet", style: AppTextStyle.headMedium,),
                    Expanded(child: Container())
                  ],
                )
              ],
            ),
            onPress: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return PairDevicePage();
              }));
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: richTextWidget,
          )
        ],
      ),
    );
  }

}