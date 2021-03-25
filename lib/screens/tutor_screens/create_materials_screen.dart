import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/quiz_question.dart';
import 'package:mytutor/components/add_answer_prompt.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/components/type_answer_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class CreateMaterialsScreen extends StatefulWidget {
  static String id = "create_materials_screen";

  @override
  _CreateMaterialsScreenState createState() => _CreateMaterialsScreenState();
}

class _CreateMaterialsScreenState extends State<CreateMaterialsScreen> {
  PageController _pageController = PageController();
  int type = 1;
  File _file = null;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  TextEditingController _quizTitleController = TextEditingController();
  TextEditingController _quizDescController = TextEditingController();

  int _dropDownMenuController = 1;

  int _quizDropDownMenuController = 1;
  bool _userChoose;

  bool _quizUserChoose;

  // QUIZ STUFF
  Quiz tempQuiz = Quiz(SessionManager.loggedInTutor.userId, 2, -1, '', '', "");

  void setParentState(QuizQuestion tempQuestion) {
    setState(() {
      tempQuiz.addQuestion(tempQuestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DisableDefaultPop(
      child: Scaffold(
        appBar: buildAppBar(context, kColorScheme[3], "Create Material"),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          type = 1;
                          _pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: Container(
                        width: ScreenSize.width * 0.43,
                        height: ScreenSize.height * 0.065,
                        child: Container(
                          child: Center(
                              child: Text("Document/Slides",
                                  style: GoogleFonts.sen(
                                      color:
                                          type == 1 ? Colors.white : kGreyish,
                                      fontSize: 15))),
                          decoration: new BoxDecoration(
                              color: type == 1 ? kColorScheme[1] : Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              border: Border.all(color: kColorScheme[1])),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 5.0, color: Colors.transparent),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          type = 2;
                          _pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        });
                      },
                      child: Container(
                        width: ScreenSize.width * 0.43,
                        height: ScreenSize.height * 0.065,
                        child: Container(
                          child: Center(
                              child: Text(
                            "Quiz",
                            style: GoogleFonts.sen(
                                color: type == 2 ? Colors.white : kGreyish,
                                fontSize: 15),
                          )),
                          decoration: new BoxDecoration(
                              color: type == 2 ? kColorScheme[0] : Colors.white,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              border: Border.all(color: kColorScheme[1])),
                        ),
                        decoration: new BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border:
                              Border.all(width: 5.0, color: Colors.transparent),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: PageView(
                      physics: new NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: ScreenSize.height * 0.020,
                            ),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Title",
                                  style: GoogleFonts.sen(
                                      color: Theme.of(context).buttonColor,
                                      fontSize: 20),
                                )),
                            SizedBox(
                              height: ScreenSize.height * 0.0090,
                            ),
                            TextField(
                              controller: _titleController,
                              style: GoogleFonts.sen(
                                  fontSize: 14,
                                  color: Theme.of(context).buttonColor),
                              decoration: InputDecoration(
                                  hintText: 'Type Something here....',
                                  hintStyle: TextStyle(
                                      color: Theme.of(context).buttonColor)),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.030,
                            ),
                            Text(
                              "Description",
                              style: GoogleFonts.sen(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.019,
                            ),
                            Container(
                              height: ScreenSize.height * 0.30,
                              width: ScreenSize.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          Theme.of(context).primaryColorLight)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _descController,
                                  style: GoogleFonts.sen(
                                      fontSize: 14,
                                      color: Theme.of(context).buttonColor),
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "Type something here...",
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.035,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Subject",
                                  style: GoogleFonts.sen(
                                      color: Theme.of(context).buttonColor,
                                      fontSize: 17),
                                ),
                                Spacer(),
                                DropdownButton(
                                  value: _dropDownMenuController,
                                  dropdownColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  items: fetchSubjcets(),
                                  onChanged: (value) {
                                    setState(() {
                                      _userChoose = true;
                                      _dropDownMenuController = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Divider(),
                            Row(
                              children: [
                                Text(
                                  "File",
                                  style: GoogleFonts.sen(
                                      color: Theme.of(context).buttonColor,
                                      fontSize: 17),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      getFilesFromLocalStorage();
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
                                  _file == null
                                      ? Fluttertoast.showToast(
                                          msg: "Please attach a file first")
                                      : createMaterials();
                                },
                                child: Text(
                                  "Create",
                                  style: GoogleFonts.sen(
                                      color: Colors.white, fontSize: 15),
                                ),
                                color: kColorScheme[2],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Center(
                          // QUIZ IS HERE...
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenSize.height * 0.020,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Quiz Title",
                                    style: GoogleFonts.sen(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 20),
                                  )),
                              SizedBox(
                                height: ScreenSize.height * 0.0090,
                              ),
                              TextField(
                                controller: _quizTitleController,
                                style: GoogleFonts.sen(
                                    fontSize: 14,
                                    color: Theme.of(context).buttonColor),
                                decoration: InputDecoration(
                                    hintText: 'Type Something here....',
                                    hintStyle: TextStyle(
                                        color: Theme.of(context).buttonColor)),
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.030,
                              ),
                              Text(
                                "Description",
                                style: GoogleFonts.sen(
                                    color: Theme.of(context).buttonColor,
                                    fontSize: 20),
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.019,
                              ),
                              Container(
                                height: ScreenSize.height * 0.15,
                                width: ScreenSize.width,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .primaryColorLight)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: _quizDescController,
                                    style: GoogleFonts.sen(
                                        fontSize: 14,
                                        color: Theme.of(context).buttonColor),
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: "Type something here...",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).buttonColor),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.035,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Subject",
                                    style: GoogleFonts.sen(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 17),
                                  ),
                                  Spacer(),
                                  DropdownButton(
                                    dropdownColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    value: _quizDropDownMenuController,
                                    items: fetchSubjcets(),
                                    onChanged: (value) {
                                      setState(() {
                                        _quizUserChoose = true;
                                        _quizDropDownMenuController = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Divider(),
                              Container(
                                height: ScreenSize.height * 0.18,
                                child: NotificationListener<
                                    OverscrollIndicatorNotification>(
                                  onNotification: (overscroll) {
                                    overscroll.disallowGlow();
                                  },
                                  child: ListView(
                                    children: [
                                      Container(
                                        child: Column(
                                          children:
                                              getListOfQuizQuestions(tempQuiz),
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
                                    createQuiz();
                                  },
                                  child: Text(
                                    "Create Quiz",
                                    style: GoogleFonts.sen(
                                      textStyle: kTitleStyle.copyWith(
                                          color: Colors.white, fontSize: 15),
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

  List<DropdownMenuItem> fetchSubjcets() {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < subjects.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(
          subjects.elementAt(i).title,
          style: GoogleFonts.sen(
              fontSize: 15, color: Theme.of(context).buttonColor),
        ),
        value: i,
      ));
    }
    return items;
  }

  getFilesFromLocalStorage() async {
    String filename = "hello";
    FilePickerResult file =
        await FilePicker.platform.pickFiles(type: FileType.any);
    file == null ? null : _file = File(file.files.single.path);
  }

  // CREATE QUIZ
  void createQuiz() {
    if (_quizTitleController.text.isNotEmpty &&
        _quizDescController.text.isNotEmpty &&
        tempQuiz.questions.length != 0) {
      DatabaseAPI.createAndUploadQuiz(
              _quizTitleController.text,
              subjects.elementAt(_quizDropDownMenuController),
              SessionManager.loggedInTutor.userId,
              _quizDescController.text,
              tempQuiz)
          .then((value) => {
                value == "done"
                    ? AwesomeDialog(
                        context: context,
                        animType: AnimType.SCALE,
                        dialogType: DialogType.SUCCES,
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Quiz Uploaded',
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
                            return count++ == 1;
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
                              style: GoogleFonts.sen(
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
    } else {
      Fluttertoast.showToast(msg: "Please fill all of the information");
    }
  }

  showProgressDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Container(
        child: Row(
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(kColorScheme[3]),
            ),
            Container(child: Text("     please wait..")),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void createMaterials() {
    String filetype = _file.path.split('/').last.split('.').last;
    if (_descController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _file != null) {
      if (filetype.toLowerCase() == "pdf" || filetype.toLowerCase() == "pptx") {
        // upload the file
        showProgressDialog(context);
        DatabaseAPI.uploadFileToStorage(Document(
                _titleController.text,
                1,
                null,
                subjects.elementAt(_dropDownMenuController),
                SessionManager.loggedInTutor.userId,
                _file,
                _descController.text,
                filetype,
                ""))
            .then((value) => {
                  value == "done"
                      ? AwesomeDialog(
                          context: context,
                          animType: AnimType.SCALE,
                          dialogType: DialogType.SUCCES,
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'file uploaded',
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
                                style: GoogleFonts.sen(
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
      } else {
        AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'the file type is not supported. you can upload document of type (pdf,pptx) only ',
                style: kTitleStyle.copyWith(
                    color: Theme.of(context).buttonColor,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ).show();
      }
    }
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
                                    correctAnswer[0]);
                                //setParentState;
                                setParentState(tempQuestion);
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
        Text(
          tempQuiz.questions[i].question,
          style: GoogleFonts.sen(
              color: Theme.of(context).buttonColor, fontSize: 17),
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
      int correctAnswer) {
    int correctAnswerIndex = correctAnswer - 1;

    QuizQuestion tempQ = QuizQuestion(questionTitle, "");
    tempQ.question = questionTitle;

    tempQ.correctAnswerIndex = correctAnswerIndex;
    if (answerOne.isNotEmpty && answerOne != '') {
      tempQ.addAnswer(answerOne);
    }
    if (answerTwo.isNotEmpty && answerTwo != '') {
      tempQ.addAnswer(answerTwo);
    }
    if (answerThree.isNotEmpty && answerThree != '') {
      tempQ.addAnswer(answerThree);
    }
    if (answerFour.isNotEmpty && answerFour != '') {
      tempQ.addAnswer(answerFour);
    }

    return tempQ;
  }
}
