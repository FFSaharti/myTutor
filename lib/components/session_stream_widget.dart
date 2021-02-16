import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/components/session_card_widget.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

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
      stream: DatabaseAPI.fetchSessionData(type, checkexpire),
      builder: (context, snapshot) {
        // List to fill up with all the session the user has.
        List<SessionCardWidget> UserSessions = [];
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
          for (var session in Sessions) {
            String SessionStatus = session.data()["status"];

            if (SessionStatus.toLowerCase() == status.toLowerCase()) {
              final Sessiontutor = session.data()["tutor"];
              final Sessionstudentid = session.data()["student"];
              final Sessiontitle = session.data()["title"];
              final Sessiontime = session.data()["time"];
              final SessionDate = session.data()["date"];
              final SessionDesc = session.data()["description"];

              // convert the date we got from firebase into timestamp. to change it later to datetime.
              Timestamp stamp = SessionDate;
              print(Sessiontitle);
              UserSessions.add(SessionCardWidget(
                isStudent: isStudent,
                height: ScreenSize.height,
                session: Session(
                    Sessiontitle,
                    Sessiontutor,
                    Sessionstudentid,
                    session.id,
                    Sessiontime,
                    stamp.toDate(),
                    SessionDesc,
                    SessionStatus),
              ));
            }
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            children: UserSessions,
          ),
        );
      },
    );
  }
}
