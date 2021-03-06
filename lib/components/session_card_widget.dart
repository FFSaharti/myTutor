import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
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
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        DatabaseAPI.changeSessionsStatus(
                                "active", session.session_id)
                            .then((value) => {
                              if(value == 'success'){
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'the session status has been changed now to active, please navigate to home screen or messages screen to start tutoring',
                                        style: kTitleStyle.copyWith(
                                            color: kBlackish,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                )..show(),
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.ERROR,
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Error occur please try again',
                                        style: kTitleStyle.copyWith(
                                            color: kBlackish,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal),
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
                          style: kTitleStyle.copyWith(
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                            new DateFormat.yMMMMEEEEd().format(
                                new DateFormat("yyyy-MM-dd")
                                    .parse(session.date.toString())),
                            style: kTitleStyle.copyWith(
                                fontSize: 19,
                                color: Colors.black,
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
                          style: kTitleStyle.copyWith(
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(session.time,
                            style: kTitleStyle.copyWith(
                                fontSize: 19,
                                color: Colors.black,
                                fontWeight: FontWeight.normal)),
                        Icon(Icons.alarm),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text(
                          "Session Description",
                          style: kTitleStyle.copyWith(
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.white10,
                        child: Text(
                          session.desc,
                          style: kTitleStyle.copyWith(
                              color: kGreyerish,
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
                    GestureDetector(
                      onTap: () {
                        //ReadFullDescription(session.desc);
                      },
                      child: Text("click here to read the full description",
                          style: kTitleStyle.copyWith(
                              fontSize: 19,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
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
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          if (widget.session.status == "waiting for student") {
            showBottomsheetModel(widget.session);
          } else if (widget.session.status == "pending") {
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    currentsession: widget.session,
                  ),
                ));
          }
        }

        // onTap: widget.session.status == "pending"
        //     ? null
        //     : () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => messagesScreen(
        //                 currentsession: widget.session,
        //               ),
        //             ));
        //       },
        ,
        child: Container(
          height: widget.height * 0.18,
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(11.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                subjects.elementAt(widget.session.subject).path,
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                      child: Text(
                        widget.session.title,
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).primaryColor),
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
                        padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                        child: Text(
                          DateFormat('yyyy-MM-dd').format(widget.session.date) +
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
                      padding: const EdgeInsets.only(left: 11, right: 11),
                      child: SizedBox(
                        width: 220,
                        child: Text(
                          finish ? helperName : "loading..",
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor),
                          ),
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
