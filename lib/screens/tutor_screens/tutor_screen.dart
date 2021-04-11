import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/screens/adjust_general_settings_screen.dart';
import 'package:mytutor/screens/tutor_screens/tutor_options.dart';
import 'package:mytutor/screens/tutor_screens/tutor_profile.dart';

import '../message_screen.dart';
import 'homepage_tutor.dart';

class HomepageScreenTutor extends StatefulWidget {
  static String id = 'homepage_screen_tutor';

  @override
  _HomepageScreenTutorState createState() => _HomepageScreenTutorState();
}

class _HomepageScreenTutorState extends State<HomepageScreenTutor> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController();
    return DisableDefaultPop(
      child: Scaffold(
        bottomNavigationBar: BottomNavyBar(
          key: const ValueKey("tutor_bottom_bar"),
          backgroundColor: Theme.of(context).cardColor,
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
            // _pageController.jumpToPage(_currentIndex);
            _pageController
                .animateToPage(_currentIndex,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut)
                .then((value) => {VillainController.playAllVillains(context)});
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).appBarTheme.iconTheme.color,
              ),
              title: Text(
                'Home',
                style: GoogleFonts.sen(
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
                'Tutor',
                style: GoogleFonts.sen(
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
                style: GoogleFonts.sen(
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
                key: const ValueKey("tutor_profile_bottom_bar"),
              ),
              title: Text(
                'Profile',
                style: GoogleFonts.sen(
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
                key: const ValueKey("tutor_settings_bottom_bar"),
              ),
              title: Text(
                'Settings',
                style: GoogleFonts.sen(
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
        resizeToAvoidBottomInset: false,
        body: PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            HomePageTutor(),
            TutorOptions(),
            MessageScreen(),
            TutorProfile(),
            AdjustGeneralSettings()
          ],
        ),
      ),
    );
  }
}
