import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(TutorApp());
}

class TutorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}
