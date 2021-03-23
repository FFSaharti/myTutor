import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/dataHelper.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

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
  List<MessageListTile> Searchtest = [];
  List<MessageListTile> userMessages = [];
  TextEditingController searchController = TextEditingController();
  int from = 0;
  int to = 200;
  bool isStudent = false;

  void initState() {
    super.initState();
  }

  _filterSession(String title) {
    if (this.mounted) {
      setState(() {
        if (isStudent) {
          Searchtest = userMessages
              .where((element) => element.session.tutor.name
                  .toLowerCase()
                  .contains(title.toLowerCase()))
              .toList();
        } else {
          Searchtest = userMessages
              .where((element) => element.session.student.name
                  .toLowerCase()
                  .contains(title.toLowerCase()))
              .toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    isStudent = SessionManager.loggedInTutor.userId == "" ? true : false;
    FocusNode n = new FocusNode();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Villain(
                villainAnimation: VillainAnimation.fromRight(
                  from: Duration(milliseconds: 100),
                  to: Duration(milliseconds: 450),
                ),
                child: TextField(
                  focusNode: n,
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      search = true;
                      Searchtest = userMessages;
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
                  style: TextStyle(color: Theme.of(context).accentColor),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor:
                        Theme.of(context).primaryColorLight.withOpacity(0.6),
                    hintText: 'Search by Session Name',
                    hintStyle: TextStyle(color: Theme.of(context).accentColor),
                    prefixIcon: Icon(Icons.search,
                        color: Theme.of(context).accentColor),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.009,
              ),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              search
                  ? Expanded(
                      child: disableBlueOverflow(
                        context,
                        ListView(
                          children: Searchtest,
                        ),
                      ),
                    )
                  : StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        // List to fill up with all the session the user has.
                        if (snapshot.data == null)
                          return Center(child: CircularProgressIndicator());
                        List<Session> testSession = [];
                        if (snapshot.hasData) {
                          userMessages = [];
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
                              Session tempSession = isStudent == true
                                  ? Session(
                                      Sessiontitle,
                                      Tutor("name", "email", "pass", "aboutMe",
                                          Sessiontutor, [], "Profileimg"),
                                      SessionManager.loggedInStudent,
                                      session.id,
                                      Sessiontime,
                                      stampOftheSessiondate.toDate(),
                                      SessionDesc,
                                      SessionStatus,
                                      SessionSubject)
                                  : Session(
                                      Sessiontitle,
                                      SessionManager.loggedInTutor,
                                      Student(
                                          "name",
                                          "email",
                                          "pass",
                                          "aboutMe",
                                          Sessionstudentid,
                                          [],
                                          "Profileimg"),
                                      session.id,
                                      Sessiontime,
                                      stampOftheSessiondate.toDate(),
                                      SessionDesc,
                                      SessionStatus,
                                      SessionSubject);
                              tempSession.lastMessage =
                                  session.data()["lastMessage"];
                              tempSession.timeOfLastMessage =
                                  DateHelper.calTime(StampOfTheLastMessageTime);
                              testSession.add(tempSession);
                              userMessages.add(MessageListTile(
                                session: tempSession,
                              ));
                            }
                          }
                        }
                        return userMessages.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: ScreenSize.height * 0.30,
                                  ),
                                  Text(
                                    "No Available/Upcoming Sessions",
                                    style: GoogleFonts.sen(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 21),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : Expanded(
                                child: disableBlueOverflow(
                                  context,
                                  ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot myDoc =
                                          snapshot.data.docs[index];
                                      return Column(
                                        children: [
                                          Villain(
                                            villainAnimation:
                                                VillainAnimation.fromBottom(
                                              from:
                                                  Duration(milliseconds: from),
                                              to: Duration(milliseconds: to),
                                            ),
                                            child: FutureBuilder(
                                              future: DatabaseAPI
                                                  .getStreamOfUserbyId(
                                                      SessionManager
                                                                  .loggedInTutor
                                                                  .userId ==
                                                              ""
                                                          ? myDoc
                                                              .data()["tutor"]
                                                          : myDoc.data()[
                                                              "student"],
                                                      SessionManager
                                                                  .loggedInTutor
                                                                  .userId ==
                                                              ""
                                                          ? 0
                                                          : 1),
                                              builder: (context,
                                                  AsyncSnapshot snap) {
                                                if (snap.hasData) {
                                                  // check if the user message at this index does not have a user name;
                                                  fetchWidgetIntoList(
                                                      index, testSession, snap);
                                                  holder = userMessages;
                                                  // add the widget to list of widget to use it for search later.
                                                  return Column(
                                                    children: [
                                                      MessageListTile(
                                                          session: testSession
                                                              .elementAt(index),
                                                          avatar: createAvatar(
                                                              snap.data[
                                                                  "name"]),
                                                          callBackFunction: () {
                                                            //TODO: check for errors occur when calling back without searching.
                                                          }),
                                                      Divider(),
                                                    ],
                                                  );
                                                }
                                                from += 100;
                                                to += 100;
                                                return Text("");
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
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

  void fetchWidgetIntoList(
      int index, List<Session> testSession, AsyncSnapshot snap) {
    if (userMessages.elementAt(index).session.student.name == "name") {
      // means the tutor data has not been inserted into it so we need to do it right now
      userMessages.removeAt(index);
      Session tempSession = testSession.elementAt(index);
      Student newStu = Student(
          snap.data["name"],
          snap.data["email"],
          "pass",
          snap.data["aboutMe"],
          tempSession.student.userId,
          [],
          snap.data["profileImg"]);

      tempSession.student = newStu;
      if (this.mounted) {
        userMessages.insert(
            index,
            MessageListTile(
              session: tempSession,
              avatar: createAvatar(
                snap.data["name"],
              ),
              callBackFunction: () {
                setState(() {
                  searchController.clear();

                  Searchtest = [];
                  search = false;
                });
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
            ));
      }
    } else if (userMessages.elementAt(index).session.tutor.name == "name") {
      // means the tutor data has not been inserted into it the tutor so we need to do it right now
      userMessages.removeAt(index);
      Session tempSession = testSession.elementAt(index);
      Tutor newTutor = Tutor(
          snap.data["name"],
          snap.data["email"],
          "pass",
          snap.data["aboutMe"],
          tempSession.tutor.userId,
          [],
          snap.data["profileImg"]);
      List.from(snap.data["experiences"]).forEach((element) {
        newTutor.addExperience(element);
      });
      tempSession.tutor = newTutor;
      if (this.mounted) {
        userMessages.insert(
            index,
            MessageListTile(
              session: tempSession,
              avatar: createAvatar(
                snap.data["name"],
              ),
              callBackFunction: () {
                setState(() {
                  searchController.clear();

                  Searchtest = [];
                  search = false;
                });
                WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
              },
            ));
      }
    }
  }

  String createAvatar(String name) {
    List<String> nameSplit = name.split(" ");
    if (nameSplit.length > 1) {
      // two case name
      return nameSplit.elementAt(0)[0] + nameSplit.elementAt(1)[0];
    } else {
      return nameSplit.elementAt(0)[0];
    }
  }
}

class MessageListTile extends StatefulWidget {
  final Session session;
  final String avatar;
  final Function callBackFunction;

  MessageListTile({
    this.session,
    this.avatar,
    this.callBackFunction,
  });

  @override
  _MessageListTileState createState() => _MessageListTileState();
}

class _MessageListTileState extends State<MessageListTile> {
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
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
            )).then((value) => {
              widget.callBackFunction(),
            });
      },
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: kColorScheme[1],
            child: Text(
              widget.avatar.toUpperCase(),
              style: GoogleFonts.sen(
                  color: Theme.of(context).buttonColor,
                  fontWeight: FontWeight.bold),
            )),
        title: Text(
            SessionManager.loggedInTutor.userId == ""
                ? widget.session.tutor.name
                : widget.session.student.name,
            style: GoogleFonts.sen(
                color: Theme.of(context).buttonColor,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        subtitle: Text(
          widget.session.lastMessage.contains('image included type to load')
              ? 'Image 📷'
              : widget.session.lastMessage,
          style: GoogleFonts.sen(
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.normal,
              fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          widget.session.timeOfLastMessage,
          style: GoogleFonts.sen(
              color: Theme.of(context).buttonColor, fontSize: 17),
        ),
      ),
    );
  }
}
