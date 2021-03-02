import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
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
                      SizedBox(
                        height: ScreenSize.height * 0.020,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Edit" +
                              (!finish
                                  ? " Loading"
                                  : " [" + tempQuiz.quizTitle + "]"),
                          style: kTitleStyle.copyWith(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: ScreenSize.height * 0.020,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "List Of Questions : ",
                          style: kTitleStyle.copyWith(
                              color: Colors.black, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: ScreenSize.height * 0.3,
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
                                              color: Colors.black,
                                              fontSize: 15),
                                        )
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Question",
                            style: kTitleStyle.copyWith(
                                color: Colors.black, fontSize: 17),
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
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.vertical(top: Radius.circular(2.0))
            ),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: ScreenSize.height * 0.70,
              child: Scaffold(
                body: Container(
                  //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: ScreenSize.height * 0.70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                      //   topRight: Radius.circular(100),
                      //   topLeft: Radius.circular(100),
                      // )
                      ,
                      color: Colors.white),
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
                                style: TextStyle(fontSize: 20),
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
                                            color: Colors.black)),
                                  ),
                                ),
                                TextField(
                                  controller: questionTitleController,
                                  decoration: InputDecoration(
                                    hintText: 'Type something...',
                                    hintStyle: TextStyle(
                                        fontSize: 17.0, color: Colors.grey),
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
                                                color: Colors.black,
                                                fontSize: 17),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // ADD ANSWER
                                                print("pressed add answer ==> " +
                                                    answersCounter.toString() +
                                                    "  showAddAnswer[0] is ==> " +
                                                    showAddAnswer[0]
                                                        .toString());
                                                setModalState(() {
                                                  answersCounter++;
                                                  showAddAnswer[1] = true;
                                                });
                                              },
                                              child: Container(
                                                child: Icon(
                                                    Icons.add_circle_outline),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : (showAddAnswer[
                                            0]) // TODO: Create widget for creatingQuizQuestionWidget
                                        ? Container(
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      answerOneController,
                                                  decoration: InputDecoration(
                                                    suffixIcon:
                                                        (correctAnswer == 1)
                                                            ? IconButton(
                                                                icon: Icon(Icons
                                                                    .check),
                                                                onPressed:
                                                                    () {})
                                                            : IconButton(
                                                                icon: Icon(Icons
                                                                    .cancel),
                                                                onPressed: () {
                                                                  setModalState(
                                                                      () {
                                                                    correctAnswer =
                                                                        1;
                                                                  });
                                                                }),
                                                    hintText: 'Type Answer...',
                                                    hintStyle: TextStyle(
                                                        fontSize: 17.0,
                                                        color: Colors.grey),
                                                  ),
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
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        17),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right:
                                                                        12.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                // ADD ANSWER
                                                                print(
                                                                    "pressed add answer");
                                                                setModalState(
                                                                    () {
                                                                  answersCounter++;
                                                                  showAddAnswer[
                                                                      2] = true;
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
                                                                TextField(
                                                                  controller:
                                                                      answerTwoController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    hintText:
                                                                        'Type Answer...',
                                                                    suffixIcon: (correctAnswer ==
                                                                            2)
                                                                        ? IconButton(
                                                                            icon: Icon(Icons
                                                                                .check),
                                                                            onPressed:
                                                                                () {})
                                                                        : IconButton(
                                                                            icon:
                                                                                Icon(Icons.cancel),
                                                                            onPressed: () {
                                                                              setModalState(() {
                                                                                correctAnswer = 2;
                                                                              });
                                                                            }),
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            17.0,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                // NEW QUESTON HERE
                                                                (answersCounter <
                                                                        3)
                                                                    ? Row(
                                                                        children: [
                                                                          Text(
                                                                            "Answer",
                                                                            style:
                                                                                kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
                                                                          ),
                                                                          Spacer(),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 12.0),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                // ADD ANSWER
                                                                                print("pressed add answer");
                                                                                setModalState(() {
                                                                                  answersCounter++;
                                                                                  showAddAnswer[2] = true;
                                                                                });
                                                                              },
                                                                              child: Container(
                                                                                child: Icon(Icons.add_circle_outline),
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
                                                                                TextField(
                                                                                  controller: answerThreeController,
                                                                                  decoration: InputDecoration(
                                                                                    hintText: 'Type Answer...',
                                                                                    suffixIcon: (correctAnswer == 3)
                                                                                        ? IconButton(icon: Icon(Icons.check), onPressed: () {})
                                                                                        : IconButton(
                                                                                            icon: Icon(Icons.cancel),
                                                                                            onPressed: () {
                                                                                              setModalState(() {
                                                                                                correctAnswer = 3;
                                                                                              });
                                                                                            }),
                                                                                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                                                                                  ),
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
                                                                                            style: kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
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
                                                                                                TextField(
                                                                                                  controller: answerFourController,
                                                                                                  decoration: InputDecoration(
                                                                                                    hintText: 'Type Answer...',
                                                                                                    suffixIcon: (correctAnswer == 4)
                                                                                                        ? IconButton(icon: Icon(Icons.check), onPressed: () {})
                                                                                                        : IconButton(
                                                                                                            icon: Icon(Icons.cancel),
                                                                                                            onPressed: () {
                                                                                                              setModalState(() {
                                                                                                                correctAnswer = 4;
                                                                                                              });
                                                                                                            }),
                                                                                                    hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                                                                                                  ),
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
                ),
              ),
            );
          });
        });
  }

  List<Widget> getListOfQuizQuestions(Quiz tempQuiz) {
    List<Widget> widgets = [];

    for (int i = 0; i < tempQuiz.questions.length; i++) {
      // TODO : Implement viewing & editing question before creating quiz...
      widgets.add(
        Row(
          children: [
            Text(
              tempQuiz.questions[i].question,
              style: kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
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
        color: Colors.grey,
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
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.vertical(top: Radius.circular(2.0))
            ),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: ScreenSize.height * 0.70,
              child: Scaffold(
                body: Container(
                  //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: ScreenSize.height * 0.70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                      //   topRight: Radius.circular(100),
                      //   topLeft: Radius.circular(100),
                      // )
                      ,
                      color: Colors.white),
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
                                style: TextStyle(fontSize: 20),
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
                                            color: Colors.black)),
                                  ),
                                ),
                                TextField(
                                  controller: questionTitleController,
                                  decoration: InputDecoration(
                                    hintText: tempQuestion.question,
                                    hintStyle: TextStyle(
                                        fontSize: 17.0, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                (showAddAnswer[0])
                                    ? Container(
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: answerOneController,
                                              decoration: InputDecoration(
                                                suffixIcon: (tempQuestion
                                                            .correctAnswerIndex ==
                                                        (1 - 1))
                                                    ? IconButton(
                                                        icon: Icon(Icons.check),
                                                        onPressed: () {})
                                                    : IconButton(
                                                        icon:
                                                            Icon(Icons.cancel),
                                                        onPressed: () {
                                                          setModalState(() {
                                                            tempQuestion
                                                                .correctAnswerIndex = 0;
                                                          });
                                                        }),
                                                hintText:
                                                    tempQuestion.answers[0],
                                                hintStyle: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            (showAddAnswer[1])
                                                ? Container(
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          controller:
                                                              answerTwoController,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                tempQuestion
                                                                    .answers[1],
                                                            suffixIcon: (tempQuestion
                                                                        .correctAnswerIndex ==
                                                                    (2 - 1))
                                                                ? IconButton(
                                                                    icon: Icon(Icons
                                                                        .check),
                                                                    onPressed:
                                                                        () {})
                                                                : IconButton(
                                                                    icon: Icon(Icons
                                                                        .cancel),
                                                                    onPressed:
                                                                        () {
                                                                      setModalState(
                                                                          () {
                                                                        tempQuestion
                                                                            .correctAnswerIndex = 1;
                                                                      });
                                                                    }),
                                                            hintStyle: TextStyle(
                                                                fontSize: 17.0,
                                                                color: Colors
                                                                    .grey),
                                                          ),
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
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            17),
                                                                  ),
                                                                  Spacer(),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            12.0),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        // ADD ANSWER
                                                                        print(
                                                                            "pressed add answer");
                                                                        setModalState(
                                                                            () {
                                                                          answersCounter++;
                                                                          showAddAnswer[2] =
                                                                              true;
                                                                        });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        child: Icon(
                                                                            Icons.add_circle_outline),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : (showAddAnswer[2])
                                                                ? Container(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        TextField(
                                                                          controller:
                                                                              answerThreeController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            hintText: !(tempQuestion.answers.length >= 3)
                                                                                ? 'Type Answer...'
                                                                                : tempQuestion.answers[2],
                                                                            suffixIcon: (tempQuestion.correctAnswerIndex == (3 - 1))
                                                                                ? IconButton(icon: Icon(Icons.check), onPressed: () {})
                                                                                : IconButton(
                                                                                    icon: Icon(Icons.cancel),
                                                                                    onPressed: () {
                                                                                      setModalState(() {
                                                                                        tempQuestion.correctAnswerIndex = 2;
                                                                                      });
                                                                                    }),
                                                                            hintStyle:
                                                                                TextStyle(fontSize: 17.0, color: Colors.grey),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              15,
                                                                        ),
                                                                        // NEW QUESTON HERE
                                                                        (answersCounter <
                                                                                4)
                                                                            ? Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "Answer",
                                                                                    style: kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
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
                                                                                        TextField(
                                                                                          controller: answerFourController,
                                                                                          decoration: InputDecoration(
                                                                                            hintText: !(tempQuestion.answers.length >= 4) ? 'Type Answer...' : tempQuestion.answers[2],
                                                                                            suffixIcon: (tempQuestion.correctAnswerIndex == (4 - 1))
                                                                                                ? IconButton(icon: Icon(Icons.check), onPressed: () {})
                                                                                                : IconButton(
                                                                                                    icon: Icon(Icons.cancel),
                                                                                                    onPressed: () {
                                                                                                      setModalState(() {
                                                                                                        tempQuestion.correctAnswerIndex = 3;
                                                                                                      });
                                                                                                    }),
                                                                                            hintStyle: TextStyle(fontSize: 17.0, color: Colors.grey),
                                                                                          ),
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
                ),
              ),
            );
          });
        });
  }
}
