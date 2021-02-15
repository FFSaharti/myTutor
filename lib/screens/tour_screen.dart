import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/animated_materials_widget.dart';
import 'package:mytutor/components/animated_resume_widget.dart';
import 'package:mytutor/components/animated_solveproblem_widget.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/signup_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TourScreen extends StatefulWidget {
  static String id = 'tour_screen';
  @override
  _TourScreenState createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenSize.height * 0.05,
          ),
          Hero(
            tag: 'logo',
            child: Image.asset(
              'images/myTutorLogoColored.png',
              height: 50,
              width: 50,
            ),
          ),
          SizedBox(
            height: ScreenSize.height * 0.04,
          ),
          Container(
            height: ScreenSize.height * 0.6,
            width: double.infinity,
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: PageView(
                controller: _pageController,
                children: <Widget>[
                  TourPages(AnimatedResumeWidget(), "Build your résumé",
                      "Fill your profile with a list of your experiences, favorite topics and more!"),
                  TourPages(AnimatedSolveProblemWidget(), "Solve your problems",
                      "Explain your problem, and find solution responses from other Tutors!"),
                  TourPages(AnimatedmMaterialsWidget(), "Find Materials",
                      "View materials posted by Tutors that could really assist you."),
                  // TourPages("images/myTutorLogo.png", "Find Materials",
                  //     "View materials posted by other users that could really assist you."),
                ],
              ),
            ),
          ),
          Container(
            child: EZButton(
              width: ScreenSize.width,
              buttonColor: null,
              textColor: Colors.white,
              isGradient: true,
              colors: [kColorScheme[1], kColorScheme[0]],
              buttonText: 'Get Started',
              hasBorder: false,
              borderColor: null,
              onPressed: () {
                Navigator.pushNamed(context, SignupScreen.id);
              },
            ),
          ),
          SizedBox(
            height: ScreenSize.height * 0.06,
          ),
          SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 3,
              effect: JumpingDotEffect(
                  dotColor: kGreyish,
                  activeDotColor: kColorScheme[2]), // your preferred effect
              onDotClicked: (index) {}),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              child: SizedBox(
                height: 3,
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
    );
  }

  Column TourPages(
    Widget animatedWidget,
    String title,
    String desc,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: ScreenSize.height * 0.01,
        ),
        animatedWidget,
        SizedBox(
          height: ScreenSize.height * 0.005,
        ),
        Text(
          title,
          style: GoogleFonts.secularOne(
              textStyle: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: kBlackish)),
        ),
        SizedBox(
          height: ScreenSize.height * 0.001,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(13.0, 0, 13.0, 0.0),
          child: Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
                textStyle: TextStyle(
                    height: 1.5,
                    fontSize: 15,
                    color: kGreyish,
                    fontWeight: FontWeight.w100)),
          ),
        ),
        // SizedBox(
        //   height: height * 0.05,
        // ),
      ],
    );
  }
}
