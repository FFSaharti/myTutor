import 'package:bd_progress_bar/bdprogreebar.dart';
import 'package:bd_progress_bar/loaders/dot_type.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/screens/welcome_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static Widget logo = Image.asset(
    'images/myTutorLogoWhite.png',
  );

  @override
  void initState() {
    super.initState();
    DatabaseAPI.loadSystem().then((value) => {
          if (value.docs.isNotEmpty)
            {
              Future.delayed(
                Duration(seconds: 1),
                () {
                  //Navigator.pushNamed(context, WelcomeScreen.id);
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 500),
                          child: WelcomeScreen()));
                },
              ),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: kBackgroundGradient,
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Hero(
                  tag: 'logo',
                  child: logo,
                ),
              ),
              Loader4(
                dotOneColor: Colors.white,
                dotTwoColor: Colors.white,
                dotThreeColor: Colors.white,
                dotType: DotType.circle,
              )
            ],
          )),
    );
  }
}
