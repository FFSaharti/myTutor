import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/screens/ask_screen_student.dart';
import 'package:mytutor/screens/homepage_screen_student.dart';
import 'package:mytutor/screens/homepage_screen_tutor.dart';
import 'package:mytutor/screens/interests_screen.dart';
import 'package:mytutor/screens/login_screen.dart';
import 'package:mytutor/screens/signup_screen.dart';
import 'package:mytutor/screens/tour_screen.dart';
import 'package:mytutor/screens/welcome_screen.dart';

import 'screens/specify_role_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        SignupScreen.id: (context) => SignupScreen(),
        SpecifyRoleScreen.id: (context) => SpecifyRoleScreen(),
        InterestsScreen.id: (context) => InterestsScreen(),
        HomepageScreenStudent.id: (context) => HomepageScreenStudent(),
        HomepageScreenTutor.id: (context) => HomepageScreenTutor(),
        AskScreenStudent.id: (context) => AskScreenStudent(),
      },
    );
  }
}
