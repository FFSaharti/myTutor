import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/tour_screen.dart';
import 'package:mytutor/utilities/constants.dart';

import 'login_screen.dart';

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
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.2, 0.4, 0.6, 0.8],
            colors: [
              kColorScheme[0],
              kColorScheme[1],
              kColorScheme[2],
              kColorScheme[3],
            ],
          ),
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
                height: 130,
                width: 130,
              ),
            ),
            Text(
              'My Tutor',
              style: GoogleFonts.secularOne(
                  textStyle: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            Text(
              'Your Tutor, right in your pocket',
              style: GoogleFonts.secularOne(
                  textStyle: TextStyle(fontSize: 15, color: Colors.white)),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Expanded(
              child: Hero(
                tag: 'Container',
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
                            height: 40,
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
            ),
          ],
        ),
      ),
    );
  }
}

// Stack(
// children: <Widget>[
// Container(
// height: height - height * 0.1,
// width: double.infinity,
// decoration: BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topRight,
// end: Alignment.bottomLeft,
// stops: [0.2, 0.4, 0.6, 0.8],
// colors: [
// kColorScheme[0],
// kColorScheme[1],
// kColorScheme[2],
// kColorScheme[3],
// ],
// ),
// ),
// child: Column(
// children: <Widget>[
// SizedBox(
// height: height * 0.12,
// ),
// Stack(
// children: [
// Center(
// child: Container(
// height: 120,
// width: 120,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(90),
// color: Colors.white,
// ),
// ),
// ),
// Center(
// child: Hero(
// tag: 'logo',
// child: Image.asset(
// 'images/myTutorLogoWhite.png',
// height: 130,
// width: 130,
// ),
// ),
// ),
// ],
// ),
// Text(
// 'My Tutor',
// style: GoogleFonts.secularOne(
// textStyle: TextStyle(
// fontSize: 50,
// fontWeight: FontWeight.bold,
// color: Colors.white)),
// ),
// SizedBox(
// height: 1,
// ),
// Text(
// 'Your Tutor, right in your pocket',
// style: GoogleFonts.secularOne(
// textStyle:
// TextStyle(fontSize: 15, color: Colors.white)),
// ),
// ],
// ),
// ),
// WaveWidget(
// size: mediaQueryData.size,
// yOffset: height / 1.8,
// colors: [Colors.white, Colors.white, Colors.white, Colors.white],
// ),
// SizedBox(
// height: 50,
// ),
// Padding(
// padding: EdgeInsets.all(50),
// child: Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.end,
// children: <Widget>[
// EZButton(
// width: width,
// buttonColor: Colors.white,
// textColor: Colors.white,
// isGradient: true,
// colors: [
// kColorScheme[1],
// kColorScheme[2],
// kColorScheme[3],
// kColorScheme[4]
// ],
// buttonText: 'Get Started',
// hasBorder: false,
// borderColor: kColorScheme[3],
// onPressed: () {
// Navigator.pushNamed(context, TourScreen.id);
// },
// ),
// SizedBox(
// height: 15,
// ),
// EZButton(
// width: width,
// buttonColor: Colors.white,
// textColor: kColorScheme[3],
// isGradient: false,
// colors: null,
// buttonText: 'Login',
// hasBorder: true,
// borderColor: kColorScheme[3],
// onPressed: () {
// Navigator.pushNamed(context, LoginScreen.id);
// },
// ),
// SizedBox(
// height: 40,
// ),
// ],
// ),
// ),
// ),
// ],
// ),
