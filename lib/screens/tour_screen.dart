import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/animated_materials_widget.dart';
import 'package:mytutor/components/animated_resume_widget.dart';
import 'package:mytutor/components/animated_solveproblem_widget.dart';
import 'package:mytutor/components/disable_default_pop.dart';
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
    return DisableDefaultPop(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: buildAppBar(context, Theme.of(context).accentColor, ""),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: ScreenSize.height * 0.65,
              child: disableBlueOverflow(
                context,
                PageView(
                  controller: _pageController,
                  onPageChanged: (int) {
                    // if the page changes, will play all the animations again
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
                    //     "View materials posted by other users that could really assist you."),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: ScreenSize.width * 0.01,
                ),
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
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .backgroundColor,
                    textColor: Colors.white,
                    child: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 24,
                    ),
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
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
            style: GoogleFonts.sen(
                textStyle: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).buttonColor)),
          ),
        ),
        SizedBox(
          height: ScreenSize.height * 0.05,
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
              style: GoogleFonts.sen(
                  textStyle: TextStyle(
                      height: 1.5,
                      fontSize: 15,
                      color: Theme.of(context).buttonColor.withOpacity(0.6),
                      fontWeight: FontWeight.w100)),
            ),
          ),
        ),
      ],
    );
  }
}
