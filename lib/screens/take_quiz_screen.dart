import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/quiz_question.dart';
import 'package:mytutor/components/ez_button.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: ScreenSize.height,
          child: Column(
            children: [
              SizedBox(
                height: ScreenSize.height * 0.03,
              ),
              Center(
                child: Text(
                  finish ? ("Quiz : " + widget.quiz.title) : "Loading",
                  style:
                      kTitleStyle.copyWith(color: Colors.black, fontSize: 30),
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.01,
              ),
              SizedBox(
                height: ScreenSize.height * 0.1,
              ),
              Container(
                height: ScreenSize.height * 0.5,
                width: ScreenSize.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                //color: Colors.white,
                child: PageView(
                  controller: _pageController,
                  children: finish
                      ? getListOfQuestions(widget.quiz)
                      : [
                          // Center(
                          //     child: Text(
                          //   "Loading Questions",
                          //   style: kTitleStyle.copyWith(
                          //       fontSize: 25, color: Colors.black),
                          // ))
                        ],
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
                height: ScreenSize.height * 0.02,
              ),
              EZButton(
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
                    title: "Completed Quiz [" + widget.quiz.title + "]",
                    desc: "You got " +
                        numOfCorrectAnswers.toString() +
                        " out of " +
                        widget.quiz.questions.length.toString(),
                    // body: Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Center(
                    //     child: Text(
                    //       'quiz updated',
                    //       style: kTitleStyle.copyWith(
                    //           color: kBlackish,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.normal),
                    //     ),
                    //   ),
                    // ),
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
      widgets.add(QuizQuestionWidget(quiz.questions[i], i, groupValues));
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

  QuizQuestionWidget(this.question, this.questionIndex, this.groupValue);

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
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.02,
          ),
          Text(
            widget.question.question,
            style: kTitleStyle.copyWith(fontSize: 25, color: Colors.black),
          ),
          Column(
            children: getListOfAnswers(widget.question, setQuestionState),
          )
        ],
      ),
    );
  }

  List<Widget> getListOfAnswers(
      QuizQuestion question, Function setQuestionState) {
    List<Widget> widgets = [];

    for (int k = 0; k < question.answers.length; k++) {
      widgets.add(
        Row(
          children: [
            Radio(
              onChanged: (value) {
                setState(() {
                  widget.groupValue[widget.questionIndex] = value;
                });
                setQuestionState();
              },
              value: k,
              groupValue: widget.groupValue[widget.questionIndex],
            ),
            Text(widget.question.answers[k])
          ],
        ),
      );
    }

    return widgets;
  }
}
