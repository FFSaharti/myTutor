import 'package:flutter/material.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

class QuestionAnswersScreenStudent extends StatefulWidget {
  static String id = 'question_answers_page_screen_student';
  final Question question;
  String tutorID = '';

  QuestionAnswersScreenStudent(this.question);

  @override
  _QuestionAnswersScreenStudentState createState() =>
      _QuestionAnswersScreenStudentState(this.question);
}

class _QuestionAnswersScreenStudentState
    extends State<QuestionAnswersScreenStudent> {
  List<Tutor> tutorsAnswers = [];
  bool finish = false;

  _QuestionAnswersScreenStudentState(this.question);

  @override
  final Question question;

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
          question.title + " Answers",
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
                Text("Answers --> "),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Column(
                    children: getAnswers(question.answers),
                  ),
                ),
                // Column(
                //   children: [
                //     SizedBox(
                //       height: 15,
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getAnswers(List<Answer> answers) {
    List<Widget> widgets = [];

    for (int i = 0; i < answers.length; i++) {
      widgets.add(AnswerWidget(widget: widget, answer: answers[i]));
      widgets.add(
        SizedBox(
          height: 15,
        ),
      );
    }

    return widgets;
  }
}

class AnswerWidget extends StatefulWidget {
  const AnswerWidget({
    Key key,
    @required this.widget,
    @required this.answer,
  }) : super(key: key);

  final QuestionAnswersScreenStudent widget;
  final Answer answer;

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  bool finish = false;

  void initState() {
    setState(() {
      finish = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width * 0.7,
      height: ScreenSize.width * 0.2,
      decoration: BoxDecoration(
          color: kWhiteish, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          !finish
              ? Text("Loading Tutor...")
              : Text("Answered By : " + widget.answer.tutor.name),
          SizedBox(
            height: 30,
          ),
          Text("Answer : " + widget.answer.answer),
        ],
      ),
    );
  }
}
