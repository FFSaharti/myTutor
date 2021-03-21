import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/screens/tour_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:page_transition/page_transition.dart';

import 'login_screen.dart';

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    ScreenSize.createScreen(context);
    return DisableDefaultPop(
      child: Scaffold(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor == Colors.white
                ? Colors.transparent
                : Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          width: ScreenSize.width,
          decoration: BoxDecoration(
            gradient: !(Theme.of(context).scaffoldBackgroundColor ==
                    Color(0xff29273d))
                ? kBackgroundGradient
                : null,
          ),
          child: Column(
            children: [
              SizedBox(
                height: ScreenSize.height * 0.1,
              ),
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/myTutorLogoWhite.png',
                  height: ScreenSize.height * 0.25,
                ),
              ),
              SizedBox(
                width: ScreenSize.width,
                child: TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  text: [
                    "My Tutor",
                  ],
                  textStyle: GoogleFonts.sen(
                      fontSize: 50, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.05,
              ),
              Expanded(
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(50),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: [
                              SizedBox(
                                height: ScreenSize.height * 0.02,
                              ),
                              Text(
                                "Find the perfect tutor! that will assist in all your problems.",
                                style: GoogleFonts.sen(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .buttonColor
                                        .withOpacity(0.4)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.05,
                              ),
                              Villain(
                                villainAnimation: VillainAnimation.fromLeft(
                                  from: Duration(milliseconds: 100),
                                  to: Duration(milliseconds: 400),
                                ),
                                animateExit: false,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: CircularButton(
                                    width: ScreenSize.width * 0.9,
                                    buttonColor: null,
                                    textColor: Colors.white,
                                    isGradient: true,
                                    colors: [
                                      kColorScheme[1],
                                      kColorScheme[2],
                                      kColorScheme[3],
                                      kColorScheme[4]
                                    ],
                                    buttonText: 'Sign In',
                                    hasBorder: true,
                                    borderColor: kColorScheme[3],
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType.bottomToTop,
                                          duration: Duration(milliseconds: 200),
                                          child: LoginScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.02,
                              ),
                              Villain(
                                villainAnimation: VillainAnimation.fromRight(
                                  from: Duration(milliseconds: 300),
                                  to: Duration(milliseconds: 700),
                                ),
                                animateExit: false,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: CircularButton(
                                    width: ScreenSize.width * 0.9,
                                    buttonColor: Theme.of(context).buttonColor,
                                    textColor: Theme.of(context).primaryColor,
                                    isGradient: false,
                                    colors: null,
                                    buttonText: 'Get Started',
                                    hasBorder: false,
                                    borderColor: kColorScheme[3],
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .bottomToTop,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              child: TourScreen()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  width: ScreenSize.width,
                  decoration:
                      kCurvedShapeDecoration(Theme.of(context).cardColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
