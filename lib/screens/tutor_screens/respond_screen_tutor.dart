import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class RespondScreenTutor extends StatelessWidget {
  static String id = 'respond_screen_tutor';

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
                stream: DatabaseAPI.fetchSessionData(1, true),
                builder: (context, snapshot) {
                  // List to fill up with all the session the user has.
                  List<Widget> UserSessions = [];
                  if (snapshot.data == null){
                    return Center(child: Text("Have some Rest. there is no request for you till now!", style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 30),),);

                  }else if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> Sessions = snapshot.data.docs;
                    for (var session in Sessions) {
                      String SessionStatus = session.data()["status"];
                      if (SessionStatus.toLowerCase() == "pending") {
                        // final Sessiontutor = session.data()["tutor"];
                        final Sessionstudentid = session.data()["student"];
                        final Sessiontitle = session.data()["title"];
                        final Sessiontime = session.data()["time"];
                        final SessionDate = session.data()["date"];
                        final SessionDesc = session.data()["description"];
                        final SessionSubject = session.data()["subject"];
                        // convert the date we got from firebase into timestamp. to change it later to datetime.
                        Timestamp stamp = SessionDate;
                        UserSessions.add(
                          RespondSessionWidget(
                            height: ScreenSize.height,
                            session: Session(
                                Sessiontitle,
                                SessionManager.loggedInTutor.userId,
                                Sessionstudentid,
                                session.id,
                                Sessiontime,
                                stamp.toDate(),
                                SessionDesc,
                                SessionStatus,
                                SessionSubject),
                          ),
                        );
                      }
                    }
                  }
                  return !snapshot.hasData == true ? Center(child: Text("Have some Rest. there is no request for you till now!", style: TextStyle(color: Theme.of(context).buttonColor),),) : Expanded(
                    child: ListView(
                      reverse: false,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
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
    return Column(
      children: [
        SizedBox(
          height: widget.height * 0.010,
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
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
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     spreadRadius: 1,
                //     blurRadius: 15,
                //     offset: Offset(0, 6), // changes position of shadow
                //   ),
                // ],
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
                                finishLoad ? student_name : "loading..",
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
