import 'package:flutter/material.dart';

class MyTheme{

  static final darkTheme = ThemeData(
    // card, banner .. etc color
    cardColor:  Colors.grey.shade300,
    scaffoldBackgroundColor: Colors.grey.shade700,
     // section background card color
     backgroundColor: Colors.grey.shade300,
     // for text
     primaryColor: Colors.white,
    bottomAppBarColor: Colors.grey.shade300,
    textSelectionColor: Colors.grey.shade700,
    iconTheme: IconThemeData(color: Colors.white),
  );

  static final lightTheme = ThemeData(
    cardColor: Color(0xFFefefef),
    scaffoldBackgroundColor: Colors.white,
    // section background card color
    backgroundColor: Colors.white,
    // for text
    primaryColor: Colors.black,
    textSelectionColor: Colors.grey,
    iconTheme: IconThemeData(color: Colors.black),

  );
}