import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

//TODO: implement view all chat/ image only.
//TODO: implement view profile by clicking on circle Avatar?
class ChatScreen extends StatefulWidget {
  final Session currentsession;

  const ChatScreen({this.currentsession});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void getCurrentuser() {
    SessionManager.loggedInTutor.userId == ""
        ? DatabaseAPI.getUserbyid(widget.currentsession.tutor, 0)
            .then((value) => {
                  setState(() {
                    receiverDataLoadIndicator = !receiverDataLoadIndicator;
                    receiver = Student(
                        value.data()["name"],
                        value.data()["email"],
                        "none",
                        value.data()["aboutMe"],
                        value.data()["userId"],
                        [],
                        value.data()["profileImg"]);
                  })
                })
        : DatabaseAPI.getUserbyid(widget.currentsession.student, 1)
            .then((value) => {
                  setState(() {
                    receiverDataLoadIndicator = !receiverDataLoadIndicator;
                    receiver = Tutor(
                        value.data()["name"],
                        value.data()["email"],
                        "none",
                        value.data()["aboutMe"],
                        value.data()["userId"],
                        [],
                        value.data()["profileImg"]);
                  })
                });
  }

  void initState() {
    getCurrentuser();
  }

  final messageTextController = TextEditingController();
  String dropdownValue = 'rate tutor';
  bool fileUploadIndicator = false;
  bool receiverDataLoadIndicator = false;
  String newMessage;
  MyUser receiver;
  int userChooseForTypeofChat = 0;

