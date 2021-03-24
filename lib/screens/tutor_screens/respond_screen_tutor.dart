import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class RespondScreenTutor extends StatefulWidget {
  static String id = 'respond_screen_tutor';

  @override
  _RespondScreenTutorState createState() => _RespondScreenTutorState();
}

class _RespondScreenTutorState extends State<RespondScreenTutor> {
  bool empty = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context, Theme.of(context).accentColor, "Respond"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: DatabaseAPI.fetchSessionData(1, true, "pending"),
                builder: (context, snapshot) {
                  int from = 0;
                  int to = 400;
                  int size = snapshot.data != null ? snapshot.data.size : 0;
                  if (size > 0) {
                    return Expanded(
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
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
                                        myDoc.data()["student"], 1),
                                    builder: (context, AsyncSnapshot snap) {
                                      if (snap.hasData) {
                                        Timestamp dateHolder =
                                            myDoc.data()["date"];
                                        return RespondSessionWidget(
                                          height: ScreenSize.height,
                                          session: Session(
                                              myDoc.data()["title"],
                                              SessionManager.loggedInTutor,
                                              Student(
                                                  snap.data["name"],
                                                  "email",
                                                  "pass",
                                                  "aboutMe",
                                                  myDoc.data()["student"],
                                                  [],
                                                  "Profileimg"),
                                              myDoc.id,
                                              myDoc.data()["time"],
                                              dateHolder.toDate(),
                                              myDoc.data()["description"],
                                              myDoc.data()["status"],
                                              myDoc.data()["subject"]),
                                        );
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
                  } else {
                    return Column(
                      children: [
                        SizedBox(
                          height: ScreenSize.height * 0.35,
                        ),
                        Villain(
                          villainAnimation: VillainAnimation.fade(
                            from: Duration(milliseconds: 300),
                            to: Duration(milliseconds: 600),
                          ),
                          child: Center(
                            child: Text(
                              "its quite empty in here",
                              style: GoogleFonts.sen(
                                  color: Theme.of(context)
                                      .buttonColor
                                      .withOpacity(0.6),
                                  // Theme.of(context).primaryColor,
                                  fontSize: 21),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
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
      ),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.height * 0.010,
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
              showBottomsheetModel(widget.session);
            },
            child: Container(
              height: widget.height * 0.24,
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.rectangle,
                borderRadius: new BorderRadius.circular(25.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      subjects.elementAt(widget.session.subject).path,
                      height: ScreenSize.width * 0.15,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 11.0, right: 11.0),
                            child: Text(
                              widget.session.title,
                              style: GoogleFonts.sen(
                                textStyle: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).buttonColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: widget.height * 0.005,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                              color: kColorScheme[2],
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Text(
                                DateFormat('yyyy-MM-dd')
                                        .format(widget.session.date) +
                                    " at " +
                                    widget.session.time,
                                style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 11.0, right: 11.0),
                            child: SizedBox(
                              width: ScreenSize.width * 0.45,
                              child: Text(
                                widget.session.student.name,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context).buttonColor),
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
                                      DatabaseAPI.changeSessionsStatus("active",
                                              widget.session.session_id)
                                          .then((value) => {
                                                if (value == "success")
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "the session status has been changed to Active")
                                                  }
                                                else
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Something went wrong. please try again later")
                                                  }
                                              });
                                    },
                                    child: Text(
                                      "Accept",
                                      style: GoogleFonts.sen(
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
                                      DatabaseAPI.changeSessionsStatus(
                                              "decline",
                                              widget.session.session_id)
                                          .then((value) => {
                                                if (value == "success")
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "the session status has been changed to Declined")
                                                  }
                                                else
                                                  {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Something went wrong. please try again later")
                                                  }
                                              });
                                    },
                                    child: Text(
                                      "Decline",
                                      style: GoogleFonts.sen(
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
        ),
      ],
    );
  }

  showBottomsheetModel(Session session) {
    // bottomsheet
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse("2021-12-1");
    print(tempDate);
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Text(
                    "Schedule",
                    style: GoogleFonts.sen(
                        fontSize: 20, color: Theme.of(context).buttonColor),
                  ),
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        DatabaseAPI.changeSessionsStatus(
                                "active", session.session_id)
                            .then((value) => AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Session is active now!',
                                        style: GoogleFonts.sen(
                                            color:
                                                Theme.of(context).buttonColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                )..show());
                      }),
                ],
              ),
              SizedBox(
                height: ScreenSize.height * 0.010,
              ),
              Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date",
                          style: GoogleFonts.sen(
                              fontSize: 19,
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                            new DateFormat.yMMMMEEEEd().format(
                                new DateFormat("yyyy-MM-dd")
                                    .parse(session.date.toString())),
                            style: GoogleFonts.sen(
                                fontSize: 19,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.normal)),
                        Icon(Icons.date_range),
                      ],
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.005,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Time",
                          style: GoogleFonts.sen(
                              fontSize: 19,
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(session.time,
                            style: GoogleFonts.sen(
                                fontSize: 19,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.normal)),
                        Icon(Icons.alarm),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "Session Description",
                          style: GoogleFonts.sen(
                              fontSize: 19,
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          session.desc,
                          style: GoogleFonts.sen(
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.w100,
                              fontSize: 17),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: ScreenSize.height * 0.030,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: widget.height * 0.04,
                        child: RaisedButton(
                          onPressed: () {
                            ReadFullDescription(session.desc);
                          },
                          child: Text(
                            "Read Full Description",
                            style: GoogleFonts.sen(
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
                  ],
                ),
              ),
            ],
          );
        });
  }

  ReadFullDescription(String desc) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  Text(
                    "Session Description",
                    style: GoogleFonts.sen(
                        fontSize: 19,
                        color: Theme.of(context).buttonColor,
                        fontWeight: FontWeight.normal),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.transparent,
                      ),
                      onPressed: () {}),
                ],
              ),
              SizedBox(
                height: ScreenSize.height * 0.010,
              ),
              Padding(
                padding: const EdgeInsets.all(23.0),
                child: Column(
                  children: [
                    Container(
                      child: Text(
                        desc,
                        style: GoogleFonts.sen(
                            color: Theme.of(context).buttonColor,
                            fontSize: 17,
                            fontWeight: FontWeight.normal),
                        //overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
