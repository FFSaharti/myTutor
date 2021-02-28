import 'package:flutter/material.dart';
import 'package:mytutor/components/question_stream_tutor_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class AnswerScreenTutor extends StatefulWidget {
  static String id = 'ask_screen_tutor';
  @override
  _AnswerScreenTutorState createState() => _AnswerScreenTutorState();
}

class _AnswerScreenTutorState extends State<AnswerScreenTutor> {
  PageController _pageController = PageController();
  int subject = -1;
  String searchBox = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here.
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white70,
        actions: <Widget>[],
        title: Text(
          "Answer",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            print("updating questions...");
          },
          child: Container(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        width: ScreenSize.width * 0.8,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchBox = value;
                            });
                          },
                          style: TextStyle(
                            color: kBlackish,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            filled: true,
                            hintText: 'Search by problem name or subject',
                            prefixIcon:
                                Icon(Icons.search, color: kColorScheme[2]),
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
                        height: 10,
                      ),
                      // EZButton(
                      //     width: ScreenSize.width * 0.5,
                      //     buttonColor: kColorScheme[2],
                      //     textColor: Colors.white,
                      //     isGradient: true,
                      //     colors: [kColorScheme[0], kColorScheme[2]],
                      //     buttonText: "Filter Options",
                      //     hasBorder: false,
                      //     borderColor: null,
                      //     onPressed: () {
                      //       print("pressed filters");
                      //     }),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        height: ScreenSize.height * 0.68,
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
                          // ignore: missing_return
                          onNotification: (overscroll) {
                            overscroll.disallowGlow();
                          },
                          child: mainScreenPage(QuestionStreamTutor(
                            exp: SessionManager.loggedInTutor.experiences,
                            search: searchBox,
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  mainScreenPage(Widget StreamWidget) {
    return Column(
      children: [
        StreamWidget,
        SizedBox(
          height: ScreenSize.height * 0.05,
        ),
      ],
    );
  }
}
