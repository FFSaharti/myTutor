import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TourScreen extends StatefulWidget {
  static String id = 'tour_screen';
  @override
  _TourScreenState createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  PageController _pageController = PageController();
  MediaQueryData qDate;
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    qDate = MediaQuery.of(context);
    width = qDate.size.width;
    height = qDate.size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 35,
          ),
          Container(
            height: height * 0.57,
            width: double.infinity,
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                TourPages("images/portfolio.png", "Build your resume",
                    "Fill your profile with a list of your experiences, favorite topics and more!"),
                TourPages("images/myTutorLogo.png", "Find Materials",
                    "View materials posted by other users that could really assist you."),
              ],
            ),
          ),
          Container(
            child: EZButton(
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
                  MaterialPageRoute(builder: (context) => TourScreen()),
                );
              },
            ),
          ),
          SizedBox(
            height: height * 0.10,
          ),
          SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 3,
              effect: WormEffect(), // your preferred effect
              onDotClicked: (index) {}),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Column TourPages(
    String imgpath,
    String title,
    String desc,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imgpath,
          height: height * 0.30,
        ),
        SizedBox(
          height: height * 0.07,
        ),
        Text(
          title,
          style: GoogleFonts.secularOne(
              textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF505050))),
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(13.0, 0, 13.0, 13.0),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
                textStyle: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w100)),
          ),
        ),
        SizedBox(
          height: height * 0.05,
        ),
      ],
    );
  }
}
