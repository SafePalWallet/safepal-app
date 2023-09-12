import 'package:flutter/material.dart';

final DarkAppColor AppColor = DarkAppColor();

class DarkAppColor {
  Color mainBackground1 = Color(0xFF000000);
  Color mainBackground2 = Color(0xFF1C1D1F);
  Color mainBackground3 = Color(0xFF2C2D30);
  Color mainBackground4 = Color(0xFF3A3C40);

  Color line = Color(0xFF2C2D30);
  Color lineWhite = Color(0xFFE1E0EC);
  Color lineButton = Color(0xFF9E9BC1);
  Color lineOptions = Color(0xFF504E6D);

  Color textDarkColor1 = Color(0xFFFFFFFF);
  Color textDarkColor1_30 = Color(0x4CFFFFFF);
  Color textDarkColor2 = Color(0xFFCAC9D8);

  //dialog bg color
  Color dialogBg = Color(0xFF1C1D1F);

  Color dialogTextColor1 = Color(0xFFF0F2F5);
  Color dialogTextColor2 = Color(0xFFA1A7B3);
  Color dialogTextColor3 = Color(0xFF8A8F99);
  Color dialogTextColor4 = Color(0xFF5C5F66);
  Color dialogTextColor5 = Color(0xFFF0F2F5);
  Color dialogLineWhite = Color(0x19828A99);
  Color dialogDownBackground1 = Color(0xFF222B3D);
  Color dialogDownBackground2 = Color(0xFF222B3D);

  Color blue_30 = Color(0x4C6A66FF);
  Color blue = Color(0xFF6A66FF);
  Color blue_20 = Color(0x336A66FF);
  Color blue_40 = Color(0x666A66FF);
}

class AppTextStyle {

  static TextStyle titleStyle = TextStyle(color: AppColor.textDarkColor1, fontSize: 18, fontWeight: FontWeight.w500);
  static TextStyle inputTitleStyle = TextStyle(color: AppColor.textDarkColor1,fontSize: 15,fontWeight: FontWeight.w500);
  static TextStyle labelTitleStyle = TextStyle(color: AppColor.textDarkColor2,fontSize: 15,fontWeight: FontWeight.w500);

  // new version
  static TextStyle _buildHeadTextStyle(double fontSize, {FontWeight? fontWeight}) {
    return TextStyle(
      color: AppColor.textDarkColor1,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w500
    );
  }

  static TextStyle _buildBodyTextStyle(double fontSize, {FontWeight? fontWeight}) {
    return TextStyle(
        color: AppColor.textDarkColor1,
        fontSize: fontSize,
        fontWeight: fontWeight?? FontWeight.w400
    );
  }

  static TextStyle displayLarge = _buildHeadTextStyle(44, fontWeight:FontWeight.w400);
  static TextStyle displayMedium = _buildHeadTextStyle(24); // head x large
  static TextStyle headLarge = _buildHeadTextStyle(18);
  static TextStyle headMedium = _buildHeadTextStyle(16);
  static TextStyle headSmall = _buildHeadTextStyle(14);
  static TextStyle headTiny = _buildHeadTextStyle(12);
  static TextStyle headSubTiny = _buildHeadTextStyle(10);
  static TextStyle caption = _buildHeadTextStyle(12);

  static TextStyle bodyLarge = _buildBodyTextStyle(18);
  static TextStyle bodyMedium = _buildBodyTextStyle(16);
  static TextStyle bodySmall = _buildBodyTextStyle(14);
  static TextStyle bodyTiny = _buildBodyTextStyle(12);
  static TextStyle bodySubTiny = _buildBodyTextStyle(10);
}