import 'package:flutter/material.dart';
import 'package:mytutor/screens/welcome_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.3, 0.7],
            colors: [
              Color(0xFF3F6CF4),
              Color(0xFF59A1FF),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
              },
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/myTutorLogoWhite.png',
                  width: 250,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
