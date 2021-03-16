import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';
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
  int subject = -1;
  String searchBox = '';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(context, Theme.of(context).accentColor, "Answer", false),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              print("updating questions....");
            },
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: ScreenSize.width * 0.90,
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchBox = value;
                                VillainController.playAllVillains(context);
                              });
                            },
                            style: TextStyle(color: Theme.of(context).accentColor),
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              filled: true,
                              hintText: 'Search by problem name or subject',
                              hintStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                              prefixIcon:
                                  Icon(Icons.search, color: Theme.of(context).accentColor),
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
                          height: ScreenSize.height * 0.02,
                        ),
                        Container(
                          height: ScreenSize.height * 0.75,
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            // ignore: missing_return
                            onNotification: (overscroll) {
                              overscroll.disallowGlow();
                            },
                            child: mainScreenPage(
                              QuestionStreamTutor(
                                exp: SessionManager.loggedInTutor.experiences,
                                search: searchBox,
                              ),
                            ),
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
