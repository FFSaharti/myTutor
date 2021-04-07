import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/components/session_card_widget.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class SessionStream extends StatelessWidget {
  // "check expire" to update the old sessions. "expiredSessionView" to disable send function and textfeld
  final String status;
  final int type;
  final bool isStudent;
  final bool checkexpire;
  final bool expiredSessionView;

  const SessionStream(
      {@required this.status,
      this.type,
      this.isStudent,
      this.checkexpire,
      @required this.expiredSessionView});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseAPI.fetchSessionData(type, checkexpire, status),
        builder: (context, snapshot) {
          int from = 0;
          int to = 400;
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Column(
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.15,
                ),
                Center(
                  child: Text(
                    "its quite empty in here",
                    style: GoogleFonts.sen(
                        color: Theme.of(context).buttonColor.withOpacity(0.6),
                        // Theme.of(context).primaryColor,
                        fontSize: 21),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          } else {
            // snap shot have some data.
            return Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myDoc = snapshot.data.docs[index];
                    return Column(
                      children: [
                        Villain(
                          villainAnimation: VillainAnimation.fromBottom(
                            from: Duration(milliseconds: from),
                            to: Duration(milliseconds: to),
                          ),
                          child: FutureBuilder(
                            future: DatabaseAPI.getUserbyid(
                                isStudent == true
                                    ? myDoc.data()["tutor"]
                                    : myDoc.data()["student"],
                                isStudent == true ? 0 : 1),
                            builder: (context, AsyncSnapshot snap) {
                              if (snap.hasData) {
                                if (status == myDoc.data()["status"]) {
                                  // check if the user message at this index does not have a user name;
                                  if (isStudent) {
                                    Timestamp dateHolder = myDoc.data()["date"];
                                    Tutor tempTutor = Tutor(
                                        snap.data["name"],
                                        snap.data["email"],
                                        "",
                                        snap.data["aboutMe"],
                                        myDoc.data()["tutor"],
                                        [],
                                        snap.data["profileImg"]);
                                    List.from(snap.data["experiences"])
                                        .forEach((element) {
                                      tempTutor.addExperience(element);
                                    });
                                    return Container(
                                      key: const ValueKey("first_session"),
                                      child: SessionCardWidget(
                                        isStudent: isStudent,
                                        height: ScreenSize.height,
                                        session: Session(
                                            myDoc.data()["title"],
                                            tempTutor,
                                            SessionManager.loggedInStudent,
                                            myDoc.id,
                                            myDoc.data()["time"],
                                            dateHolder.toDate(),
                                            myDoc.data()["description"],
                                            myDoc.data()["status"],
                                            myDoc.data()["subject"]),
                                      ),
                                    );
                                  } else {
                                    Timestamp dateHolder = myDoc.data()["date"];
                                    return SessionCardWidget(
                                      isStudent: isStudent,
                                      height: ScreenSize.height,
                                      session: Session(
                                          myDoc.data()["title"],
                                          SessionManager.loggedInTutor,
                                          Student(
                                              snap.data["name"],
                                              snap.data["email"],
                                              "",
                                              snap.data["aboutMe"],
                                              myDoc.data()["student"],
                                              [],
                                              snap.data["profileImg"]),
                                          myDoc.id,
                                          myDoc.data()["time"],
                                          dateHolder.toDate(),
                                          myDoc.data()["description"],
                                          myDoc.data()["status"],
                                          myDoc.data()["subject"]),
                                    );
                                  }
                                }

                                // add the widget to list of widget to use it for search later.
                              }
                              from += 100;
                              to += 100;
                              return SizedBox();
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
        });
  }
}
