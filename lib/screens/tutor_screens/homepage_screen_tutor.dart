import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/session_stream_widget.dart';
import 'package:mytutor/screens/adjust_general_settings_screen.dart';
import 'package:mytutor/screens/tutor_screens/answer_screen_tutor.dart';
import 'package:mytutor/screens/tutor_screens/create_materials_screen.dart';
import 'package:mytutor/screens/tutor_screens/respond_screen_tutor.dart';
import 'package:mytutor/screens/tutor_screens/tutor_Profile.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

import '../message_screen.dart';

class HomepageScreenTutor extends StatefulWidget {
  static String id = 'homepage_screen_tutor';

  @override
  _HomepageScreenTutorState createState() => _HomepageScreenTutorState();
}

class _HomepageScreenTutorState extends State<HomepageScreenTutor> {
  List<Widget> widgets = <Widget>[
    HomePageTutor(),
    TutorSection(),
    MessageScreen(),
    tutorProfile(),
  ];
  int _navindex = 0;
  int _currentIndex = 0;

  void changeindex(int index) {
    setState(() {
      VillainController.playAllVillains(context);
      _navindex = index;
      print(_navindex);
    });
  }

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
                duration: Duration(milliseconds: 450), curve: Curves.easeIn);
            setState(() {
              _currentIndex=index;
            });
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.home,color: Theme.of(context).textSelectionColor,),
              title: Text('Home', style: TextStyle(color: Theme.of(context).textSelectionColor, fontWeight: FontWeight.bold),),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(FontAwesomeIcons.chalkboardTeacher,color: Theme.of(context).textSelectionColor,),
              title: Text('Tutor',style: TextStyle(color: Theme.of(context).textSelectionColor, fontWeight: FontWeight.bold),),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.message, color: Theme.of(context).textSelectionColor,),
              title: Text('Messages',style: TextStyle(color: Theme.of(context).textSelectionColor, fontWeight: FontWeight.bold),),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person,color: Theme.of(context).textSelectionColor,),
              title: Text('Profile',style: TextStyle(color: Theme.of(context).textSelectionColor, fontWeight: FontWeight.bold),),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings,color: Theme.of(context).textSelectionColor,),
              title: Text('Settings',style: TextStyle(color: Theme.of(context).textSelectionColor, fontWeight: FontWeight.bold),),
              activeColor: kColorScheme[2],
              inactiveColor: Colors.grey,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: PageView(
          physics:new NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            HomePageTutor(),
            TutorSection(),
            MessageScreen(),
            tutorProfile(),
            AdjustGeneralSettings(),
          ],
        ),
      ),
    );
  }
}

class HomePageTutor extends StatefulWidget {
  @override
  _HomePageTutorState createState() => _HomePageTutorState();
}

class _HomePageTutorState extends State<HomePageTutor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.height * 0.10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Villain(
                villainAnimation: VillainAnimation.fromLeft(
                  from: Duration(milliseconds: 30),
                  to: Duration(milliseconds: 300),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Welcome,\nTutor ",
                        style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor)),
                      ),
                      TextSpan(
                        text: SessionManager.loggedInTutor.name,
                        style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.04,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    "    Active/Upcoming Sessions",
                    style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).primaryColor)),
                  ),
                  //
                ],
              ),
            ),

            SessionStream(
              status: "active",
              isStudent: false,
              type: 1,
              checkexpire: false,
              expiredSessionView: false,
            ),
            SizedBox(
              height: ScreenSize.height * 0.05,
            ),
            //SessionWidget(height: height),
          ],
        ),
      ),
    );
  }
}

class TutorSection extends StatefulWidget {
  double height;
  double width;

  @override
  _TutorSectionState createState() => _TutorSectionState();
}

class _TutorSectionState extends State<TutorSection> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widget.width = mediaQueryData.size.width;
    widget.height = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Tutor",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Select an option",
                  style: GoogleFonts.sarala(fontSize: 25, color: kGreyerish),
                ),
                SizedBox(
                  height: 20,
                ),
                TutorSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked answer");
                    Navigator.pushNamed(context, AnswerScreenTutor.id);
                  },
                  imgPath: "images/Tutor_Section/Answer_Logo.png",
                  title: "Answer",
                  description:
                      "Answer questions that are posted by Students.",
                ),
                SizedBox(
                  height: 20,
                ),
                TutorSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked Respond");
                    Navigator.pushNamed(context, RespondScreenTutor.id);
                  },
                  imgPath: "images/Tutor_Section/Respond_Logo.png",
                  title: "Respond",
                  description:
                      "Respond to request send by Students for creating a session with you!!",
                ),
                SizedBox(
                  height: 20,
                ),
                TutorSectionWidget(
                  widget: widget,
                  onClick: () {
                    Navigator.pushNamed(context, CreateMaterialsScreen.id);
                  },
                  imgPath: "images/Tutor_Section/Subject_Logo.png",
                  title: "Create Materials",
                  description:
                      "Share Materials & Create Quizzes with Students that can be bookmarked & taken.",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorSectionWidget extends StatelessWidget {
  TutorSectionWidget(
      {@required this.widget,
      @required this.onClick,
      @required this.imgPath,
      @required this.title,
      @required this.description});

  final TutorSection widget;
  final Function onClick;
  final String imgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Theme.of(context).backgroundColor,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: ListTile(

              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                         imgPath,
                           width: 50,
                        ),
                ],
              ),
              title:   Text(
                    title,
                        style: GoogleFonts.sarala(fontSize: 25, color: Theme.of(context).primaryColor),
                    ),
              subtitle: Text(
                       description,
                        style: GoogleFonts.sarala(fontSize: 14, color: Theme.of(context).primaryColor),
                       ),
              trailing: Container(
                height: double.infinity,
                child: Icon(Icons.arrow_forward_ios_outlined, color: Theme.of(context).iconTheme.color,),
              ),
            ),
          ),
        ),
      ),


      // Container(
      //   width: widget.width * 0.8,
      //   decoration: BoxDecoration(
      //     color: kWhiteish,
      //     borderRadius: BorderRadius.circular(10),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.2),
      //         spreadRadius: 1,
      //         blurRadius: 15,
      //         offset: Offset(0, 6), // changes position of shadow
      //       ),
      //     ],
      //   ),
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         Image.asset(
      //           imgPath,
      //           width: 50,
      //         ),
      //         SizedBox(
      //           width: 10,
      //         ),
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               title,
      //               style: GoogleFonts.sarala(fontSize: 25, color: kBlackish),
      //             ),
      //             Text(
      //               description,
      //               style: GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
      //             ),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
