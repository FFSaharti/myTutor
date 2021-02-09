import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/tour_screen.dart';
import 'package:mytutor/utilities/constants.dart';

import 'login_screen.dart';

// ignore: must_be_immutable
class WelcomeScreen extends StatelessWidget {
  double width;
  double height;

  static String id = 'welcome_screen';
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        // color: Colors.white,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            Hero(
              tag: 'logo',
              child: Image.asset(
                'images/myTutorLogoWhite.png',
                height: 200,
                width: 200,
              ),
            ),
            SizedBox(
              width: 250.0,
              child: TypewriterAnimatedTextKit(
                speed: Duration(milliseconds: 200),
                text: [
                  "My Tutor",
                ],
                textStyle: kTitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Opacity(
              opacity: 0.8,
              child: Text(
                'Your Tutor, right in your pocket',
                style: kTitleStyle.copyWith(fontSize: 18),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        EZButton(
                          width: width,
                          buttonColor: Colors.white,
                          textColor: Colors.white,
                          isGradient: true,
                          colors: [
                            kColorScheme[1],
                            kColorScheme[2],
                            kColorScheme[3],
                            kColorScheme[4]
                          ],
                          buttonText: 'Get Started',
                          hasBorder: false,
                          borderColor: kColorScheme[3],
                          onPressed: () {
                            Navigator.pushNamed(context, TourScreen.id);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        EZButton(
                          width: width,
                          buttonColor: Colors.white,
                          textColor: kColorScheme[3],
                          isGradient: false,
                          colors: null,
                          buttonText: 'Login',
                          hasBorder: true,
                          borderColor: kColorScheme[3],
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45),
                      topLeft: Radius.circular(45)),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
