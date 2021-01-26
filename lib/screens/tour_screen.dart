import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/animated_materials_widget.dart';
import 'package:mytutor/components/animated_resume_widget.dart';
import 'package:mytutor/components/animated_solveproblem_widget.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/login_page.dart';
import 'package:mytutor/utilities/constants.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: height - height * 0.23,
            width: double.infinity,
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
          Container(
            child: EZButton(
              width: width,
              buttonColor: null,
              textColor: Colors.white,
              isGradient: true,
              colors: [kColorScheme[1], kColorScheme[0]],
              buttonText: 'Get Started',
              hasBorder: false,
              borderColor: null,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ),
          SizedBox(
            height: height * 0.06,
          ),
          SmoothPageIndicator(
              controller: _pageController, // PageController
              count: 3,
              effect: JumpingDotEffect(
                  dotColor: kGreyish,
                  activeDotColor: kColorScheme[2]), // your preferred effect
              onDotClicked: (index) {}),
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
          height: height * 0.10,
        ),
        animatedWidget,
        SizedBox(
          height: height * 0.03,
        ),
        Text(
          title,
          style: GoogleFonts.secularOne(
              textStyle: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: kBlackish)),
        ),
        SizedBox(
          height: height * 0.02,
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
