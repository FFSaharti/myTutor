import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/screens/chat_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: widget.session.status == "pending"
            ? null
            : () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => messagesScreen(
                        currentsession: widget.session,
                      ),
                    ));
              },
        child: Container(
          height: widget.height * 0.18,
          decoration: new BoxDecoration(
            color: Color(0xFFefefef),
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
                padding: const EdgeInsets.only(left :10.0),
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
                                color: Colors.grey),
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
