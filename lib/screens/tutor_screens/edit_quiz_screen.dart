import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/quiz_question.dart';
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
          print("VALUE OF value is --> " + value.toString()),
          tempQuiz.quizTitle = value.data()["quizTitle"],
          tempQuiz.quizDesc = value.data()["quizDesc"],
          tempQuiz.subjectID = value.data()["subject"],
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(
          context,
          kColorScheme[3],
          "Edit" + (!finish ? " Loading" : " [" + tempQuiz.quizTitle + "]"),
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
                            style: kTitleStyle.copyWith(
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
                                              style: kTitleStyle.copyWith(
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
                              style: kTitleStyle.copyWith(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 17),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  showAddNewQuestion(setParentState);
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline),
                                ),
                              ),
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
                              style: GoogleFonts.sarabun(
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
                        'quiz updated',
                        style: kTitleStyle.copyWith(
                            color: kBlackish,
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
                        style: kTitleStyle.copyWith(
                            color: kBlackish,
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
    int answersCounter = 0;
    int correctAnswer = -1;

    bool getCorrectAnswers() {
      if (answersCounter == 2) {
        return answerOneController.text.isNotEmpty &&
            answerTwoController.text.isNotEmpty;
      }
      if (answersCounter == 3) {
        return answerOneController.text.isNotEmpty &&
            answerTwoController.text.isNotEmpty &&
            answerThreeController.text.isNotEmpty;
      }
      if (answersCounter == 4) {
        return answerOneController.text.isNotEmpty &&
            answerTwoController.text.isNotEmpty &&
            answerThreeController.text.isNotEmpty &&
            answerFourController.text.isNotEmpty;
      }
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
                            "Add New Question",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).buttonColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              // ADD NEW QUESTION
                              if (questionTitleController.text.isNotEmpty &&
                                  getCorrectAnswers() &&
                                  correctAnswer != -1 &&
                                  answersCounter >= 2) {
                                print("POP...");
                                // Fluttertoast.showToast(
                                //     msg: "Question Added");
                                tempQuestion = createQuestion(
                                    questionTitleController.text,
                                    answerOneController.text,
                                    answerTwoController.text,
                                    answerThreeController.text,
                                    answerFourController.text,
                                    correctAnswer,
                                    null);
                                setParentState;
                                setParentState(tempQuestion, -1);
                                Navigator.pop(context);
                              } else {
                                print("invalid parameters");
                                //TODO: Show error message cannot leave empty...
                                Fluttertoast.showToast(
                                    msg:
                                        "Please fill all the nessecary information");
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Question Title",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).buttonColor)),
                              ),
                            ),
                            TextField(
                              controller: questionTitleController,
                              style: TextStyle(
                                  color: Theme.of(context).buttonColor),
                              decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: TextStyle(
                                    fontSize: 17.0,
                                    color: Theme.of(context)
                                        .buttonColor
                                        .withOpacity(0.6)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            (answersCounter < 1)
                                ? Row(
                                    children: [
                                      Text(
                                        "Answer",
                                        style: kTitleStyle.copyWith(
                                            color:
                                                Theme.of(context).buttonColor,
                                            fontSize: 17),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // ADD ANSWER
                                            print("pressed add answer ==> " +
                                                answersCounter.toString() +
                                                "  showAddAnswer[0] is ==> " +
                                                showAddAnswer[0].toString());
                                            setModalState(() {
                                              answersCounter++;
                                              showAddAnswer[1] = true;
                                            });
                                          },
                                          child: Container(
                                            child:
                                                Icon(Icons.add_circle_outline),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : (showAddAnswer[0])
                                    ? Container(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: TextField(
                                                controller: answerOneController,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .buttonColor),
                                                decoration: InputDecoration(
                                                  hintText: 'Type Answer...',
                                                  hintStyle: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Theme.of(context)
                                                          .buttonColor
                                                          .withOpacity(0.6)),
                                                ),
                                              ),
                                              trailing: (correctAnswer == 1)
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {})
                                                  : IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        setModalState(() {
                                                          correctAnswer = 1;
                                                        });
                                                      }),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            (answersCounter < 2)
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        "Answer",
                                                        style: kTitleStyle
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .buttonColor,
                                                                fontSize: 17),
                                                      ),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 12.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // ADD ANSWER
                                                            print(
                                                                "pressed add answer");
                                                            setModalState(() {
                                                              answersCounter++;
                                                              showAddAnswer[2] =
                                                                  true;
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Icon(Icons
                                                                .add_circle_outline),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : (showAddAnswer[1])
                                                    ? Container(
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              title: TextField(
                                                                controller:
                                                                    answerTwoController,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .buttonColor),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Type Answer...',
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          17.0,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .buttonColor
                                                                          .withOpacity(
                                                                              0.6)),
                                                                ),
                                                              ),
                                                              trailing: (correctAnswer ==
                                                                      2)
                                                                  ? IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      onPressed:
                                                                          () {})
                                                                  : IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        setModalState(
                                                                            () {
                                                                          correctAnswer =
                                                                              2;
                                                                        });
                                                                      }),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            // NEW QUESTON HERE
                                                            (answersCounter < 3)
                                                                ? Row(
                                                                    children: [
                                                                      Text(
                                                                        "Answer",
                                                                        style: kTitleStyle.copyWith(
                                                                            color:
                                                                                Theme.of(context).buttonColor,
                                                                            fontSize: 17),
                                                                      ),
                                                                      Spacer(),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 12.0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // ADD ANSWER
                                                                            print("pressed add answer");
                                                                            setModalState(() {
                                                                              answersCounter++;
                                                                              showAddAnswer[2] = true;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Icon(Icons.add_circle_outline),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : (showAddAnswer[
                                                                        2])
                                                                    ? Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            ListTile(
                                                                              title: TextField(
                                                                                controller: answerThreeController,
                                                                                style: TextStyle(color: Theme.of(context).buttonColor),
                                                                                decoration: InputDecoration(
                                                                                  hintText: 'Type Answer...',
                                                                                  hintStyle: TextStyle(fontSize: 17.0, color: Theme.of(context).buttonColor.withOpacity(0.6)),
                                                                                ),
                                                                              ),
                                                                              trailing: (correctAnswer == 3)
                                                                                  ? IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.check,
                                                                                        color: Colors.green,
                                                                                      ),
                                                                                      onPressed: () {})
                                                                                  : IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.cancel,
                                                                                        color: Colors.red,
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        setModalState(() {
                                                                                          correctAnswer = 3;
                                                                                        });
                                                                                      }),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            // NEW QUESTON HERE
                                                                            (answersCounter < 4)
                                                                                ? Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "Answer",
                                                                                        style: kTitleStyle.copyWith(color: Theme.of(context).buttonColor, fontSize: 17),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(right: 12.0),
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            // ADD ANSWER
                                                                                            print("pressed add answer");
                                                                                            setModalState(() {
                                                                                              answersCounter++;
                                                                                              showAddAnswer[3] = true;
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            child: Icon(Icons.add_circle_outline),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : (showAddAnswer[3])
                                                                                    ? Container(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            ListTile(
                                                                                              title: TextField(
                                                                                                controller: answerFourController,
                                                                                                style: TextStyle(color: Theme.of(context).buttonColor),
                                                                                                decoration: InputDecoration(
                                                                                                  hintText: 'Type Answer...',
                                                                                                  hintStyle: TextStyle(fontSize: 17.0, color: Theme.of(context).buttonColor.withOpacity(0.6)),
                                                                                                ),
                                                                                              ),
                                                                                              trailing: (correctAnswer == 4)
                                                                                                  ? IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.check,
                                                                                                        color: Colors.green,
                                                                                                      ),
                                                                                                      onPressed: () {})
                                                                                                  : IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.cancel,
                                                                                                        color: Colors.red,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setModalState(() {
                                                                                                          correctAnswer = 4;
                                                                                                        });
                                                                                                      }),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 15,
                                                                                            ),
                                                                                            // NEW QUESTON HERE
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

  List<Widget> getListOfQuizQuestions(Quiz tempQuiz) {
    List<Widget> widgets = [];

    for (int i = 0; i < tempQuiz.questions.length; i++) {
      widgets.add(
        Row(
          children: [
            Text(
              tempQuiz.questions[i].question,
              style: kTitleStyle.copyWith(
                  color: Theme.of(context).buttonColor, fontSize: 17),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                print("clicked edit question");
                //showAddNewQuestion(setParentState);
                showEditQuestion(setParentState, tempQuiz.questions[i], i);
              },
              child: Icon(
                Icons.edit,
                size: 15,
              ),
            )
          ],
        ),
      );
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
    int answersCounter = tempQuestion.answers.length;
    print("answers counter is --> " + answersCounter.toString());
    for (int i = 0; i < tempQuestion.answers.length; i++) {
      showAddAnswer[i] = true;
      print("ANSWER " + i.toString() + " is --> " + tempQuestion.answers[i]);
    }

    bool getCorrectAnswers() {
      if (answersCounter == 2) {
        bool edited = true;
        if (tempQuestion.answers.length >= 2) {
          edited = tempQuestion.answers[0].isNotEmpty &&
              tempQuestion.answers[1].isNotEmpty;
        }

        return answerOneController.text.isNotEmpty &&
                answerTwoController.text.isNotEmpty ||
            edited;
      }
      if (answersCounter == 3) {
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
      if (answersCounter == 4) {
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
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).buttonColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              // EDIT QUESTION
                              if (getCorrectAnswers() &&
                                  tempQuestion.correctAnswerIndex != -1 &&
                                  answersCounter >= 2) {
                                print("POP...");
                                // String questionTitlePass = '';
                                // String answerOnePass = '';
                                // String answerTwoPass = '';
                                // String answerThreePass = '';
                                // String answerFourPass = '';
                                tempQuestion = createQuestion(
                                    questionTitleController.text,
                                    answerOneController.text,
                                    answerTwoController.text,
                                    answerThreeController.text,
                                    answerFourController.text,
                                    tempQuestion.correctAnswerIndex,
                                    tempQuestion);
                                setParentState;
                                setParentState(tempQuestion, index);
                                Navigator.pop(context);
                              } else {
                                print("invalid parameters");
                                //TODO: Show error message cannot leave empty...
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Question Title",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).buttonColor)),
                              ),
                            ),
                            TextField(
                              controller: questionTitleController,
                              style: TextStyle(
                                  color: Theme.of(context).buttonColor),
                              decoration: InputDecoration(
                                hintText: tempQuestion.question,
                                hintStyle: TextStyle(
                                    fontSize: 17.0,
                                    color: Theme.of(context).buttonColor),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            (answersCounter < 1)
                                ? Row(
                                    children: [
                                      Text(
                                        "Answer",
                                        style: kTitleStyle.copyWith(
                                            color:
                                                Theme.of(context).buttonColor,
                                            fontSize: 17),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 12.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // ADD ANSWER
                                            print("pressed add answer ==> " +
                                                answersCounter.toString() +
                                                "  showAddAnswer[0] is ==> " +
                                                showAddAnswer[0].toString());
                                            setModalState(() {
                                              answersCounter++;
                                              showAddAnswer[1] = true;
                                            });
                                          },
                                          child: Container(
                                            child:
                                                Icon(Icons.add_circle_outline),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : (showAddAnswer[0])
                                    ? Container(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: TextField(
                                                controller: answerOneController,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .buttonColor),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      tempQuestion.answers[0],
                                                  hintStyle: TextStyle(
                                                      fontSize: 17.0,
                                                      color: Theme.of(context)
                                                          .buttonColor
                                                          .withOpacity(0.6)),
                                                ),
                                              ),
                                              trailing: (tempQuestion
                                                          .correctAnswerIndex ==
                                                      (1 - 1))
                                                  ? IconButton(
                                                      icon: Icon(
                                                        Icons.check,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {})
                                                  : IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () {
                                                        setModalState(() {
                                                          tempQuestion
                                                              .correctAnswerIndex = 0;
                                                        });
                                                      }),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            (answersCounter < 2)
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        "Answer",
                                                        style: kTitleStyle
                                                            .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .buttonColor,
                                                                fontSize: 17),
                                                      ),
                                                      Spacer(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 12.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            // ADD ANSWER
                                                            print(
                                                                "pressed add answer");
                                                            setModalState(() {
                                                              answersCounter++;
                                                              showAddAnswer[2] =
                                                                  true;
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Icon(Icons
                                                                .add_circle_outline),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : (showAddAnswer[1])
                                                    ? Container(
                                                        child: Column(
                                                          children: [
                                                            ListTile(
                                                              title: TextField(
                                                                controller:
                                                                    answerTwoController,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .buttonColor),
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      tempQuestion
                                                                          .answers[0],
                                                                  hintStyle: TextStyle(
                                                                      fontSize:
                                                                          17.0,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .buttonColor
                                                                          .withOpacity(
                                                                              0.6)),
                                                                ),
                                                              ),
                                                              trailing: (tempQuestion
                                                                          .correctAnswerIndex ==
                                                                      2 - 1)
                                                                  ? IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .check,
                                                                        color: Colors
                                                                            .green,
                                                                      ),
                                                                      onPressed:
                                                                          () {})
                                                                  : IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        setModalState(
                                                                            () {
                                                                          tempQuestion.correctAnswerIndex =
                                                                              2 - 1;
                                                                        });
                                                                      }),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            // NEW QUESTON HERE
                                                            (answersCounter < 3)
                                                                ? Row(
                                                                    children: [
                                                                      Text(
                                                                        "Answer",
                                                                        style: kTitleStyle.copyWith(
                                                                            color:
                                                                                Theme.of(context).buttonColor,
                                                                            fontSize: 17),
                                                                      ),
                                                                      Spacer(),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 12.0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            // ADD ANSWER
                                                                            print("pressed add answer");
                                                                            setModalState(() {
                                                                              answersCounter++;
                                                                              showAddAnswer[2] = true;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Icon(Icons.add_circle_outline),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : (showAddAnswer[
                                                                        2])
                                                                    ? Container(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            ListTile(
                                                                              title: TextField(
                                                                                controller: answerThreeController,
                                                                                style: TextStyle(color: Theme.of(context).buttonColor),
                                                                                decoration: InputDecoration(
                                                                                  hintText: tempQuestion.answers.length > 2 ? tempQuestion.answers[2] : 'Type Answer...',
                                                                                  hintStyle: TextStyle(fontSize: 17.0, color: Theme.of(context).buttonColor.withOpacity(0.6)),
                                                                                ),
                                                                              ),
                                                                              trailing: (tempQuestion.correctAnswerIndex == 3 - 1)
                                                                                  ? IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.check,
                                                                                        color: Colors.green,
                                                                                      ),
                                                                                      onPressed: () {})
                                                                                  : IconButton(
                                                                                      icon: Icon(
                                                                                        Icons.cancel,
                                                                                        color: Colors.red,
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        setModalState(() {
                                                                                          tempQuestion.correctAnswerIndex = 3 - 1;
                                                                                        });
                                                                                      }),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            // NEW QUESTON HERE
                                                                            (answersCounter < 4)
                                                                                ? Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        "Answer",
                                                                                        style: kTitleStyle.copyWith(color: Theme.of(context).buttonColor, fontSize: 17),
                                                                                      ),
                                                                                      Spacer(),
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(right: 12.0),
                                                                                        child: GestureDetector(
                                                                                          onTap: () {
                                                                                            // ADD ANSWER
                                                                                            print("pressed add answer");
                                                                                            setModalState(() {
                                                                                              answersCounter++;
                                                                                              showAddAnswer[3] = true;
                                                                                            });
                                                                                          },
                                                                                          child: Container(
                                                                                            child: Icon(Icons.add_circle_outline),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : (showAddAnswer[3])
                                                                                    ? Container(
                                                                                        child: Column(
                                                                                          children: [
                                                                                            ListTile(
                                                                                              title: TextField(
                                                                                                controller: answerFourController,
                                                                                                style: TextStyle(color: Theme.of(context).buttonColor),
                                                                                                decoration: InputDecoration(
                                                                                                  hintText: tempQuestion.answers.length > 3 ? tempQuestion.answers[3] : 'Type Answer...',
                                                                                                  hintStyle: TextStyle(fontSize: 17.0, color: Theme.of(context).buttonColor.withOpacity(0.6)),
                                                                                                ),
                                                                                              ),
                                                                                              trailing: (tempQuestion.correctAnswerIndex == 4 - 1)
                                                                                                  ? IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.check,
                                                                                                        color: Colors.green,
                                                                                                      ),
                                                                                                      onPressed: () {})
                                                                                                  : IconButton(
                                                                                                      icon: Icon(
                                                                                                        Icons.cancel,
                                                                                                        color: Colors.red,
                                                                                                      ),
                                                                                                      onPressed: () {
                                                                                                        setModalState(() {
                                                                                                          tempQuestion.correctAnswerIndex = 4 - 1;
                                                                                                        });
                                                                                                      }),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              height: 15,
                                                                                            ),
                                                                                            // NEW QUESTON HERE
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
