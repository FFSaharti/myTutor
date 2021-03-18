import 'package:flutter/material.dart';
import 'package:mytutor/utilities/constants.dart';

class MyTheme {
  static final darkTheme = ThemeData(
    // card, banner .. etc color
    cardColor: Color(0xff201f2d),
    scaffoldBackgroundColor: Color(0xff29273d),

    // section background card color
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor:Color(0xff201f2d)),
    // for text
    primaryColor: Colors.black,
    accentColor: Colors.white,
    primaryColorDark: Colors.black,
    bottomAppBarColor: Colors.grey.shade300,
    textSelectionColor: Colors.grey.shade700,
    appBarTheme: AppBarTheme(color: Color(0xff201f2d),
        textTheme: TextTheme(bodyText1: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white), ),
    focusColor:  Color(0xff29273d),
   primaryColorLight:  Color(0xff201f2d),
    iconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.black,
    // pick button, example at chat screen
   highlightColor: Color(0xff201f2d),
    disabledColor: Colors.white,
  );

  static final lightTheme = ThemeData(
    cardColor: Color(0xFFefefef),
    scaffoldBackgroundColor: Colors.white,
    buttonColor: Colors.black,
    accentColor: kColorScheme[4],
    // section background card color
    backgroundColor: Colors.white,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor:Colors.black),
    // for text
    primaryColorDark: kColorScheme[4],
    primaryColor: Colors.white,
    textSelectionColor: Colors.grey,
    appBarTheme: AppBarTheme(color: Colors.grey, textTheme: TextTheme(bodyText1: TextStyle(color: kGreyerish)) , iconTheme: IconThemeData(color: Colors.grey)),
    iconTheme: IconThemeData(color: Colors.black),
    focusColor:  kColorScheme[2],
    primaryColorLight: kWhiteish,
    dividerColor: Colors.transparent,
    // pick button, example at chat screen
    highlightColor:Colors.white,
    disabledColor: kColorScheme[1],
  );
}
