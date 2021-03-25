import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/components/messages_stream_widget.dart';
import 'package:mytutor/screens/view_receiver_profile.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ChatScreen extends StatefulWidget {
  final Session currentsession;

  const ChatScreen({this.currentsession});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  void initState() {

  }

  final messageTextController = TextEditingController();
  String dropdownValue = 'rate tutor';
  bool fileUploadIndicator = false;
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
    SessionManager.loggedInTutor.userId == ""?  receiver = widget.currentsession.tutor :  receiver = widget.currentsession.student;
    return DisableDefaultPop(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: ScreenSize.height * 0.172,
                          decoration: new BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: new BorderRadius.only(
                                  bottomRight: const Radius.circular(25.0),
                                  bottomLeft: const Radius.circular(25.0))),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: ScreenSize.height * 0.010,
                            ),
                            ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      )),
                                  SizedBox(
                                    width: ScreenSize.width * 0.020,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                     Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewReceiverProfile(
                                                        receiver: receiver,
                                                        role: SessionManager
                                                                    .loggedInTutor
                                                                    .userId ==
                                                                ""
                                                            ? "tutor"
                                                            : "student",
                                                      )),
                                            );
                                    },
                                    child: receiver.profileImag == ""
                                        ? Icon(
                                            Icons.account_circle_sharp,
                                            size: ScreenSize.height * 0.080,
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                receiver.profileImag),
                                            backgroundColor: kColorScheme[1],
                                            foregroundColor: Colors.black,
                                            radius: 27.0,
                                          ),
                                  ),
                                ],
                              ),
                              title: Text(
                                      receiver.name,
                                      style: GoogleFonts.sen(
                                          fontSize: 25, color: Colors.white),
                                      maxLines: 1,
                                    ),
                              trailing: GestureDetector(
                                onTap: widget.currentsession.status == "closed"
                                    ? () {
                                        Fluttertoast.showToast(
                                            msg: "Session already closed!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    : () {
                                        SessionManager.loggedInTutor.userId ==
                                                ""
                                            ? showBottomSheetForStudent()
                                            : showBottomSheetForTutor();
                                      },
                                child: Icon(
                                  Icons.info_outline,
                                  color:
                                      widget.currentsession.status == "closed"
                                          ? Colors.grey
                                          : Colors.white,
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
                                          style: GoogleFonts.sen(
                                              fontSize: 15,
                                              color:
                                                  userChooseForTypeofChat == 0
                                                      ? Theme.of(context)
                                                          .disabledColor
                                                      : Theme.of(context)
                                                          .highlightColor),
                                        )),
                                        decoration: new BoxDecoration(
                                          color: userChooseForTypeofChat == 0
                                              ? Theme.of(context).highlightColor
                                              : Theme.of(context).disabledColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
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
                                          style: GoogleFonts.sen(
                                              fontSize: 15,
                                              color:
                                                  userChooseForTypeofChat == 1
                                                      ? Theme.of(context)
                                                          .disabledColor
                                                      : Theme.of(context)
                                                          .highlightColor),
                                        )),
                                        decoration: new BoxDecoration(
                                          color: userChooseForTypeofChat == 1
                                              ? Theme.of(context).highlightColor
                                              : Theme.of(context).disabledColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // receiverDataLoadIndicator == false ? Text("hello") :
                    //     Text(receiverName),
                    disableBlueOverflow(
                      context,
                      userChooseForTypeofChat == 0
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
                      color: Theme.of(context).cardColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.attach_file,
                                color: Theme.of(context).iconTheme.color),
                            onPressed: widget.currentsession.status == "closed"
                                ? null
                                : () async {
                                    refresh();
                                    //    String filename = "hello";
                                    FilePickerResult file = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image);
                                    File _file;
                                    try {
                                      file.files.single.path == null
                                          ? ""
                                          : _file =
                                              File(file.files.single.path);
                                      DatabaseAPI.uploadImageToStorage(
                                              _file,
                                              widget.currentsession.session_id,
                                              SessionManager.loggedInUser.name)
                                          .then((value) => {
                                            value == "done" ? print('') : Fluttertoast.showToast(msg: "we couldn't upload the image right now. check your connection and try again"),
                                                refresh(),
                                              });
                                    } catch (e) {
                                      Fluttertoast.showToast(msg: "Please choose image to upload");
                                      refresh();
                                    }
                                  },
                          ),
                          Expanded(
                            child: TextField(
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
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
                                hintText: widget.currentsession.status ==
                                        "closed"
                                    ? 'the session is ended. its in view Mode only'
                                    : 'Type....',
                                hintStyle: GoogleFonts.sen(
                                    color: Theme.of(context).iconTheme.color),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          FlatButton(
                            onPressed: widget.currentsession.status == "closed"
                                ? null
                                : () {
                                    messageTextController.clear();
                                    String status =DatabaseAPI.saveNewMessage(
                                        widget.currentsession.session_id,
                                        newMessage,
                                        SessionManager.loggedInUser.name);
                                    status == 'error' ? Fluttertoast.showToast(msg: "error occur please check your network.") : "";
                                  },
                            child: Row(
                              children: [
                                Text(
                                  "Send",
                                  style: TextStyle(
                                      color: Theme.of(context).iconTheme.color),
                                ),
                                SizedBox(
                                  width: ScreenSize.width * 0.005,
                                ),
                                Icon(Icons.arrow_forward_ios_outlined,
                                    color: Theme.of(context).iconTheme.color),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: ScreenSize.height * 0.50,
            decoration: kCurvedShapeDecoration(
                Theme.of(context).scaffoldBackgroundColor),
            child: disableBlueOverflow(
              context,
              PageView(
                physics: new NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          "Teaching skills",
                          style: GoogleFonts.sen(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
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
                          style: GoogleFonts.sen(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
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
                          "Friendliness",
                          style: GoogleFonts.sen(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
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
                          style: GoogleFonts.sen(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                // close the session without rating.
                                DatabaseAPI.changeSessionsStatus(
                                    "closed", widget.currentsession.session_id);
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              },
                              child: Text(
                                "Close without Rate",
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
                            RaisedButton(
                              onPressed: () {
                                _pageController.animateToPage(
                                  2,
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Text(
                                "Submit Rate",
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
                          "Provide a Review for your tutor!",
                          style: GoogleFonts.sen(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.0090,
                        ),
                        Text(
                          "You can leave it empty if you want to",
                          style: GoogleFonts.sen(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.0090,
                        ),
                        TextField(
                          controller: reviewController,
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).buttonColor),
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            hintText: 'Type your Review....',
                            hintStyle:
                                TextStyle(color: Theme.of(context).buttonColor),
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
                                        widget.currentsession.tutor.userId)
                                    : DatabaseAPI.rateTutor(
                                        Rate(
                                            null,
                                            teachRate,
                                            friendRate,
                                            commRate,
                                            creativityRate,
                                            DateTime.now(),
                                            widget.currentsession.title),
                                        widget.currentsession.tutor.userId);
                                DatabaseAPI.changeSessionsStatus(
                                    "closed", widget.currentsession.session_id);
                                int count = 0;
                                Navigator.popUntil(context, (route) {
                                  return count++ == 2;
                                });
                              },
                              child: Text(
                                "Submit and Close Session",
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showBottomSheetForTutor() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
              decoration: kCurvedShapeDecoration(
                  Theme.of(context).scaffoldBackgroundColor),
              height: ScreenSize.height * 0.40,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    InfoTile(
                      iconData: Icons.title,
                      text: widget.currentsession.title,
                      expandable: true,
                    ),
                    InfoTile(
                      iconData: Icons.subject,
                      text: subjects[widget.currentsession.subject].title,
                      expandable: false,
                    ),
                    InfoTile(
                      iconData: Icons.description_outlined,
                      text: widget.currentsession.desc,
                      expandable: true,
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.030,
                    ),
                    CircularButton(
                        width: ScreenSize.width * 0.50,
                        buttonColor: kColorScheme[2],
                        textColor: Colors.white,
                        isGradient: false,
                        colors: null,
                        fontSize: 20,
                        buttonText: "Close Session",
                        hasBorder: false,
                        borderColor: null,
                        onPressed: () {
                          DatabaseAPI.changeSessionsStatus(
                                  "closed", widget.currentsession.session_id)
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
                                                    color: Theme.of(context)
                                                        .buttonColor,
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

class InfoTile extends StatelessWidget {
  IconData iconData;
  String text;
  bool expandable;

  InfoTile(
      {@required this.iconData,
      @required this.text,
      @required this.expandable});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        trailing: expandable && text.length > 20
            ? GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0))),
                      context: context,
                      enableDrag: false,
                      builder: (context) {
                        return Container(
                          height: ScreenSize.height * 0.4,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(Icons.cancel),
                                  ),
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.02,
                                ),
                                Container(
                                  height: ScreenSize.height * 0.25,
                                  child: disableBlueOverflow(
                                    context,
                                    SingleChildScrollView(
                                      child: Text(
                                        text,
                                        textAlign: TextAlign.left,
                                        style: GoogleFonts.sen(
                                            fontSize: 20,
                                            color:
                                                Theme.of(context).buttonColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          decoration: kCurvedShapeDecoration(
                              Theme.of(context).scaffoldBackgroundColor),
                        );
                      });
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).buttonColor,
                ),
              )
            : Icon(
                Icons.arrow_forward_ios,
                color: Colors.transparent,
              ),
        leading: Icon(
          iconData,
          color: Theme.of(context).buttonColor,
          size: 24,
        ),
        title: Text(text,
            style: GoogleFonts.sen(
                color: Theme.of(context).buttonColor, fontSize: 22),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
