import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytutor/screens/adjust_general_settings_screen.dart';
import 'package:mytutor/screens/tutor_screens/tutor_Profile.dart';
import 'package:mytutor/screens/tutor_screens/tutor_section.dart';
import 'package:mytutor/utilities/constants.dart';

import '../message_screen.dart';
import 'homepage_tutor.dart';

class HomepageScreenTutor extends StatefulWidget {
  static String id = 'homepage_screen_tutor';

  @override
  _HomepageScreenTutorState createState() => _HomepageScreenTutorState();
}

class _HomepageScreenTutorState extends State<HomepageScreenTutor> {
  List<Widget> widgets = [
    HomePageTutor(),
    TutorSection(),
    MessageScreen(),
    TutorProfile(),
    AdjustGeneralSettings()
  ];
  int _navindex = 0;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          backgroundColor: Theme.of(context).bottomAppBarColor,
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 400), curve: Curves.easeIn);
            setState(() {
              _currentIndex = index;
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).textSelectionColor,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                FontAwesomeIcons.chalkboardTeacher,
                color: Theme.of(context).textSelectionColor,
              ),
              title: Text(
                'Tutor',
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.message,
                color: Theme.of(context).textSelectionColor,
              ),
              title: Text(
                'Messages',
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).textSelectionColor,
              ),
              title: Text(
                'Profile',
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).textSelectionColor,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontWeight: FontWeight.bold),
              ),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (ind) {
            VillainController.playAllVillains(context);
          },
          children: widgets,
          // [
          //   HomePageTutor(),
          //   TutorSection(),
          //   MessageScreen(),
          //   TutorProfile(),
          //   AdjustGeneralSettings(),
          // ],
        ),
      ),
    );
  }
}
