import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/quiz_question.dart';
import 'package:mytutor/components/add_answer_prompt.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/components/type_answer_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class EditQuizScreen extends StatefulWidget {
  static String id = "create_materials_screen";
  final String quizID;

  EditQuizScreen({this.quizID});

  @override
  _EditQuizScreenState createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  // QUIZ STUFF -
  Quiz tempQuiz = Quiz(SessionManager.loggedInTutor.userId, 2, -1, '', '', '');
  List<QuizQuestion> tempQuizQuestions = [];
  List<String> tempAnswers = [];

  void setParentState(QuizQuestion tempQuestion, int index) {
    setState(() {
      if (index == -1)
        tempQuiz.addQuestion(tempQuestion);
      else {
        tempQuiz.questions[index] = tempQuestion;
      }
    });
  }

  bool finish = false;

  @override
  void initState() {
    DatabaseAPI.fetchQuiz(widget.quizID).then((value) => {
          tempQuiz.quizTitle = value.data()["quizTitle"],
          tempQuiz.quizDesc = value.data()["quizDesc"],
          tempQuiz.subjectID = value.data()["subject"],
          List.from(value.data()["listOfQuestions"]).forEach((question) {
            tempAnswers.clear();
            QuizQuestion tempQuizQ;
            DatabaseAPI.fetchQuestion(question).then((questionBack) => {
                  tempQuizQ = QuizQuestion(
                      questionBack.data()["questionTitle"], questionBack.id),
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
                  tempQuiz.questions.add(tempQuizQ),
                });

            setState(() {
              finish = true;
            });
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return DisableDefaultPop(
      child: Scaffold(
        appBar: buildAppBar(
          context,
          kColorScheme[3],
          "Edit" + (!finish ? " Loading" : " [ " + tempQuiz.quizTitle + " ]"),
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    // QUIZ IS HERE...
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "List Of Questions : ",
                            style: GoogleFonts.sen(
                                color: Theme.of(context).buttonColor,
                                fontSize: 15),
                          ),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.02,
                        ),
                        Container(
                          height: ScreenSize.height * 0.3,
                          child: NotificationListener<
                              OverscrollIndicatorNotification>(
                            onNotification: (overscroll) {
                              overscroll.disallowGlow();
                            },
                            child: ListView(
                              children: [
                                Container(
                                  child: Column(
                                    children: finish
                                        ? getListOfQuizQuestions(tempQuiz)
                                        : [
                                            Text(
                                              "Loading ",
                                              style: GoogleFonts.sen(
                                                  color: Theme.of(context)
                                                      .buttonColor,
                                                  fontSize: 15),
                                            )
                                          ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Question",
                              style: GoogleFonts.sen(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 17),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                showAddNewQuestion(setParentState);
                              },
                              child: Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                        Spacer(),
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              updateQuiz();
                            },
                            child: Text(
                              "Update Quiz",
                              style: GoogleFonts.sen(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                            color: kColorScheme[2],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // CREATE QUIZ
  void updateQuiz() {
    DatabaseAPI.updateQuizQuestions(tempQuiz, widget.quizID).then((value) => {
          value == "done"
              ? AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.SUCCES,
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Quiz Updated',
                        style: GoogleFonts.sen(
                            color: Theme.of(context).buttonColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  btnOkOnPress: () {
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                      return count++ == 2;
                    });
                  },
                ).show()
              : AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.ERROR,
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'ERROR ',
                        style:GoogleFonts.sen(
                            color: Theme.of(context).buttonColor,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  btnOkOnPress: () {
                    Navigator.pop(context);
                  },
                ).show(),
        });
  }

  void showAddNewQuestion(Function setParentState) {
    QuizQuestion tempQuestion = QuizQuestion("", "");

    TextEditingController questionTitleController = TextEditingController();
    TextEditingController answerOneController = TextEditingController();
    TextEditingController answerTwoController = TextEditingController();
    TextEditingController answerThreeController = TextEditingController();
    TextEditingController answerFourController = TextEditingController();
    List<bool> showAddAnswer = [true, false, false, false];
    List<int> answersCounter = [0];
    List<int> correctAnswer = [-1];

    bool getCorrectAnswers() {
      if (answersCounter[0] == 2) {
        return answerOneController.text.isNotEmpty &&
            answerTwoController.text.isNotEmpty;
      }
      if (answersCounter[0] == 3) {
        return answerOneController.text.isNotEmpty &&
            answerTwoController.text.isNotEmpty &&
            answerThreeController.text.isNotEmpty;
      }
      if (answersCounter[0] == 4) {
        return answerOneController.text.isNotEmpty &&
            answerTwoController.text.isNotEmpty &&
            answerThreeController.text.isNotEmpty &&
            answerFourController.text.isNotEmpty;
      }

      return false;
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: ScreenSize.height * 0.95,
              decoration: kCurvedShapeDecoration(
                  Theme.of(context).scaffoldBackgroundColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          Text(
                            "Add New Question",
                            style: GoogleFonts.sen(
                                fontSize: 20,
                                color: Theme.of(context).buttonColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              // ADD NEW QUESTION
                              if (questionTitleController.text.isNotEmpty &&
                                  getCorrectAnswers() &&
                                  correctAnswer[0] != -1 &&
                                  answersCounter[0] >= 2) {
                                print("POP...");
                                tempQuestion = createQuestion(
                                    questionTitleController.text,
                                    answerOneController.text,
                                    answerTwoController.text,
                                    answerThreeController.text,
                                    answerFourController.text,
                                    correctAnswer[0],
                                    null);
                                setParentState(tempQuestion, -1);
                                Fluttertoast.showToast(msg: "Question Created");
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(msg: "Invalid Question");
                              }
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: ScreenSize.height * 0.03,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "Question Title",
                                  style: GoogleFonts.sen(
                                      textStyle: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Theme.of(context).buttonColor)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.01,
                            ),
                            ListTile(
                              title: TextField(
                                controller: questionTitleController,
                                style: GoogleFonts.sen(
                                    color: Theme.of(context).buttonColor),
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: 'Enter Question Title...',
                                  hintStyle: GoogleFonts.sen(
                                      fontSize: 17.0,
                                      color: Theme.of(context)
                                          .buttonColor
                                          .withOpacity(0.75)),
                                ),
                              ),
                            ),
                            Divider(color: Theme.of(context).dividerColor),
                            SizedBox(
                              height: ScreenSize.height * 0.02,
                            ),
                            (answersCounter[0] < 1)
                                ? AddAnswerPrompt(answersCounter, setModalState,
                                    showAddAnswer, 1)
                                : (showAddAnswer[0])
                                    ? Container(
                                        child: Column(
                                          children: [
                                            TypeAnswerWidget(
                                                answerOneController,
                                                correctAnswer,
                                                setModalState,
                                                1),
                                            (answersCounter[0] < 2)
                                                ? AddAnswerPrompt(
                                                    answersCounter,
                                                    setModalState,
                                                    showAddAnswer,
                                                    2)
                                                : (showAddAnswer[1])
                                                    ? Container(
                                                        child: Column(
                                                          children: [
                                                            TypeAnswerWidget(
                                                                answerTwoController,
                                                                correctAnswer,
                                                                setModalState,
                                                                2),
                                                            (answersCounter[0] <
                                                                    3)
                                                                ? AddAnswerPrompt(
                                                                    answersCounter,
                                                                    setModalState,
                                                                    showAddAnswer,
                                                                    2)
                                                                : (showAddAnswer[
                                                                        2])
                                                                    ? Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            TypeAnswerWidget(
                                                                                answerThreeController,
                                                                                correctAnswer,
                                                                                setModalState,
                                                                                3),
                                                                            (answersCounter[0] < 4)
                                                                                ? AddAnswerPrompt(answersCounter, setModalState, showAddAnswer, 3)
                                                                                : (showAddAnswer[3])
                                                                                    ? Container(
                                                                                        child: TypeAnswerWidget(answerFourController, correctAnswer, setModalState, 4),
                                                                                      )
                                                                                    : Container()
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container()
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                          ],
                                        ),
                                      )
                                    : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  List<Widget> getListOfQuizQuestions(Quiz tempQuiz) {
    List<Widget> widgets = [];

    for (int i = 0; i < tempQuiz.questions.length; i++) {
      widgets.add(
        Row(
          children: [
            Text(
              tempQuiz.questions[i].question,
              style: GoogleFonts.sen(
                  color: Theme.of(context).buttonColor, fontSize: 17),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                showEditQuestion(setParentState, tempQuiz.questions[i], i);
              },
              child: Icon(
                Icons.edit,
                size: 18,
              ),
            )
          ],
        ),
      );
      widgets.add(SizedBox(
        height: ScreenSize.height * 0.002,
      ));
      widgets.add(Divider(
        color: Theme.of(context).dividerColor,
      ));
    }

    return widgets;
  }

  QuizQuestion createQuestion(
    String questionTitle,
    String answerOne,
    String answerTwo,
    String answerThree,
    String answerFour,
    int correctAnswer,
    QuizQuestion tempQuestion,
  ) {
    int correctAnswerIndex = correctAnswer;

    QuizQuestion tempQ = QuizQuestion(questionTitle, "");
    tempQ.question = questionTitle;

    tempQ.correctAnswerIndex = correctAnswerIndex;
    if (answerOne.isNotEmpty && answerOne != '') {
      tempQ.addAnswer(answerOne);
    } else if (tempQuestion != null) {
      if (tempQuestion.answers.length >= 1) {
        tempQ.addAnswer(tempQuestion.answers[0]);
      }
    }
    if (answerTwo.isNotEmpty && answerTwo != '') {
      tempQ.addAnswer(answerTwo);
    } else if (tempQuestion != null) {
      if (tempQuestion.answers.length >= 2) {
        tempQ.addAnswer(tempQuestion.answers[1]);
      }
    }
    if (answerThree.isNotEmpty && answerThree != '') {
      tempQ.addAnswer(answerThree);
    } else if (tempQuestion != null) {
      if (tempQuestion.answers.length >= 3) {
        tempQ.addAnswer(tempQuestion.answers[2]);
      }
    }
    if (answerFour.isNotEmpty && answerFour != '') {
      tempQ.addAnswer(answerFour);
    } else if (tempQuestion != null) {
      if (tempQuestion.answers.length >= 4) {
        tempQ.addAnswer(tempQuestion.answers[3]);
      }
    }

    if (tempQuestion != null && questionTitle == '' && questionTitle.isEmpty) {
      tempQ.question = tempQuestion.question;
    }

    return tempQ;
  }

  void showEditQuestion(
      Function setParentState, QuizQuestion tempQuestion, int index) {
    TextEditingController questionTitleController = TextEditingController();
    TextEditingController answerOneController = TextEditingController();
    TextEditingController answerTwoController = TextEditingController();
    TextEditingController answerThreeController = TextEditingController();
    TextEditingController answerFourController = TextEditingController();
    List<bool> showAddAnswer = [true, false, false, false];
    List<int> answersCounter = [tempQuestion.answers.length];

    for (int i = 0; i < tempQuestion.answers.length; i++) {
      showAddAnswer[i] = true;
    }

    bool getCorrectAnswers() {
      if (answersCounter[0] == 2) {
        bool edited = true;
        if (tempQuestion.answers.length >= 2) {
          edited = tempQuestion.answers[0].isNotEmpty &&
              tempQuestion.answers[1].isNotEmpty;
        }

        return answerOneController.text.isNotEmpty &&
                answerTwoController.text.isNotEmpty ||
            edited;
      }
      if (answersCounter[0] == 3) {
        bool edited = true;
        if (tempQuestion.answers.length >= 3) {
          edited = tempQuestion.answers[0].isNotEmpty &&
              tempQuestion.answers[1].isNotEmpty &&
              tempQuestion.answers[2].isNotEmpty;
        }
        return answerOneController.text.isNotEmpty &&
                answerTwoController.text.isNotEmpty &&
                answerThreeController.text.isNotEmpty ||
            edited;
      }
      if (answersCounter[0] == 4) {
        bool edited = true;
        if (tempQuestion.answers.length >= 4) {
          tempQuestion.answers[0].isNotEmpty &&
              tempQuestion.answers[1].isNotEmpty &&
              tempQuestion.answers[2].isNotEmpty &&
              tempQuestion.answers[3].isNotEmpty;
        }
        return answerOneController.text.isNotEmpty &&
                answerTwoController.text.isNotEmpty &&
                answerThreeController.text.isNotEmpty &&
                answerFourController.text.isNotEmpty ||
            edited;
      }

      return false;
    }

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: ScreenSize.height * 0.93,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          Text(
                            "Edit [" + tempQuestion.question + "]",
                            style: GoogleFonts.sen(
                                fontSize: 20,
                                color: Theme.of(context).buttonColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              // EDIT QUESTION
                              if (getCorrectAnswers() &&
                                  tempQuestion.correctAnswerIndex != -1 &&
                                  answersCounter[0] >= 2) {
                                tempQuestion = createQuestion(
                                    questionTitleController.text,
                                    answerOneController.text,
                                    answerTwoController.text,
                                    answerThreeController.text,
                                    answerFourController.text,
                                    tempQuestion.correctAnswerIndex,
                                    tempQuestion);
                                setParentState(tempQuestion, index);
                                Fluttertoast.showToast(msg: "Question Edited");
                                Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(msg: "Invalid Question");
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenSize.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.3),
                                child: Text(
                                  "Question Title",
                                  style: GoogleFonts.sen(
                                      textStyle: TextStyle(
                                          fontSize: 17,
                                          color:
                                              Theme.of(context).buttonColor)),
                                ),
                              ),
                            ),
                            ListTile(
                              title: TextField(
                                controller: questionTitleController,
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor),
                                decoration: InputDecoration(
                                  hintText: tempQuestion.question,
                                  hintStyle: TextStyle(
                                      fontSize: 17.0,
                                      color: Theme.of(context)
                                          .buttonColor
                                          .withOpacity(0.75)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.03,
                            ),
                            (answersCounter[0] < 1)
                                ? AddAnswerPrompt(answersCounter, setModalState,
                                    showAddAnswer, 1)
                                : (showAddAnswer[0])
                                    ? Container(
                                        child: Column(
                                          children: [
                                            TypeAnswerWidget(
                                                answerOneController,
                                                [-1],
                                                setModalState,
                                                1 - 1,
                                                tempQuestion),
                                            (answersCounter[0] < 2)
                                                ? AddAnswerPrompt(
                                                    answersCounter,
                                                    setModalState,
                                                    showAddAnswer,
                                                    2)
                                                : (showAddAnswer[1])
                                                    ? Container(
                                                        child: Column(
                                                          children: [
                                                            TypeAnswerWidget(
                                                                answerTwoController,
                                                                [-1],
                                                                setModalState,
                                                                2 - 1,
                                                                tempQuestion),
                                                            (answersCounter[0] <
                                                                    3)
                                                                ? AddAnswerPrompt(
                                                                    answersCounter,
                                                                    setModalState,
                                                                    showAddAnswer,
                                                                    2)
                                                                : (showAddAnswer[
                                                                        2])
                                                                    ? Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            TypeAnswerWidget(
                                                                                answerThreeController,
                                                                                [
                                                                                  -1
                                                                                ],
                                                                                setModalState,
                                                                                3 - 1,
                                                                                tempQuestion),
                                                                            (answersCounter[0] < 4)
                                                                                ? AddAnswerPrompt(answersCounter, setModalState, showAddAnswer, 3)
                                                                                : (showAddAnswer[3])
                                                                                    ? Container(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            TypeAnswerWidget(answerFourController, [-1], setModalState, 4 - 1, tempQuestion)
                                                                                          ],
                                                                                        ),
                                                                                      )
                                                                                    : Container()
                                                                          ],
                                                                        ),
                                                                      )
                                                                    : Container()
                                                          ],
                                                        ),
                                                      )
                                                    : Container()
                                          ],
                                        ),
                                      )
                                    : Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
