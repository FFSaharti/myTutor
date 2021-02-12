import 'package:flutter/material.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/utilities/constants.dart';

class QuestionAnswersScreenStudent extends StatefulWidget {
  static String id = 'question_answers_page_screen_student';
  double height;
  double width;
  final Question question;

  QuestionAnswersScreenStudent(this.question);

  @override
  _QuestionAnswersScreenStudentState createState() =>
      _QuestionAnswersScreenStudentState(this.question);
}

class _QuestionAnswersScreenStudentState
    extends State<QuestionAnswersScreenStudent> {
  _QuestionAnswersScreenStudentState(this.question);

  final Question question;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widget.width = mediaQueryData.size.width;
    widget.height = mediaQueryData.size.height;
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

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({
    Key key,
    @required this.widget,
    @required this.answer,
  }) : super(key: key);

  final QuestionAnswersScreenStudent widget;
  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.7,
      height: widget.height * 0.2,
      decoration: BoxDecoration(
          color: kWhiteish, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Answered By : " + answer.tutor.name),
          SizedBox(
            height: 30,
          ),
          Text("Answer : " + answer.answer),
        ],
      ),
    );
  }
}
