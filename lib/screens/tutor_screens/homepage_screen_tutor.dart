import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/session_stream_widget.dart';
import 'package:mytutor/screens/tutor_screens/answer_screen_tutor.dart';
import 'package:mytutor/screens/tutor_screens/create_materials_screen.dart';
import 'package:mytutor/screens/tutor_screens/respond_screen_tutor.dart';
import 'package:mytutor/screens/tutor_screens/tutor_Profile.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
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

  void changeindex(int index) {
    setState(() {
      _navindex = index;
      print(_navindex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chalkboardTeacher), label: "student"),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: "messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
        currentIndex: _navindex,
        onTap: changeindex,
        selectedItemColor: kColorScheme[3],
      ),
      body: widgets.elementAt(_navindex),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
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
                            color: Colors.black)),
                  ),
                  TextSpan(
                    text: SessionManager.loggedInTutor.name,
                    style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ]),
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
                          color: kGreyish)),
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
                      "Answer questions that are posted by \nStudents.",
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
                      "Respond to request send by \nStudents for creating a session \nwith you!!",
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
                      "Share Materials & Create \nQuizzes with Students that can \nbe bookmarked & taken.",
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
      child: Container(
        width: widget.width * 0.8,
        decoration: BoxDecoration(
          color: kWhiteish,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                imgPath,
                width: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.sarala(fontSize: 25, color: kBlackish),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
