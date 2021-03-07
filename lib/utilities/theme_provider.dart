import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // assume that the user using diff mode then light.
  ThemeMode currentTheme = ThemeMode.system;

  bool get isDark => currentTheme == ThemeMode.dark;

 void changeMode(bool status){

   status == true ? currentTheme = ThemeMode.dark : currentTheme = ThemeMode.light;
   notifyListeners();
 }
}