import 'package:flutter/material.dart';
import 'package:mytutor/screens/login_screen.dart';
import 'package:mytutor/screens/tour_screen.dart';
import 'package:mytutor/screens/welcome_screen.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(TutorApp());
}

class TutorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Using Named Routes to specify all the screens in the app
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        TourScreen.id: (context) => TourScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
