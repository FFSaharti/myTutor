import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/session_card_widget.dart';
import 'package:mytutor/screens/messages_screen.dart';
import 'package:mytutor/screens/respond_screen_tutor.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/session_manager.dart';

class HomepageScreenTutor extends StatefulWidget {
  static String id = 'homepage_screen_tutor';

  @override
  _HomepageScreenTutorState createState() => _HomepageScreenTutorState();
}

class _HomepageScreenTutorState extends State<HomepageScreenTutor> {
  List<Widget> widgets = <Widget>[
    HomePageTutor(),
    TutorSection(),
    Text("3"),
    ProfileTutor(),
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

class HomePageTutor extends StatefulWidget {
  @override
  _HomePageTutorState createState() => _HomePageTutorState();
}

class _HomePageTutorState extends State<HomePageTutor> {
  double height;
  // Tutor tempTutor = DatabaseAPI.tempUser;
  double width;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.10,
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
            height: height * 0.04,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  "    Upcoming Sessions",
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

          StreamBuilder<QuerySnapshot>(
            stream: DatabaseAPI.fetchSessionData(1),
            builder: (context, snapshot) {
              // List to fill up with all the session the user has.
              List<SessionCardWidget> UserSessions = [];
              if (snapshot.hasData) {
              print(snapshot.data.size.toString());
                List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
                for (var session in Sessions) {
                  String SessionStatus = session.data()["status"];
                  if(SessionStatus == "pending"){
                    print(SessionStatus);
                    continue;
                  }
                  final Sessiontutor = session.data()["tutor"];
                  final Sessionstudentid = session.data()["student"];
                  final Sessiontitle = session.data()["title"];
                  final Sessiontime = session.data()["time"];
                  final SessionDate = session.data()["date"];
                  UserSessions.add(SessionCardWidget(
                    isStudent: false,
                    height: height,
                    session: Session(
                        Sessiontitle, SessionManager.loggedInTutor.userId, Sessionstudentid, session.id,Sessiontime,SessionDate),
                  ));
                }
              }
              return Expanded(
                child: ListView(
                  reverse: true,
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: UserSessions,
                ),
              );
            },
          ),
          SizedBox(
            height: height * 0.05,
          ),
          //SessionWidget(height: height),
        ],
      ),
    );
  }
}


class ProfileTutor extends StatefulWidget {
  @override
  _ProfileTutorState createState() => _ProfileTutorState();
}

class _ProfileTutorState extends State<ProfileTutor> {
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: width * 0.91,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white70),
                    child: Icon(
                      Icons.person,
                      size: 130,
                    ),
                  ),
                ),
                Text(
                  DatabaseAPI.tempTutor.name,
                  style: kTitleStyle.copyWith(color: kBlackish, fontSize: 30),
                ),
                Center(
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kColorScheme[3],
                    ),
                    child: Text(
                      "Tutor",
                      textAlign: TextAlign.center,
                      style: kTitleStyle.copyWith(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileInfoWidget("Sessions", 69.toString()),
                    SizedBox(
                      width: 5,
                    ),
                    ProfileInfoWidget("Rating", 4.5.toString()),
                    SizedBox(
                      width: 5,
                    ),
                    ProfileInfoWidget("Reviews", 69.toString()),
                  ],
                ),
                Divider(
                  color: kGreyish,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "About Me",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        //TODO: Create & Fetch About me from a tutor.
                        "I’m a guy who loves programming and would love to share my knowledge with any fellow students, interested in almost all programming languages.",
                        style: TextStyle(fontSize: 16.5, color: kGreyerish),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: kGreyish,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Experiences",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      // child: Text(SessionManager.loggedInTutor.experiences[0]
                      //     .toString()),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: getExperiences(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getExperiences() {
    List<Widget> widgets = [];
    List<Subject> experiences = [];

    for (int i = 0; i < SessionManager.loggedInTutor.experiences.length; i++) {
      for (int j = 0; j < subjects.length; j++) {
        if (SessionManager.loggedInTutor.experiences[i] == subjects[j].id) {
          experiences.add(subjects[j]);
        }
      }
    }

    for (int i = 0; i < experiences.length; i++) {
      widgets.add(SubjectWidget(experiences[i]));
      widgets.add(SizedBox(width: 9));
    }

    return widgets;
  }
}

class ProfileInfoWidget extends StatelessWidget {
  ProfileInfoWidget(this.infoTitle, this.infoNum);

  String infoTitle = "";
  String infoNum = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffF5F5F5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                infoTitle,
                style: TextStyle(color: kGreyerish, fontSize: 18),
              ),
              Text(
                infoNum,
                style: TextStyle(color: kBlackish, fontSize: 18),
              ),
            ]),
      ),
    );
  }
}

class SubjectWidget extends StatefulWidget {
  Subject subject;

  SubjectWidget(this.subject);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          widget.subject.path,
          width: 40,
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
                   // Navigator.pushNamed(context, AskScreenStudent.id);
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
                    print("clicked MATERIALS");
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