  refresh() {
    setState(() {
      fileUploadIndicator = !fileUploadIndicator;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: null,
      //   elevation: 0,
      //   backgroundColor: Color(0x44000000),
      //   actions: <Widget>[
      //     IconButton(
      //         icon: Icon(Icons.info_outline),
      //         onPressed: () {
      //           if (SessionManager.loggedInTutor.userId == "") {
      //             // current user is student, show him the bottom sheet to give  him the ability to rate the session
      //             // check if the session is active, then show the rate bottom sheet, if not show a error pop up.
      //             widget.currentsession.status == "active"
      //                 ? showBottomSheetForStudent()
      //                 : AwesomeDialog(
      //                     context: context,
      //                     animType: AnimType.SCALE,
      //                     dialogType: DialogType.ERROR,
      //                     body: Padding(
      //                       padding: const EdgeInsets.all(8.0),
      //                       child: Center(
      //                         child: Text(
      //                           'the session is closed. you cant rate it anymore..',
      //                           style: kTitleStyle.copyWith(
      //                               color: kBlackish,
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.normal),
      //                         ),
      //                       ),
      //                     ),
      //                     btnOkOnPress: () {
      //                       Navigator.pop(context);
      //                     },
      //                   ).show();
      //           } else {
      //             showBottomSheetForTutor();
      //           }
      //         }),
      //   ],
      // ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: receiverDataLoadIndicator == false
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(kColorScheme[3]),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        height: ScreenSize.height * 0.18,
                        decoration: new BoxDecoration(
                            color: kColorScheme[1],
                            borderRadius: new BorderRadius.only(
                                bottomRight: const Radius.circular(25.0),
                                bottomLeft: const Radius.circular(25.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenSize.height * 0.010,
                            ),

                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(receiver.profileImag),
                                backgroundColor: kColorScheme[1],
                                foregroundColor: Colors.black,
                                radius: 30.0,
                              ),
                              title: receiverDataLoadIndicator == true
                                  ? Text(
                                      receiver.name,
                                      style: kTitleStyle.copyWith(fontSize: 30),
                                    )
                                  : Text(""),
                              trailing: DropdownButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.deepPurple),
                                onChanged: (String userChoose) {
                                  setState(() {
                                    if(userChoose == 'close session'){
                                      showBottomSheetForTutor();
                                    } else if (userChoose == 'rate tutor') {
                                      if (SessionManager.loggedInTutor.userId ==
                                          "")
                                        // current user is student, show him the bottom sheet to give  him the ability to rate the session
                                        // check if the session is active, then show the rate bottom sheet, if not show a error pop up.
                                        widget.currentsession.status == "active"
                                            ? showBottomSheetForStudent()
                                            : AwesomeDialog(
                                                context: context,
                                                animType: AnimType.SCALE,
                                                dialogType: DialogType.ERROR,
                                                body: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: Text(
                                                      'the session is closed. you cant rate it anymore..',
                                                      style:
                                                          kTitleStyle.copyWith(
                                                              color: kBlackish,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                  ),
                                                ),
                                                btnOkOnPress: () {
                                                  Navigator.pop(context);
                                                },
                                              ).show();
                                    } else {
                                      showBottomSheetForSessionDescription();
                                    }
                                  });
                                },
                                items: SessionManager.loggedInTutor == "" ?<String>[
                                  'rate tutor',
                                  'read session\ndescription',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList() : <String>[
                                  'close session',
                                  'read session\ndescription',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList()
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        userChooseForTypeofChat = 0;
                                      });
                                    },
                                    child: Container(
                                      width: ScreenSize.width * 0.25,
                                      height: ScreenSize.height * 0.050,
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          "All chat",
                                          style: TextStyle(
                                              color:
                                                  userChooseForTypeofChat == 0
                                                      ? kColorScheme[1]
                                                      : Colors.white),
                                        )),
                                        decoration: new BoxDecoration(
                                            color: userChooseForTypeofChat == 0
                                                ? Colors.white
                                                : kColorScheme[1],
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            border: Border.all(
                                                color: kColorScheme[1])),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        userChooseForTypeofChat = 1;
                                      });
                                    },
                                    child: Container(
                                      width: ScreenSize.width * 0.25,
                                      height: ScreenSize.height * 0.050,
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          "Image only",
                                          style: TextStyle(
                                              color:
                                                  userChooseForTypeofChat == 1
                                                      ? kColorScheme[1]
                                                      : Colors.white),
                                        )),
                                        decoration: new BoxDecoration(
                                            color: userChooseForTypeofChat == 1
                                                ? Colors.white
                                                : kColorScheme[1],
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                            border: Border.all(
                                                color: kColorScheme[1])),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // receiverDataLoadIndicator == false ? Text("hello") :
                  //     Text(receiverName),
                  NotificationListener<OverscrollIndicatorNotification>(
                    // ignore: missing_return
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: MessagesStream(
                      sessionid: widget.currentsession.session_id,
                    ),
                  ),
                  fileUploadIndicator == true
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.white,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(kColorScheme[3]),
                        )
                      : Text(""),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: () async {
                            //TODO: imageuplode
                            refresh();
                            String filename = "hello";
                            FilePickerResult file = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            File _file;
                            try {
                              file.files.single.path == null
                                  ? print("hello")
                                  : _file = File(file.files.single.path);
                              DatabaseAPI.uploadImageToStorage(
                                      _file,
                                      widget.currentsession.session_id,
                                      SessionManager.loggedInUser.name)
                                  .then((value) => {
                                        refresh(),
                                      });
                            } catch (e) {
                              refresh();
                              print('never reached');
                            }
                          },
                        ),
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
                              Text("Send"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
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
                                              creativityRate,
                                              DateTime.now(),
                                              widget.currentsession.title),
                                          widget.currentsession.tutor)
                                      : DatabaseAPI.rateTutor(
                                          Rate(
                                              null,
                                              teachRate,
                                              friendRate,
                                              commRate,
                                              creativityRate,
                                              DateTime.now(),
                                              widget.currentsession.title),
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

  showBottomSheetForTutor() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
              height: ScreenSize.height * 0.30,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "are you sure you want to close ?",
                    style:
                        kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.030,
                  ),
                  EZButton(
                      width: ScreenSize.width * 0.50,
                      buttonColor: kColorScheme[2],
                      textColor: Colors.white,
                      isGradient: false,
                      colors: null,
                      buttonText: "Close the session",
                      hasBorder: false,
                      borderColor: null,
                      onPressed: () {

                        DatabaseAPI.changeSessionsStatus(
                            "close", widget.currentsession.session_id)
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
                                    'the session has been successfully closed ',
                                    style: kTitleStyle.copyWith(
                                        color: kBlackish,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              btnOkOnPress: () {
                                int _popCount = 0;
                                Navigator.popUntil(context, (route) {
                                  return _popCount++ == 2;
                                });
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
              ));
        });
  }

  showBottomSheetForSessionDescription() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
              height: ScreenSize.height * 0.40,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.currentsession.title,
                      style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                    Text(
                      "Description:\t\t"+widget.currentsession.desc,
                      style:
                          kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.030,
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
          String imageurl = "";
          messageText == "image"
              ? imageurl = message.data()['imageUrl']
              : imageurl = null;
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
            imageUrl: imageurl,
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

class MessageShape extends StatefulWidget {
  MessageShape({
    this.sender,
    this.text,
    this.SameUser,
    this.time,
    this.imageUrl,
  });

  final String sender;
  final String time;
  final String text;
  final bool SameUser;
  final String imageUrl;

  @override
  _MessageShapeState createState() => _MessageShapeState();
}

class _MessageShapeState extends State<MessageShape> {
  void _showBiggerImage(String url) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return new Container(
            height: ScreenSize.height * 0.90,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: FadeInImage(
              placeholder: AssetImage("images/loading.png"),
              image: NetworkImage(
                widget.imageUrl,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.SameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // check if the test called image then display the image.
          widget.text == "image"
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _showBiggerImage(widget.imageUrl);
                    },
                    child: FadeInImage(
                      placeholder: AssetImage("images/loading.png"),
                      image: NetworkImage(
                        widget.imageUrl,
                      ),
                      height: 150,
                      width: 150,
                    ),
                  ))
              : Row(
                  mainAxisAlignment: widget.SameUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Material(
                      borderRadius: widget.SameUser
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
                      color: widget.SameUser ? kColorScheme[1] : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          widget.text,
                          style: TextStyle(
                            color:
                                widget.SameUser ? Colors.white : Colors.black54,
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
            widget.time,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
