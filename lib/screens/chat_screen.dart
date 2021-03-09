import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/components/messages_stream_widget.dart';
import 'package:mytutor/screens/student_screens/view_tutor_profile_screen.dart';
import 'package:mytutor/screens/view_receiver_profile.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                        value.id,
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
                        value.id,
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
                        height: ScreenSize.height * 0.172,
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
                              leading: GestureDetector(
                                onTap: () {
                                  receiverDataLoadIndicator == true
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewReceiverProfile(
                                                    userId: receiver.userId,
                                                    role: SessionManager
                                                                .loggedInTutor
                                                                .userId ==
                                                            ""
                                                        ? "tutor"
                                                        : "student",
                                                  )),
                                        )
                                      : print('wait to load');
                                },
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(receiver.profileImag),
                                  backgroundColor: kColorScheme[1],
                                  foregroundColor: Colors.black,
                                  radius: 27.0,
                                ),
                              ),
                              title: receiverDataLoadIndicator == true
                                  ? Text(
                                      receiver.name,
                                      style: GoogleFonts.openSans(
                                          fontSize: 25, color: Colors.white),
                                      maxLines: 1,
                                    )
                                  : Text(""),
                              trailing: GestureDetector(
                                onTap:  widget.currentsession.status == "closed" ? () {
                                  Fluttertoast.showToast(
                                      msg: "you cannot closed or rated this session.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }: () {
                                  SessionManager.loggedInTutor.userId == ""
                                      ? showBottomSheetForStudent()
                                      : showBottomSheetForTutor();
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: widget.currentsession.status == "closed" ? Colors.grey :Colors.white,
                                ),
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

                                          style: GoogleFonts.openSans(
                                              fontSize: 15, color:
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
                                          style: GoogleFonts.openSans(
                                              fontSize: 15, color:
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
                    child: userChooseForTypeofChat == 0
                        ? MessagesStream(
                            sessionid: widget.currentsession.session_id,
                            imageOnly: false,
                          )
                        : MessagesStream(
                            sessionid: widget.currentsession.session_id,
                            imageOnly: true,
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
                    color: Theme.of(context).bottomAppBarColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: widget.currentsession.status == "closed"
                              ? null : () async {
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "title : " + widget.currentsession.title,
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 17),
                    ),
                    Text(
                      "Subject : " +
                          subjects
                              .elementAt(widget.currentsession.subject)
                              .title,
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 17),
                    ),
                    Text(
                      "Description : " + widget.currentsession.desc,
                      style: GoogleFonts.openSans(
                          color: Colors.black, fontSize: 17),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                                                'the session has been successfully closed ',
                                                style: kTitleStyle.copyWith(
                                                    color: kBlackish,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          btnOkOnPress: () {
                                            int _popCount = 0;
                                            Navigator.popUntil(context,
                                                (route) {
                                              return _popCount++ == 2;
                                            });
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
                                                'Error occur please try again',
                                                style: kTitleStyle.copyWith(
                                                    color: kBlackish,
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
              ));
        });
  }
}
