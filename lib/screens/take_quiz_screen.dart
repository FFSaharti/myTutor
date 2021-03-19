import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/quiz_question.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TakeQuizScreen extends StatefulWidget {
  Quiz quiz;
  final String quizID;

  TakeQuizScreen(this.quiz, this.quizID);

  @override
  _TakeQuizScreenState createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  List<QuizQuestion> tempQuizQuestions = [];
  List<String> tempAnswers = [];
  bool finish = false;
  PageController _pageController = PageController();
  int numOfCorrectAnswers = 0;
  List<int> groupValues = [];

  @override
  void initState() {
    widget.quiz = Quiz(SessionManager.loggedInTutor.userId, 2,
        widget.quiz.subjectID, widget.quiz.title, widget.quiz.quizDesc, '');
    DatabaseAPI.fetchQuiz(widget.quizID).then((value) => {
          print("VALUE OF value is --> " + value.toString()),
          widget.quiz.doc_id = value.id,
          widget.quiz.quizTitle = value.data()["quizTitle"],
          widget.quiz.quizDesc = value.data()["quizDesc"],
          widget.quiz.subjectID = value.data()["subject"],
          List.from(value.data()["listOfQuestions"]).forEach((question) {
            tempAnswers.clear();
            QuizQuestion tempQuizQ;
            DatabaseAPI.fetchQuestion(question).then((questionBack) => {
                  tempQuizQ = QuizQuestion(
                      questionBack.data()["questionTitle"], questionBack.id),
                  print("QUESTION ID IS --> " + questionBack.id),
                  tempQuizQ.correctAnswerIndex =
                      questionBack.data()["correctAnswerIndex"],
                  List.from(questionBack.data()["answers"]).forEach(
                    (answer) {
                      tempQuizQ.answers.add(answer);
                      setState(() {
                        finish = true;
                      });
                    },
                  ),
                  widget.quiz.questions.add(tempQuizQ),
                });

            // setState(() {
            //   finish = true;
            // });
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: buildAppBar(context, Theme.of(context).accentColor,
            finish ? ("Quiz : " + widget.quiz.title) : "Loading"),
        body: Container(
          height: ScreenSize.height,
          child: Column(
            children: [
              SizedBox(
                height: ScreenSize.height * 0.1,
              ),
              Center(
                child: Container(
                  height: ScreenSize.height * 0.5,
                  width: ScreenSize.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  //color: Colors.white,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: PageView(
                      controller: _pageController,
                      children: finish
                          ? getListOfQuestions(widget.quiz)
                          : [
                              Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              )
                            ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.01,
              ),
              Container(
                height: ScreenSize.height * 0.05,
                child: finish
                    ? SmoothPageIndicator(
                        controller: _pageController, // PageController
                        count: widget.quiz.questions.length,
                        effect: JumpingDotEffect(
                            dotColor: kGreyish,
                            activeDotColor:
                                kColorScheme[2]), // your preferred effect
                        onDotClicked: (index) {})
                    : Container(),
              ),
              SizedBox(
                height: ScreenSize.height * 0.1,
              ),
              CircularButton(
                width: ScreenSize.width * 0.5,
                buttonColor: Colors.white,
                textColor: Colors.white,
                isGradient: true,
                colors: [kColorScheme[0], kColorScheme[2], kColorScheme[3]],
                buttonText: "See Results",
                hasBorder: false,
                borderColor: null,
                onPressed: () {
                  calculateNumOfCorrectAnswers(groupValues);
                  print("NUMBER OF CORRECT ANSWERS IS --> " +
                      numOfCorrectAnswers.toString());
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.SUCCES,
                    body: Center(
                      child: Column(
                        children: [
                          Text(
                            "Completed Quiz [" + widget.quiz.title + "]",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).buttonColor,
                                fontSize: 23,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.01,
                          ),
                          Text(
                            "You got " +
                                numOfCorrectAnswers.toString() +
                                " out of " +
                                widget.quiz.questions.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).buttonColor,
                                fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    btnOkOnPress: () {
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 1;
                      });
                    },
                  ).show();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getListOfQuestions(Quiz quiz) {
    List<Widget> widgets = [];
    for (int i = 0; i < quiz.questions.length; i++) {
      groupValues.add(0);
      widgets.add(QuizQuestionWidget(
          quiz.questions[i], i, groupValues, quiz.questions.length.toString()));
    }

    return widgets;
  }

  void calculateNumOfCorrectAnswers(List<int> groupValues) {
    numOfCorrectAnswers = 0;
    print("GROUP VALUE IS --> " + groupValues.toString());
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      if (groupValues[i] == widget.quiz.questions[i].correctAnswerIndex) {
        numOfCorrectAnswers++;
      }
    }
  }
}

class QuizQuestionWidget extends StatefulWidget {
  final QuizQuestion question;
  final questionIndex;
  List<int> groupValue;
  final numOfQuestions;

  QuizQuestionWidget(
      this.question, this.questionIndex, this.groupValue, this.numOfQuestions);

  @override
  _QuizQuestionWidgetState createState() => _QuizQuestionWidgetState();
}

class _QuizQuestionWidgetState extends State<QuizQuestionWidget> {
  Function setQuestionState() {
    setState(() {
      print("GROUP VALUE INSIDE QUESTION WIDGET --> " +
          widget.groupValue.toString());
    });
  }

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Theme.of(context).buttonColor
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            Text(
              "Question " +
                  (widget.questionIndex + 1).toString() +
                  " out of " +
                  widget.numOfQuestions,
              style: GoogleFonts.sen(
                  fontSize: 17, color: Theme.of(context).buttonColor),
            ),
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.question.question,
                  style: kTitleStyle.copyWith(
                      fontSize: 40, color: Theme.of(context).buttonColor),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            Column(
              children: getListOfAnswers(widget.question, setQuestionState),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getListOfAnswers(
      QuizQuestion question, Function setQuestionState) {
    List<Widget> widgets = [];

    for (int k = 0; k < question.answers.length; k++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.groupValue[widget.questionIndex] = k;
              });
              setQuestionState();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(20),
              ),
              color: widget.groupValue[widget.questionIndex] == k
                  ? kColorScheme[1]
                  : kWhiteish,
              elevation: 0,
              child: Container(
                width: ScreenSize.width * 0.85,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.question.answers[k],
                    style: GoogleFonts.sen(
                        fontSize: 20,
                        color: widget.groupValue[widget.questionIndex] == k
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }
}

// Radio(
// onChanged: (value) {
// setState(() {
// widget.groupValue[widget.questionIndex] = value;
// });
// setQuestionState();
// },
// value: k,
// groupValue: widget.groupValue[widget.questionIndex],
// ),
