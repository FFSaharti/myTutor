import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

import 'file:///C:/Users/faisa/Desktop/Developer/AndroidStudioProjects/mytutor/lib/screens/student_screens/question_answers_page_screen_student.dart';

class AskScreenStudent extends StatefulWidget {
  static String id = 'ask_screen_student';
  @override
  _AskScreenStudentState createState() => _AskScreenStudentState();
}

class _AskScreenStudentState extends State<AskScreenStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here.
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white70,
        title: Text(
          "Ask",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Text("List Of Questions --> "),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: ScreenSize.height * 0.65,
                  width: ScreenSize.width * 0.8,
                  child: ListView(
                    children: getQuestions(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getQuestions() {
    List<Widget> widgets = [];

    for (int i = 0; i < SessionManager.loggedInStudent.questions.length; i++) {
      widgets.add(GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionAnswersScreenStudent(
                  SessionManager.loggedInStudent.questions[i]),
            ),
          );
        },
        child: QuestionWidget(
            widget: widget,
            question: SessionManager.loggedInStudent.questions[i]),
      ));
      widgets.add(SizedBox(
        height: 5,
      ));
    }

    return widgets;
  }
}

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    @required this.widget,
    @required this.question,
  });

  final AskScreenStudent widget;
  final Question question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: ScreenSize.height * 0.15,
        decoration: BoxDecoration(
          color: kWhiteish,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                subjects[int.parse(question.subject)].path,
                width: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.title,
                    style: GoogleFonts.sarala(fontSize: 25, color: kBlackish),
                  ),
                  Text(
                    question.description,
                    style: GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
                  ),
                  Text(
                    "Number of Answers == " +
                        question.answers.length.toString(),
                    style: GoogleFonts.sarala(
                        fontSize: 13, color: kColorScheme[4]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
