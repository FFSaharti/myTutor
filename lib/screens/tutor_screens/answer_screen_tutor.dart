import 'package:flutter/material.dart';
import 'package:mytutor/components/question_stream_tutor_widget.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class AnswerScreenTutor extends StatefulWidget {
  static String id = 'ask_screen_tutor';
  @override
  _AnswerScreenTutorState createState() => _AnswerScreenTutorState();
}

class _AnswerScreenTutorState extends State<AnswerScreenTutor> {
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    height: 30,
                  ),
                  Container(
                    height: ScreenSize.height * 0.69,
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      // ignore: missing_return
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: mainScreenPage(QuestionStreamTutor(
                        exp: SessionManager.loggedInTutor.experiences,
                      )),
                    ),
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
