import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    // getSelectedSubjects(selectedInterests);
                  });
                },
                style: TextStyle(
                  color: kBlackish,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  filled: true,
                  hintText: 'Search by the name of the session..',
                  prefixIcon: Icon(Icons.search, color: kColorScheme[2]),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.009,
              ),
              Divider(),
              //MessageListTile(),

              StreamBuilder(
                //TODO: need to create signout function and clear the objects in SessionManager class.
                stream: SessionManager.loggedInTutor.userId == "" ? DatabaseAPI.fetchSessionData(0, false) : DatabaseAPI.fetchSessionData(1, false),
                builder: (context, snapshot) {
                  // List to fill up with all the session the user has.
                  List<MessageListTile> userMessages = [];
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
                    for (var session in Sessions) {
                      String SessionStatus = session.data()["status"];
                      if (SessionStatus.toLowerCase() == "active") {
                        final Sessiontutor = session.data()["tutor"];
                        final Sessionstudentid = session.data()["student"];
                        final Sessiontitle = session.data()["title"];
                        final Sessiontime = session.data()["time"];
                        final SessionDate = session.data()["date"];
                        final SessionDesc = session.data()["description"];

                        // convert the date we got from firebase into timestamp. to change it later to datetime.
                        Timestamp stamp = SessionDate;

                        userMessages.add(MessageListTile(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                      children: userMessages,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageListTile extends StatefulWidget {
  final Session session;

  const MessageListTile({Key key, this.session}) : super(key: key);

  @override
  _MessageListTileState createState() => _MessageListTileState();
}

class _MessageListTileState extends State<MessageListTile> {
  String nameHelper = "";
  String lastMsg = "";
  String time = "";
  String avtar = "";
  bool finishedLoadingname = false;
  bool finishedLoadingLastMsg = false;

  void initState() {
    // get the last message
    getLastMsg();
    // determine if the user is student or tutor
    if (SessionManager.loggedInTutor.userId == "") {
      // the user is Student , we need to get the tutor name.
      DatabaseAPI.getUserbyid(widget.session.tutor, 0).then(
        (value) => setState(() {
          nameHelper = value.data()["name"];
          finishedLoadingname = true;
          createAvtar();
        }),
      );
    } else {
      // get the tutor name
      DatabaseAPI.getUserbyid(widget.session.student, 1).then(
        (value) => setState(() {
          nameHelper = value.data()["name"];
          finishedLoadingname = true;
          createAvtar();
        }),
      );
    }

    super.initState();
  }

  void getLastMsg() {

    DatabaseAPI.getLastMessage(widget.session.session_id).then(
      (value) => setState(() {
        if (value.docs.isNotEmpty) {

          lastMsg = value.docs.single.data()["text"];
          time = calTime(value.docs.single.data()["time"]);
          finishedLoadingLastMsg = true;
        } else {
          lastMsg = "the lasg msg will display here";
          time = "none";
          finishedLoadingLastMsg = true;
        }
      }),
    );
  }

  void createAvtar(){

    List<String> nameSplit = nameHelper.split(" ");

    if( nameSplit.isNotEmpty){
      if(nameSplit.length > 1){

        // two case name
        setState(() {
          avtar = nameSplit.elementAt(0)[0]+nameSplit.elementAt(1)[0];

        });

    }
      else{
        setState(() {
          avtar = nameSplit.elementAt(0)[0];

        });
      }
    }

  }
  //TODO: redundant code can be improve
  String calTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    String time;
    int num = calculateDifference(dateTime);

    var dateUtc = dateTime.toUtc();
    var strToDateTime = DateTime.parse(dateUtc.toString());
    final convertLocal = strToDateTime.toLocal();
    if (num == 0) {
      var newFormat = DateFormat("hh:mm");
      time = newFormat.format(convertLocal);
    } else {
      var newFormat = DateFormat("yy-MM");
      time = newFormat.format(convertLocal);
    }

    return time;
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => messagesScreen(
                currentsession: widget.session,
              ),
            ));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kColorScheme[1],
          child: Text(
            avtar.toUpperCase(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        title: finishedLoadingname
            ? Text(nameHelper,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            : Text("loading...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        subtitle: finishedLoadingLastMsg
            ? Text(
                lastMsg,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text("loading...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        trailing: finishedLoadingLastMsg
            ? Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 17),
              )
            : Text(
                "loading...",
              ),
      ),
    );
  }
}
