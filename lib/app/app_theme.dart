import 'package:flutter/material.dart';

import 'app.dart';
import 'tools/color_extension.dart';

class AppTheme {

  Map<String, String> appFont = {
    'en': 'Ubuntu',
    'sk': 'Ubuntu',
  };

  //colors
  Color get colorPrimary => const Color(0xff344C73);
  Color get colorSecondary => const Color(0xffcde5ef);
  Color get colorBackground => const Color(0xFFeeeeee);
  Color get colorText => const Color(0xFF202020);
  Color get colorTextSecondary => const Color(0xff808080);
  Color get colorIcon => const Color(0xff344C73);
  Color get colorOnPrimary => const Color(0xFFFFFFFF);
  Color get colorInactive => const Color(0xff808080);
  Color get colorNavbar => const Color(0xff3b6ad9);
  Color get colorTabbar => const Color(0xFFFFFFFF);
  Color get colorActive => const Color(0xFFB32A33);
  Color get colorTile => const Color(0xFFFFFFFF);

  Color get colorError => const Color(0xFFFF1744);
  Color get colorWarning => const Color(0xFFFFD200);
  Color get colorSuccess => const Color(0xFF009A38);

  //text
  TextStyle get textSuperHeader => TextStyle(fontSize: 32.0, color: colorText, fontWeight: FontWeight.bold);
  TextStyle get textHeader => TextStyle(fontSize: 18.0, color: colorText, fontWeight: FontWeight.bold);
  TextStyle get textTitle => TextStyle(fontSize: 15.0, color: colorText, fontWeight: FontWeight.normal);
  TextStyle get textBody => TextStyle(fontSize: 12.0, color: colorText, fontWeight: FontWeight.normal);
  TextStyle get textNote => TextStyle(fontSize: 10.0, color: colorText, fontWeight: FontWeight.normal);

  ThemeData get themeData {
    final ThemeData theme =  ThemeData(
      brightness: Brightness.dark,
      fontFamily: appFont[App.cache.language],
      primaryColor: colorPrimary,
      primaryColorLight: colorPrimary,
      primaryColorDark: colorPrimary,
      backgroundColor: colorBackground,
      scaffoldBackgroundColor: colorBackground,
      errorColor: colorError,
      primarySwatch: colorPrimary.materialColor(),
      textTheme: TextTheme(
        headline1: textSuperHeader,
        headline3: textHeader,
        headline5: textHeader,
        subtitle1: textTitle,
        subtitle2: textTitle,
        bodyText1: textBody,
        bodyText2: textBody,
      ),
    );

    return theme;
  }
}
