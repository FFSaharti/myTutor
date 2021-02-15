import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/components/session_card_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

import 'file:///C:/Users/faisa/Desktop/Developer/AndroidStudioProjects/mytutor/lib/screens/student_screens/ask_screen_student.dart';
import 'file:///C:/Users/faisa/Desktop/Developer/AndroidStudioProjects/mytutor/lib/screens/student_screens/request_tutor_screen.dart';

class HomepageScreenStudent extends StatefulWidget {
  static String id = 'homepage_screen_student';

  @override
  _HomepageScreenStudentState createState() => _HomepageScreenStudentState();
}

class _HomepageScreenStudentState extends State<HomepageScreenStudent> {
  List<Widget> widgets = <Widget>[
    HomePageStudent(),
    StudentSection(),
  ];
  double width;
  double height;
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

class HomePageStudent extends StatefulWidget {
  @override
  _HomePageStudentState createState() => _HomePageStudentState();
}

class _HomePageStudentState extends State<HomePageStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Homepage",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Welcome,\nStudent ",
                      style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                    ),
                    TextSpan(
                      text: DatabaseAPI.tempStudent.name,
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
              child: Text(
                "    Upcoming Sessions",
                style: GoogleFonts.sarabun(
                    textStyle: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.normal,
                        color: kGreyish)),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: DatabaseAPI.fetchSessionData(0),
              builder: (context, snapshot) {
                // List to fill up with all the session the user has.
                List<SessionCardWidget> UserSessions = [];
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
                  for (var session in Sessions) {
                    String SessionStatus = session.data()["status"];
                    if (SessionStatus == "pending") {
                      print(SessionStatus);
                      continue;
                    }
                    final Sessiontutor = session.data()["tutor"];
                    final Sessionstudentid = session.data()["student"];
                    final Sessiontitle = session.data()["title"];
                    final Sessiontime = session.data()["time"];
                    final SessionDate = session.data()["date"];
                    UserSessions.add(SessionCardWidget(
                      isStudent: true,
                      height: ScreenSize.height,
                      session: Session(
                        Sessiontitle,
                        Sessiontutor,
                        SessionManager.loggedInUser.userId,
                        session.id,
                        Sessiontime,
                        SessionDate,
                      ),
                    ));
                  }
                }
                return Expanded(
                  child: ListView(
                    reverse: false,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    children: UserSessions,
                  ),
                );
              },
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

class StudentSection extends StatefulWidget {
  double height;
  double width;

  @override
  _StudentSectionState createState() => _StudentSectionState();
}

class _StudentSectionState extends State<StudentSection> {
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
            "Student",
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
                StudentSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked ASK");
                    Navigator.pushNamed(context, AskScreenStudent.id);
                  },
                  imgPath: "images/Student_Section/Ask_Logo.png",
                  title: "Ask",
                  description:
                      "Post questions that can be viewed and \nanswered by tutors!",
                ),
                SizedBox(
                  height: 20,
                ),
                StudentSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked REQUEST");
                    Navigator.pushNamed(context, RequestTutorScreen.id);
                  },
                  imgPath: "images/Student_Section/Request_Logo.png",
                  title: "Request",
                  description:
                      "Search for Tutors with a variety of \nfilters and request them!",
                ),
                SizedBox(
                  height: 20,
                ),
                StudentSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked MATERIALS");
                  },
                  imgPath: "images/Student_Section/Materials_Logo.png",
                  title: "Materials",
                  description:
                      "Search for Materials posted by \nother Tutors and bookmark them",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentSectionWidget extends StatelessWidget {
  StudentSectionWidget(
      {@required this.widget,
      @required this.onClick,
      @required this.imgPath,
      @required this.title,
      @required this.description});

  final StudentSection widget;
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
