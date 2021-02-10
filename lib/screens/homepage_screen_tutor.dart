import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/screens/messages_screen.dart';
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
    Text("2"),
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
                    text: SessionManager.loggedInUser.name,
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

              ],
            ),
          ),

          StreamBuilder<QuerySnapshot>(
            stream: DatabaseAPI.fetchSessionData(1),
            builder: (context, snapshot) {
              // List to fill up with all the session the user has.
              List<SessionWidget> UserSessions = [];
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
                for (var session in Sessions) {
                  final Sessiontutor = session.data()["tutor"];
                  final Sessionstudent = session.data()["student"];
                  final Sessiontitle = session.data()["title"];

                  final singlesession = SessionWidget(
                    height: height,
                    session: Session(
                        Sessiontitle,
                        DatabaseAPI.tempUser.userId,
                        Sessionstudent,
                        session.id),
                  );
                  UserSessions.add(singlesession);
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

class SessionWidget extends StatelessWidget {
  const SessionWidget({
    Key key,
    @required this.height,
    this.session,
  }) : super(key: key);
  final Session session;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => messagesScreen(
                  currentsession: session,
                ),
              ));
        },
        child: Container(
          height: height * 0.17,
          decoration: new BoxDecoration(
            color: Color(0xFFefefef),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(11.0),
            // boxShadow: <BoxShadow>[
            //   new BoxShadow(
            //     color: Colors.black26,
            //     blurRadius: 10.0,
            //     offset: new Offset(0.0, 10.0),
            //   ),
            // ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/Sub-Icons/Java.png",
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                      child: Text(
                        session.title,
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        color: kColorScheme[2],
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                        child: Text(
                          "Tomorrow at 4:50pm",
                          style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                      child: Text(
                        //TODO: adjuest the over flow problem with long names
                        "abdulrhman alahmadi",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
