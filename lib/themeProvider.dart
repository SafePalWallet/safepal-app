
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safepal_example/utils/style.dart';

final ThemeProvider themeProvider = ThemeProvider();

class ThemeProvider {
  static const String dark = 'dark';
  static const String light = 'light';
  static const String system = 'system';

  ThemeData? lightTheme;
  ThemeData? darkTheme;
  
  ThemeMode? themeMode;
  String? themeString;

  Future init()async{
    themeMode = _stringToMode(themeString);
    initColorConfig();
    initRootThemeData();
  }

  void initSystemTheme(BuildContext context){
    if(themeMode==null || themeMode==ThemeMode.system){
      var sysModel = MediaQuery.platformBrightnessOf(context);
      if(sysModel == Brightness.light){
        themeMode = ThemeMode.light;
      }else{
        themeMode = ThemeMode.dark;
      }
      initColorConfig();
      initRootThemeData();
    }
  }

  get currentTheme{
    return themeMode!=ThemeMode.light?darkTheme:lightTheme;
  }

  get currentThemeModel{
    return _stringToMode(themeString);
  }

  ThemeMode _stringToMode(String? themeStr){
    if(themeStr==null || themeStr.isEmpty){
      return ThemeMode.dark;
    }
      switch(themeStr){
        case dark:
          return ThemeMode.dark;
        case light:
          return ThemeMode.light;
        case system:
          return ThemeMode.system;
      }
      return ThemeMode.dark;
  }

  String modelToString(ThemeMode model){
    if(model==null){
      return dark;
    }
      switch(model){
        case ThemeMode.dark:
          return dark;
        case ThemeMode.light:
          return light;
        case ThemeMode.system:
          return system;
      }
  }

  void initRootThemeData() {
    Map<TargetPlatform, PageTransitionsBuilder> _defaultBuilders = <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    };
    PageTransitionsTheme pageTransitionsTheme = PageTransitionsTheme(builders: _defaultBuilders);
    TextTheme textTheme = TextTheme(button: TextStyle(fontWeight: FontWeight.w400));
    TextSelectionThemeData textSelectionThemeData = TextSelectionThemeData(
      cursorColor: AppColor.blue,
      selectionColor: AppColor.blue,
      selectionHandleColor: AppColor.blue
    );
    darkTheme = ThemeData(
      brightness: Brightness.dark,
      pageTransitionsTheme: pageTransitionsTheme,
      primaryColor: Colors.black,
      backgroundColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      textTheme: textTheme,
      textSelectionTheme: textSelectionThemeData,
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(subtitle1:TextStyle(fontWeight: FontWeight.w400)),
      ),
    );
  }


  void initColorConfig() {
    SystemUiOverlayStyle mySystemTheme= SystemUiOverlayStyle.dark
        .copyWith(systemNavigationBarColor: AppColor.mainBackground1,statusBarColor: AppColor.mainBackground1);
    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
  }
}