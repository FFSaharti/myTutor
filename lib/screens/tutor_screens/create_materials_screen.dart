import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/quiz_question.dart';
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                      height: 50.0,
                      child: Container(
                        child: Center(
                            child: Text(
                          "Document/slides",
                          style: TextStyle(
                              color: type == 1 ? Colors.white : kGreyish),
                        )),
                        decoration: new BoxDecoration(
                            color: type == 1 ? kColorScheme[0] : Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(color: kColorScheme[1])),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(width: 5.0, color: Colors.white),
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
                      height: 50.0,
                      child: Container(
                        child: Center(
                            child: Text(
                          "Quiz",
                          style: TextStyle(
                              color: type == 2 ? Colors.white : kGreyish),
                        )),
                        decoration: new BoxDecoration(
                            color: type == 2 ? kColorScheme[0] : Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            border: Border.all(color: kColorScheme[1])),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(width: 5.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
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
                              style: kTitleStyle.copyWith(
                                  color: Colors.black, fontSize: 20),
                            )),
                        SizedBox(
                          height: ScreenSize.height * 0.0090,
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Type Something here....',
                          ),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.030,
                        ),
                        Text(
                          "Description",
                          style: kTitleStyle.copyWith(
                              color: Colors.black, fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.019,
                        ),
                        Container(
                          height: ScreenSize.height * 0.30,
                          width: ScreenSize.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _descController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Type something here...",
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
                              style: kTitleStyle.copyWith(
                                  color: Colors.black, fontSize: 17),
                            ),
                            Spacer(),
                            DropdownButton(
                              value: _dropDownMenuController,
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
                              style: kTitleStyle.copyWith(
                                  color: Colors.black, fontSize: 17),
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
                              createMaterials();
                            },
                            child: Text(
                              "Create",
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
                                style: kTitleStyle.copyWith(
                                    color: Colors.black, fontSize: 20),
                              )),
                          SizedBox(
                            height: ScreenSize.height * 0.0090,
                          ),
                          TextField(
                            controller: _quizTitleController,
                            decoration: InputDecoration(
                              hintText: 'Type Something here....',
                            ),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.030,
                          ),
                          Text(
                            "Description",
                            style: kTitleStyle.copyWith(
                                color: Colors.black, fontSize: 20),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.019,
                          ),
                          Container(
                            height: ScreenSize.height * 0.15,
                            width: ScreenSize.width,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: _quizDescController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  hintText: "Type something here...",
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
                                style: kTitleStyle.copyWith(
                                    color: Colors.black, fontSize: 17),
                              ),
                              Spacer(),
                              DropdownButton(
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
                            child: ListView(
                              children: [
                                Container(
                                  child: Column(
                                    children: getListOfQuizQuestions(tempQuiz),
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
                                createQuiz();
                              },
                              child: Text(
                                "Create Quiz",
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> fetchSubjcets() {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < subjects.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(subjects.elementAt(i).title),
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
    //  String fileLastname = '$filename+.pdf';
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
                              'quiz uploaded',
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
  }

  void createMaterials() {
    String filetype = _file.path.split('/').last.split('.').last;
    if (_descController.text.isNotEmpty &&
        _titleController.text.isNotEmpty &&
        _file != null) {
      if (filetype == "pdf" || filetype == "pptx") {
        // uplode the file
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
                    color: kBlackish,
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
    List<Widget> searchResults = [];
    String searchBox = '';
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
                                        correctAnswer);
                                    setParentState;
                                    setParentState(tempQuestion);
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
        Text(
          tempQuiz.questions[i].question,
          style: kTitleStyle.copyWith(color: Colors.black, fontSize: 17),
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
