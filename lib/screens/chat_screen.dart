import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class messagesScreen extends StatefulWidget {
  final Session currentsession;

  const messagesScreen({this.currentsession});

  @override
  _messagesScreenState createState() => _messagesScreenState();
}

class _messagesScreenState extends State<messagesScreen> {
  final messageTextController = TextEditingController();
  String newMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0,
        backgroundColor: Color(0x44000000),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                if (SessionManager.loggedInTutor.userId == "") {
                  // current user is student, show him the bottom sheet to give  him the ability to rate the session
                  // check if the session is active, then show the rate bottom sheet, if not show a error pop up.
                  widget.currentsession.status == "active"
                      ? showBottomSheetForStudent()
                      : AwesomeDialog(
                          context: context,
                          animType: AnimType.SCALE,
                          dialogType: DialogType.ERROR,
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'the session is closed. you cant rate it anymore..',
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
                        ).show();
                } else {
                  //TODO: bottom sheet for tutor without rating.
                }
              }),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              sessionid: widget.currentsession.session_id,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      readOnly: widget.currentsession.status == "closed"
                          ? true
                          : false,
                      controller: messageTextController,
                      onChanged: (value) {
                        newMessage = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: widget.currentsession.status == "closed"
                            ? 'the session is ended. its in view Mode only'
                            : 'Type....',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: widget.currentsession.status == "closed"
                        ? null
                        : () {
                            messageTextController.clear();
                            DatabaseAPI.saveNewMessage(
                                widget.currentsession.session_id,
                                newMessage,
                                SessionManager.loggedInUser.name);
                          },
                    child: Row(
                      children: [
                        Text("send"),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheetForStudent() {
    PageController _pageController = PageController();
    TextEditingController reviewController = TextEditingController();
    double teachRate = 0;
    double commRate = 0;
    double friendRate = 0;
    double creativityRate = 0;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
              height: ScreenSize.height * 0.70,
              child: NotificationListener<OverscrollIndicatorNotification>(
                // ignore: missing_return
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: PageView(
                  physics: new NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(
                            "Teaching skills",
                            style: kTitleStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {
                                teachRate = v;
                              },
                              starCount: 5,
                              rating: 0,
                              size: 40.0,
                              isReadOnly: false,
                              color: kColorScheme[2],
                              borderColor: kColorScheme[1],
                              spacing: 0.0),
                          SizedBox(
                            height: ScreenSize.height * 0.0070,
                          ),
                          Text(
                            "Communication",
                            style: kTitleStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {
                                commRate = v;
                              },
                              starCount: 5,
                              rating: 0,
                              size: 40.0,
                              isReadOnly: false,
                              color: kColorScheme[2],
                              borderColor: kColorScheme[1],
                              spacing: 0.0),
                          SizedBox(
                            height: ScreenSize.height * 0.0070,
                          ),
                          Text(
                            "friendliness",
                            style: kTitleStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {
                                friendRate = v;
                              },
                              starCount: 5,
                              rating: 0,
                              size: 40.0,
                              isReadOnly: false,
                              color: kColorScheme[2],
                              borderColor: kColorScheme[1],
                              spacing: 0.0),
                          SizedBox(
                            height: ScreenSize.height * 0.0070,
                          ),
                          Text(
                            "Creativity",
                            style: kTitleStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SmoothStarRating(
                            allowHalfRating: false,
                            onRated: (v) {
                              creativityRate = v;
                            },
                            starCount: 5,
                            size: 40.0,
                            isReadOnly: false,
                            color: kColorScheme[2],
                            borderColor: kColorScheme[1],
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.010,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  // close the session without rating.
                                  DatabaseAPI.changeSessionsStatus("closed",
                                      widget.currentsession.session_id);
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                },
                                child: Text(
                                  "Close without rate",
                                  style: GoogleFonts.sarabun(
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
                              RaisedButton(
                                onPressed: () {
                                  _pageController.animateToPage(
                                    2,
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  "submit the rate",
                                  style: GoogleFonts.sarabun(
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: ScreenSize.height * 0.030,
                          ),
                          Text(
                            "Rate a Review for your tutor!",
                            style: kTitleStyle.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.0090,
                          ),
                          Text(
                            "you can leave it empty if you want to",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.0090,
                          ),
                          TextField(
                            controller: reviewController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              hintText: 'Type your Review....',
                              border: InputBorder.none,
                            ),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.020,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  reviewController.text.isNotEmpty
                                      ? DatabaseAPI.rateTutor(
                                          Rate(
                                              reviewController.text,
                                              teachRate,
                                              friendRate,
                                              commRate,
                                              creativityRate),
                                          widget.currentsession.tutor)
                                      : DatabaseAPI.rateTutor(
                                          Rate(null, teachRate, friendRate,
                                              commRate, creativityRate),
                                          widget.currentsession.tutor);
                                  DatabaseAPI.changeSessionsStatus("closed",
                                      widget.currentsession.session_id);
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                },
                                child: Text(
                                  "submit and close the Session",
                                  style: GoogleFonts.sarabun(
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
  }
}

class MessagesStream extends StatelessWidget {
  final String sessionid;

  const MessagesStream({this.sessionid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchSessionMessages(sessionid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("");
        }
        final messages = snapshot.data.docs;

        // messages list has all the messageshape widget.
        List<MessageShape> Messages = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];

          final Timestamp timestamp = message.data()['time'] as Timestamp;
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
          // time
          final currentUser = SessionManager.loggedInUser.name;
          final messageShape = MessageShape(
            time: time,
            sender: messageSender,
            text: messageText,
            SameUser: currentUser == messageSender,
          );

          Messages.add(messageShape);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: Messages,
          ),
        );
      },
    );
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}

class MessageShape extends StatelessWidget {
  MessageShape({this.sender, this.text, this.SameUser, this.time});

  final String sender;
  final String time;
  final String text;
  final bool SameUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            SameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment:
                SameUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Material(
                //TODO: Fix messages shape.
                borderRadius: SameUser
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(0.0))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                elevation: 3.0,
                color: SameUser ? kColorScheme[1] : Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: SameUser ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
