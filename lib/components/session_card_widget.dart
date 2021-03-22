import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/screens/chat_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

class SessionCardWidget extends StatefulWidget {
  const SessionCardWidget({
    Key key,
    @required this.height,
    this.session,
    this.isStudent,
  }) : super(key: key);
  final Session session;
  final double height;
  final bool isStudent;

  @override
  _SessionCardWidgetState createState() => _SessionCardWidgetState();
}

class _SessionCardWidgetState extends State<SessionCardWidget> {
  String helperName = "";
  bool finish = false;

  void initState() {
    // get the tutor name.

    if (widget.isStudent == false) {
      // means that the current user is not student, so get the student name
      DatabaseAPI.getUserbyid(widget.session.student, 1).then((data) {
        setState(() {
          helperName = data.data()["name"];
          finish = true;
        });
      });
    } else if (widget.isStudent == true) {
      DatabaseAPI.getUserbyid(widget.session.tutor, 0).then((data) {
        setState(() {
          helperName = data.data()["name"];
          print(helperName);
          finish = true;
        });
      });
    }

    super.initState();
  }

  showBottomsheetModel(Session session) {
    // bottomsheet
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse("2021-12-1");
    print(tempDate);
    showModalBottomSheet(
        backgroundColor: Theme.of(context).cardColor,
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
                            .then((value) => {
                                  if (value == 'success')
                                    {
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.SUCCES,
                                        body: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Session is now active!',
                                              style: GoogleFonts.sen(
                                                  color: Theme.of(context)
                                                      .buttonColor,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        btnOkOnPress: () {
                                          Navigator.pop(context);
                                        },
                                      )..show(),
                                    }
                                  else
                                    {
                                      AwesomeDialog(
                                        context: context,
                                        animType: AnimType.SCALE,
                                        dialogType: DialogType.ERROR,
                                        body: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              'Error occured please try again',
                                              style: GoogleFonts.sen(
                                                  color: Theme.of(context)
                                                      .buttonColor,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        btnOkOnPress: () {
                                          Navigator.pop(context);
                                        },
                                      )..show(),
                                    }
                                });
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
                              fontWeight: FontWeight.normal),
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
                              fontWeight: FontWeight.normal),
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
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.02,
                    ),
                    Container(
                      height: ScreenSize.height * 0.2,
                      child: disableBlueOverflow(
                        context,
                        SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              height: ScreenSize.height * 0.3,
                              color: Colors.transparent,
                              child: Text(
                                session.desc
                                    ,
                                style: GoogleFonts.sen(
                                    color: Theme.of(context).buttonColor,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 17),
                                //overflow: TextOverflow.ellipsis,
                                // maxLines: 5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: ScreenSize.height * 0.030,
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (widget.session.status == "waiting for student") {
            showBottomsheetModel(widget.session);
          } else if (widget.session.status == "pending") {
            Fluttertoast.showToast(
                msg: "the tutor does not accept the session yet.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    currentsession: widget.session,
                  ),
                ));
          }
        },
        child: Container(
          height: widget.height * 0.155,
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: ScreenSize.width * 0.04,
              ),
              Image.asset(
                subjects.elementAt(widget.session.subject).path,
                height: ScreenSize.width * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 11.0, right: 11.0),
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
                      height: ScreenSize.width * 0.005,
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        color: kColorScheme[1],
                        borderRadius: new BorderRadius.circular(50.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(widget.session.date) +
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
                    SizedBox(
                      height: ScreenSize.width * 0.005,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Text(
                        finish ? helperName : "Loading...",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.sen(
                          textStyle: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
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
