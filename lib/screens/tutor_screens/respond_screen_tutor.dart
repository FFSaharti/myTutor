import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class RespondScreenTutor extends StatelessWidget {
  static String id = 'respond_screen_tutor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Respond",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: DatabaseAPI.fetchSessionData(1),
              builder: (context, snapshot) {
                // List to fill up with all the session the user has.
                List<RespondSessionWidget> UserSessions = [];
                if (snapshot.hasData) {
                  List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
                  for (var session in Sessions) {
                    String SessionStatus = session.data()["status"];
                    if (SessionStatus.toLowerCase() == "active" ||
                        SessionStatus.toLowerCase() == "decline") {
                      continue;
                    }
                    // final Sessiontutor = session.data()["tutor"];
                    final Sessionstudentid = session.data()["student"];
                    final Sessiontitle = session.data()["title"];
                    final Sessiontime = session.data()["time"];
                    final SessionDate = session.data()["date"];
                    UserSessions.add(RespondSessionWidget(
                      height: ScreenSize.height,
                      session: Session(
                          Sessiontitle,
                          SessionManager.loggedInTutor.userId,
                          Sessionstudentid,
                          session.id,
                          Sessiontime,
                          SessionDate),
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

      // RespondSessionWidget(height: height),
    );
  }
}

class RespondSessionWidget extends StatefulWidget {
  const RespondSessionWidget({
    Key key,
    @required this.height,
    this.session,
  }) : super(key: key);

  final double height;
  final Session session;

  @override
  _RespondSessionWidgetState createState() => _RespondSessionWidgetState();
}

class _RespondSessionWidgetState extends State<RespondSessionWidget> {
  String student_name = "";
  bool finishLoad = false;

  @override
  void initState() {
    DatabaseAPI.getUserbyid(widget.session.student, 1).then((data) {
      setState(() {
        student_name = data.data()["name"];
        finishLoad = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("hello");
    return Column(
      children: [
        SizedBox(
          height: widget.height * 0.010,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              //TODO : ModelBottomSheet
            },
            child: Container(
              height: widget.height * 0.24,
              decoration: new BoxDecoration(
                color: Color(0xFFefefef),
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(11.0),
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
                          padding:
                              const EdgeInsets.only(left: 11.0, right: 11.0),
                          child: Text(
                            widget.session.title,
                            style: GoogleFonts.sarabun(
                              textStyle: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                          decoration: new BoxDecoration(
                            color: kColorScheme[2],
                            borderRadius: new BorderRadius.circular(50.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 11.0, right: 11.0),
                            child: Text(
                              widget.session.date +
                                  " at " +
                                  widget.session.time,
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 11.0, right: 11.0),
                          child: SizedBox(
                            width: 220,
                            child: Text(
                              finishLoad ? student_name : "loading..",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: widget.height * 0.04,
                                child: RaisedButton(
                                  onPressed: () {
                                    DatabaseAPI.changeSessionsStatus(
                                            "accept", widget.session.session_id)
                                        .then((value) => print(value));
                                  },
                                  child: Text(
                                    "Accept",
                                    style: GoogleFonts.sarabun(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                  color: kColorScheme[2],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: widget.height * 0.04,
                                child: RaisedButton(
                                  onPressed: () {
                                    DatabaseAPI.changeSessionsStatus("decline",
                                            widget.session.session_id)
                                        .then((value) => print(value));
                                  },
                                  child: Text(
                                    "Decline",
                                    style: GoogleFonts.sarabun(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ),
                                  color: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
