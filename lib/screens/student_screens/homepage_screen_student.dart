import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/session_stream_widget.dart';
import 'package:mytutor/screens/adjust_general_settings_screen.dart';
import 'package:mytutor/screens/student_screens/profile_student_screen.dart';
import 'package:mytutor/screens/student_screens/student_sections_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../message_screen.dart';

class HomepageScreenStudent extends StatefulWidget {
  static String id = 'homepage_screen_student';

  @override
  _HomepageScreenStudentState createState() => _HomepageScreenStudentState();
}

class _HomepageScreenStudentState extends State<HomepageScreenStudent> {
  List<Widget> widgets = <Widget>[
    HomePageStudent(),
    StudentSection(),
    MessageScreen(),
    ProfileStudent(),
    AdjustGeneralSettings(),
  ];

  double width;
  double height;
  int _navindex = 0;
  int _currentIndex = 0;
  PageController _pageController = PageController();

  void changeindex(int index) {
    setState(() {
      _navindex = index;
      print(_navindex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Theme.of(context).cardColor,
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
              _pageController
                  .animateToPage(_currentIndex,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut)
                  .then(
                      (value) => {VillainController.playAllVillains(context)});
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                    color:
                        Theme.of(context).appBarTheme.textTheme.bodyText1.color,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: Theme.of(context).focusColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.chalkboardTeacher,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              title: Text(
                'Student',
                style: TextStyle(
                    color:
                        Theme.of(context).appBarTheme.textTheme.bodyText1.color,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: Theme.of(context).focusColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.message,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              title: Text(
                'Messages',
                style: TextStyle(
                    color:
                        Theme.of(context).appBarTheme.textTheme.bodyText1.color,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: Theme.of(context).focusColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                    color:
                        Theme.of(context).appBarTheme.textTheme.bodyText1.color,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: Theme.of(context).focusColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    color:
                        Theme.of(context).appBarTheme.textTheme.bodyText1.color,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: Theme.of(context).focusColor,
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        body: PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: widgets,
        ),
      ),
    );
  }
}

class HomePageStudent extends StatefulWidget {
  @override
  _HomePageStudentState createState() => _HomePageStudentState();
}

class _HomePageStudentState extends State<HomePageStudent> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.height * 0.09,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Villain(
                  villainAnimation: VillainAnimation.fromLeft(
                    from: Duration(milliseconds: 30),
                    to: Duration(milliseconds: 300),
                  ),
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Welcome,\nStudent ",
                          style: GoogleFonts.sarabun(
                              textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).buttonColor,
                          )),
                        ),
                        TextSpan(
                          text: DatabaseAPI.tempStudent.name,
                          style: GoogleFonts.sarabun(
                              textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).buttonColor,
                          )),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            SingleChildScrollView(
              child: Container(
                height: ScreenSize.height * 0.50,
                child: NotificationListener<OverscrollIndicatorNotification>(
                  // ignore: missing_return
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: PageView(
                    controller: _pageController,
                    children: [
                      mainScreenPage(
                          SessionStream(
                            status: "active",
                            type: 0,
                            checkexpire: false,
                            isStudent: true,
                            expiredSessionView: false,
                          ),
                          "Upcoming Sessions"),
                      mainScreenPage(
                          SessionStream(
                            status: "pending",
                            type: 0,
                            checkexpire: false,
                            isStudent: true,
                            expiredSessionView: false,
                          ),
                          "Pending Sessions"),
                      mainScreenPage(
                          SessionStream(
                            status: "waiting for student",
                            type: 0,
                            checkexpire: false,
                            isStudent: true,
                            expiredSessionView: false,
                          ),
                          "Waiting for your response"),
                      mainScreenPage(
                          SessionStream(
                            status: "closed",
                            type: 0,
                            checkexpire: false,
                            isStudent: true,
                            expiredSessionView: true,
                          ),
                          "Closed Sessions"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.05,
            ),
            SmoothPageIndicator(
              effect: WormEffect(
                  dotColor: kGreyish, activeDotColor: kColorScheme[2]),
              controller: _pageController, // PageController
              count: 4,
            ),
          ],
        ),
      ),
    );
  }

  mainScreenPage(Widget StreamWidget, String title) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "    " + title,
            style: GoogleFonts.sarabun(
                textStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).buttonColor)),
          ),
        ),
        SizedBox(
          height: ScreenSize.height * 0.01,
        ),
        StreamWidget,
        SizedBox(
          height: ScreenSize.height * 0.01,
        ),
      ],
    );
  }
}
