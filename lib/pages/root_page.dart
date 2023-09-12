import 'package:flutter/material.dart';

import '../utils/style.dart';
import '../widgets/base_app_bar.dart';

class RootPage extends StatelessWidget {

  RootPage({
    Key? key,
    this.title,
    this.actions,
    this.flexibleSpace,
    this.child,
    this.resizeToAvoidBottomInset = true,
    this.bottomNavigationBar,
    this.appBarBgColor,
    this.showTitle = true,
    this.showBackIcon = true,
    this.onTapBack
  }) : super(key : key);

  final String? title;
  final Widget? child;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;
  final Color? appBarBgColor;
  final bool showTitle;
  final VoidCallback? onTapBack;
  final bool showBackIcon;

  @override
  Widget build(BuildContext context) {
    NavigatorState navigatorState = Navigator.of(context);
    AppBar appBar;
    if(showTitle){
      appBar = BaseAppBar.appBar(
        title: Text(this.title ?? "", style: AppTextStyle.titleStyle,),
        flexibleSpace: this.flexibleSpace,
        centerTitle: true,
        leadings: showBackIcon ? [
          ElevatedButton(
            style: TextButton.styleFrom(backgroundColor: Colors.white.withAlpha(0)),
            child: Icon(Icons.arrow_back_ios_new, size: 20, color: AppColor.textDarkColor1),
            onPressed: (){
              if (this.onTapBack != null) {
                this.onTapBack!();
              }
              final bool canPop = Navigator.of(context).canPop();
              if (canPop) {
                Navigator.of(context).pop();
              }
            },
          )
        ] : null,
        backgroundColor: this.appBarBgColor,
      );
    } else {
      appBar = AppBar(toolbarHeight: 0);
    }
    Widget child = Scaffold(
      backgroundColor: AppColor.mainBackground1,
      resizeToAvoidBottomInset:this.resizeToAvoidBottomInset,
      appBar: appBar,
      body: this.child,
      bottomNavigationBar: this.bottomNavigationBar,
    );
    return child;
  }
}