import 'package:flutter/cupertino.dart';

class ScreenSize {
  static double _width;
  static double _height;

  ScreenSize._() {}

  static void createScreen(BuildContext con) {
    MediaQueryData mediaQueryData = MediaQuery.of(con);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
  }

  static double get width => _width;

  static set width(double value) {
    _width = value;
  }

  static double get height => _height;

  static set height(double value) {
    _height = value;
  }
}
