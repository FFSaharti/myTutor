import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/components/wave_widget.dart';
import 'package:mytutor/utilities/constants.dart';

import 'tour_screen.dart';

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
        child: Stack(
          children: <Widget>[
            Container(
              height: height - height * 0.1,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.2, 0.4, 0.6, 0.8],
                  colors: [
                    kColorScheme[1],
                    kColorScheme[2],
                    kColorScheme[3],
                    kColorScheme[4],
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'images/myTutorLogoWhite.png',
                      width: 150,
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
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    'Your Tutor, right in your pocket',
                    style: GoogleFonts.secularOne(
                        textStyle:
                            TextStyle(fontSize: 15, color: Colors.white)),
                  ),
                ],
              ),
            ),
            WaveWidget(
              size: mediaQueryData.size,
              yOffset: height / 1.8,
              colors: [Colors.white, Colors.white, Colors.white, Colors.white],
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
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
                        kColorScheme[0],
                        kColorScheme[1],
                        kColorScheme[2],
                        kColorScheme[3]
                      ],
                      buttonText: 'Get Started',
                      hasBorder: false,
                      borderColor: kColorScheme[3],
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TourScreen()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    EZButton(
                      width: width,
                      buttonColor: Colors.white,
                      textColor: kColorScheme[2],
                      isGradient: false,
                      colors: null,
                      buttonText: 'Login',
                      hasBorder: true,
                      borderColor: kColorScheme[3],
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
