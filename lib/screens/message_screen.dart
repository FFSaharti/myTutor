
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {

  Stream<QuerySnapshot> stream = SessionManager.loggedInTutor.userId == ""
      ? DatabaseAPI.getSessionForMessageScreen(0)
      : DatabaseAPI.getSessionForMessageScreen(1);

  List<MessageListTile> holder = [];
  bool search = false;
  List<Session> searchedChat = [];
  List<MessageListTile> Searchtest = [];
  TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();
  }

  _filterSession(String title) {

    if (this.mounted) {
      setState(() {
        Searchtest = holder
            .where((element) => element.nameHelper.toLowerCase().contains(title.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    search = true;
                    Searchtest = holder;
                    _filterSession(value);
                  });

                  if (searchController.text.isEmpty) {
                    //update stream

                    setState(() {
                      search = false;
                      Searchtest = [];
                    });
                  }

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
              search  ? Expanded(
                      child: ListView(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                        children: Searchtest,
                      ),
                    ) :
              StreamBuilder(
                //TODO: need to create signout function and clear the objects in SessionManager class.
                stream: stream,
                builder: (context, snapshot) {
                  // List to fill up with all the session the user has.
                  List<MessageListTile> userMessages = [];
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> Sessions =
                        snapshot.data.docs;
                    for (var session in Sessions) {
                      String SessionStatus = session.data()["status"];
                      if (SessionStatus.toLowerCase() == "active") {
                        final Sessiontutor = session.data()["tutor"];
                        final Sessionstudentid =
                        session.data()["student"];
                        final Sessiontitle = session.data()["title"];
                        final Sessiontime = session.data()["time"];
                        final SessionDate = session.data()["date"];
                        final SessionDesc = session.data()["description"];
                        final timeOfLastMessage =
                        session.data()["timeOfLastMessage"];
                        final SessionSubject = session.data()["subject"];
                        // convert the date we got from firebase into timestamp. to change it later to datetime.
                        Timestamp stampOftheSessiondate = SessionDate;
                        Timestamp StampOfTheLastMessageTime =
                            timeOfLastMessage;
                        Session tempSession = Session(
                            Sessiontitle,
                            Sessiontutor,
                            Sessionstudentid,
                            session.id,
                            Sessiontime,
                            stampOftheSessiondate.toDate(),
                            SessionDesc,
                            SessionStatus,
                            SessionSubject);
                        tempSession.lastMessage =
                        session.data()["lastMessage"];
                        tempSession.timeOfLastMessage =
                            calTime(StampOfTheLastMessageTime);

                        userMessages.add(MessageListTile(
                          session: tempSession,
                        ));
                      }
                    }
                    holder = userMessages;
                  }
                  return Expanded(
                    child: ListView(
                      reverse: false,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      children: userMessages,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
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

class MessageListTile extends StatefulWidget {
  final Session session;
  String nameHelper = "";
 MessageListTile({Key key, this.session}) : super(key: key);

  @override
  _MessageListTileState createState() => _MessageListTileState();
}

class _MessageListTileState extends State<MessageListTile> {
  //String nameHelper = "";
  String lastMsg = "";
  String time = "";
  String avtar = "";
  bool finishedLoadingname = false;
  bool finishedLoadingLastMsg = false;

  void dispose() {
    super.dispose();
  }

  void initState() {
    //determine if the user is student or tutor
    if (this.mounted) {
      if (SessionManager.loggedInTutor.userId == "") {
        // the user is Student , we need to get the tutor name.
        DatabaseAPI.getUserbyid(widget.session.tutor, 0).then((value) => {
              if (this.mounted)
                {
                  setState(() {
                    widget.nameHelper = value.data()["name"];
                    finishedLoadingname = true;
                    createAvtar();
                  }),
                }
            });
      } else {
        // get the tutor name
        if (this.mounted) {
          DatabaseAPI.getUserbyid(widget.session.student, 1).then((value) => {
                if (this.mounted)
                  {
                    setState(() {
                      widget.nameHelper = value.data()["name"];
                      finishedLoadingname = true;
                      createAvtar();
                    }),
                  }
              });
        }
      }
    }

    super.initState();
  }


  void createAvtar() {
    List<String> nameSplit = widget.nameHelper.split(" ");
    if (nameSplit.isNotEmpty) {
      if (nameSplit.length > 1) {
        // two case name
        if (this.mounted) {
          setState(() {
            avtar = nameSplit.elementAt(0)[0] + nameSplit.elementAt(1)[0];
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            avtar = nameSplit.elementAt(0)[0];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
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
            ? Text(widget.nameHelper,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            : Text("loding.."),
        subtitle: Text(
          widget.session.lastMessage,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          widget.session.timeOfLastMessage,
          style: TextStyle(color: Colors.grey, fontSize: 17),
        ),
      ),
    );
  }
}
