import 'package:flutter/cupertino.dart';

class ScreenSize {
  static double _width;
  static double _height;
  static BuildContext _context;

  ScreenSize._() {}

  static void createScreen(BuildContext con) {
    MediaQueryData mediaQueryData = MediaQuery.of(con);
    _context = con;
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
  }

  static BuildContext get context => _context;

  static set context(BuildContext value) {
    _context = value;
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
