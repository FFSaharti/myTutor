import 'package:flutter/material.dart';

class MyTheme {
  static final darkTheme = ThemeData(
    // card, banner .. etc color
    cardColor: Color(0xff201f2d),
    scaffoldBackgroundColor: Color(0xff29273d),
    // section background card color
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
    // for text
    primaryColor: Colors.black,
    bottomAppBarColor: Colors.grey.shade300,
    textSelectionColor: Colors.grey.shade700,
    iconTheme: IconThemeData(color: Colors.white),
  );

  static final lightTheme = ThemeData(
    cardColor: Color(0xFFefefef),
    scaffoldBackgroundColor: Colors.transparent,
    // section background card color
    backgroundColor: Colors.white,
    // for text
    primaryColor: Colors.white,
    textSelectionColor: Colors.grey,
    iconTheme: IconThemeData(color: Colors.black),
  );
}
