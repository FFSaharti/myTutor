import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/screens/student_screens/view_answer_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
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
  int from = 0;
  int to = 200;

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
                  StreamBuilder<QuerySnapshot>(
                    stream: DatabaseAPI.fetchQuestionAnswers(question),
                    builder: (context, snapshot) {
                      // List to fill up with all the session the user has.
                      List<Widget> questionAnswers = [];
                      if (snapshot.hasData) {
                        print(snapshot.data.docs.length);
                        List<QueryDocumentSnapshot> answers =
                            snapshot.data.docs;
                        for (var answer in answers) {
                          questionAnswers.add(AnswerWidget(
                              widget: widget,
                              answer: Answer(answer.data()["answer"], null,
                                  answer.data()["date"])));
                        }
                      }
                      return questionAnswers.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: ScreenSize.height * 0.15,
                                ),
                                Center(
                                  child: Text(
                                    "No Answer for your Question yet!",
                                    style: GoogleFonts.openSans(
                                        color: Theme.of(context).buttonColor,
                                        // Theme.of(context).primaryColor,
                                        fontSize: 21),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            )
                          : Expanded(
                              child: NotificationListener<OverscrollIndicatorNotification>(
                                // ignore: missing_return
                                onNotification: (overscroll) {
                                  overscroll.disallowGlow();
                                },
                                child: ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot myDoc =
                                        snapshot.data.docs[index];
                                    return Column(
                                      children: [
                                        Villain(
                                          villainAnimation:
                                              VillainAnimation.fromBottom(
                                            from: Duration(milliseconds: from),
                                            to: Duration(milliseconds: to),
                                          ),
                                          child: FutureBuilder(
                                            future:
                                                DatabaseAPI.getStreamOfUserbyId(
                                                    myDoc.data()["Tutor"], 0),
                                            builder:
                                                (context, AsyncSnapshot snap) {
                                              if (snap.hasData) {
                                                Answer currentAnswer = Answer(
                                                    myDoc.data()["answer"],
                                                    Tutor(
                                                        snap.data["name"],
                                                        "email",
                                                        "pass",
                                                        "aboutMe",
                                                        "userid",
                                                        [],
                                                        snap.data["profileImg"]),
                                                    myDoc.data()["date"]);
                                                return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ViewAnswerScreen(
                                                                    currentAnswer,
                                                                    this.widget)),
                                                      );
                                                    },
                                                    child: AnswerWidget(
                                                        widget: widget,
                                                        answer: currentAnswer));
                                              }
                                              from += 100;
                                              to += 100;
                                              return Text("");
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                    },
                  ),
                  // Container(
                  //   child: Column(
                  //     children: getAnswers(searchedAnswers),
                  //   ),
                  // ),
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
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.answer.tutor.profileImag == ""
                  ? Icon(
                      Icons.account_circle_sharp,
                      size: ScreenSize.height * 0.080,
                    )
                  : Container(
                      width: ScreenSize.width * 0.2,
                      height: ScreenSize.height * 0.25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image:
                                NetworkImage(widget.answer.tutor.profileImag),
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
