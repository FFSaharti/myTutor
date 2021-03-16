import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/screens/student_screens/view_answer_screen.dart';
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
  bool finish = false;
  TextEditingController _searchController = TextEditingController();

  _QuestionAnswersScreenStudentState(this.question);

  List<Answer> searchedAnswers;

  @override
  final Question question;

  void applySearch(String searchValue) {
    setState(() {
      if (searchValue == '' || searchValue.isEmpty) {
        searchedAnswers = widget.question.answers;
      } else {
        searchedAnswers = widget.question.answers
            .where((answer) => answer.tutor.name.contains(searchValue))
            .toList();
      }
    });
  }

  @override
  void initState() {
    searchedAnswers = widget.question.answers;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(
            context, Theme.of(context).accentColor, "Question Answers"),
        body: SafeArea(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  ListTile(
                    title: TextField(
                      style: TextStyle(color: Theme.of(context).accentColor),
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          applySearch(_searchController.text);
                        });
                      },
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        fillColor: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.6),
                        filled: true,
                        hintText: 'Search By Tutor Name',
                        hintStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        prefixIcon: Icon(Icons.search,
                            color: Theme.of(context).accentColor),
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
                    child: Column(
                      children: getAnswers(searchedAnswers),
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

  List<Widget> getAnswers(List<Answer> answers) {
    List<Widget> widgets = [];

    for (int i = 0; i < answers.length; i++) {
      widgets.add(GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewAnswerScreen(answers[i], this.widget)),
          );
        },
        child: AnswerWidget(widget: widget, answer: answers[i]),
      ));
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: ScreenSize.height * 0.15,
        width: ScreenSize.width * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.3),
          //     spreadRadius: 1,
          //     blurRadius: 15,
          //     offset: Offset(0, 6), // changes position of shadow
          //   ),
          // ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: ScreenSize.width * 0.2,
                height: ScreenSize.height * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(widget.answer.tutor.profileImag),
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                width: ScreenSize.width * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenSize.height * 0.05,
                    child: Text(
                      widget.answer.tutor.name,
                      style: GoogleFonts.sen(
                          fontSize: 25, color: Theme.of(context).buttonColor),
                    ),
                  ),
                  Container(
                    height: ScreenSize.height * 0.027,
                    child: Text(
                      widget.answer.answer,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: GoogleFonts.sen(
                          fontSize: 14, color: Theme.of(context).buttonColor),
                    ),
                  ),
                  Container(
                    height: ScreenSize.height * 0.024,
                    child: Row(
                      children: [
                        SizedBox(
                          width: ScreenSize.width * 0.4,
                        ),
                        Text(
                          widget.answer.date,
                          style: GoogleFonts.sen(
                              fontSize: 13,
                              color: Theme.of(context).buttonColor),
                        ),
                      ],
                    ),
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
