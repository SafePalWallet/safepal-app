
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safepal_example/pages/add_wallet_page.dart';
import 'package:safepal_example/pages/main_wallet_page.dart';
import 'package:safepal_example/themeProvider.dart';
import 'package:safepal_example/utils/lang.dart';

import 'coins/chain_config.dart';
import 'manager/wallet_manager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  _initApp();
}

void _initApp() async {
  await themeProvider.init();
  await langConfig.asyncGetCurLang();
  await chainConfigManager.init();
  WalletManager walletManager = WalletManager.instance;
  await walletManager.initWalletManager();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    WalletManager.instance.addDidChangeWalletCallback(callback: (){
      updateUI();
    });
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void updateUI() {
    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _createHomePage() {
    final WalletManager instance = WalletManager.instance;
    if (instance.isBinded()) {
      return MainWalletPage();
    }
    return AddWalletPage(onPress: (){
      Navigator.of(this.context).push(MaterialPageRoute(builder: (context){
        return MainWalletPage();
      }));
    },);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    MaterialApp materialApp = MaterialApp(
      navigatorKey: navigatorKey,
        title: "SafePal App Core",
        localeResolutionCallback: (locale, locales) {
          if (locales.contains(locale)) {
            return locale;
          }
          return langConfig.curLang!.locale;
        },
        supportedLocales: langConfig.supportedLocales(),
        locale: langConfig.curLang!.locale,
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        themeMode: themeProvider.themeMode,
        home: _createHomePage(), //主体部分
    );
    return materialApp;
  }
}
