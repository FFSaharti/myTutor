import 'package:flutter/material.dart';
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
                height: height - height * 0.1,
                width: double.infinity,
                color: kBlueScheme[0],
                // Add Column As Child...
              ),
              WaveWidget(
                size: mediaQueryData.size,
                yOffset: height / 2.5,
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
                        colors: [Color(0xFF59A1FF), Color(0xFF3F6CF4)],
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

// Hero(
// tag: 'logo',
// child: Image.asset(
// 'images/myTutorLogoColored.png',
// ),
// ),

// Text(
// 'My Tutor',
// style: GoogleFonts.secularOne(
// textStyle: TextStyle(
// fontSize: 30,
// fontWeight: FontWeight.bold,
// color: Color(0xFF3F6CF4))),
// ),
