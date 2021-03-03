import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/animated_materials_widget.dart';
import 'package:mytutor/components/animated_resume_widget.dart';
import 'package:mytutor/components/animated_solveproblem_widget.dart';
import 'package:mytutor/screens/signup_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:page_transition/page_transition.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context, kColorScheme[2], ""),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: ScreenSize.height * 0.03,
            ),
            Container(
              height: ScreenSize.height * 0.52,
              width: double.infinity,
              child: NotificationListener<OverscrollIndicatorNotification>(
                // ignore: missing_return
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int) {
                    VillainController.playAllVillains(context);
                  },
                  children: <Widget>[
                    TourPages(AnimatedResumeWidget(), "Build your résumé",
                        "Fill your profile with a list of your experiences, favorite topics and more!"),
                    TourPages(
                        AnimatedSolveProblemWidget(),
                        "Solve your problems",
                        "Explain your problem, and find solution responses from other Tutors!"),
                    TourPages(AnimatedmMaterialsWidget(), "Find Materials",
                        "View materials posted by Tutors that could really assist you."),
                    // TourPages("images/myTutorLogo.png", "Find Materials",
                    //     "View materials posted by other users that could really assist you."),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.06,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                    controller: _pageController, // PageController
                    count: 3,
                    effect: JumpingDotEffect(
                        dotColor: kGreyish,
                        activeDotColor:
                            kColorScheme[2]), // your preferred effect
                    onDotClicked: (index) {}),
                SizedBox(
                  width: ScreenSize.width * 0.2,
                ),
                Container(
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 25,
                    ),
                    elevation: 1,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: Duration(milliseconds: 200),
                              child: SignupScreen()));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
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
        Villain(
          villainAnimation: VillainAnimation.fade(
            from: Duration(milliseconds: 300),
            to: Duration(milliseconds: 700),
          ),
          child: Text(
            title,
            style: GoogleFonts.secularOne(
                textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: kBlackish)),
          ),
        ),
        SizedBox(
          height: ScreenSize.height * 0.001,
        ),
        Villain(
          villainAnimation: VillainAnimation.fade(
            from: Duration(milliseconds: 300),
            to: Duration(milliseconds: 700),
          ),
          child: Padding(
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
        ),
        // SizedBox(
        //   height: height * 0.05,
        // ),
      ],
    );
  }
}
