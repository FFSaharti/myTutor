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
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: height - height * 0.2,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.2, 0.4, 0.6, 0.8],
                    colors: [
                      kBlueScheme[0],
                      kBlueScheme[1],
                      kBlueScheme[2],
                      kBlueScheme[3]
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
                              TextStyle(fontSize: 15, color: Colors.white70)),
                    ),
                  ],
                ),
              ),
              WaveWidget(
                size: mediaQueryData.size,
                yOffset: height / 1.8,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.all(50),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      EZButton(
                        width: width,
                        buttonColor: null,
                        textColor: Colors.white,
                        isGradient: true,
                        colors: [
                          kBlueScheme[2],
                          kBlueScheme[0],
                        ],
                        buttonText: 'Get Started',
                        hasBorder: false,
                        borderColor: null,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TourScreen()),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      EZButton(
                        width: width,
                        buttonColor: Colors.white,
                        textColor: Color(0xFF3F6CF4),
                        isGradient: false,
                        colors: [Color(0xFF59A1FF), Color(0xFF3F6CF4)],
                        buttonText: 'Login',
                        hasBorder: true,
                        borderColor: Color(0xFF59A1FF),
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
        ],
      ),
    );
  }
}
