import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:intl/intl.dart';

class AnswerScreenQuestionDetails extends StatefulWidget {
  final Question question;

  AnswerScreenQuestionDetails(this.question);

  @override
  _AnswerScreenQuestionDetailsState createState() =>
      _AnswerScreenQuestionDetailsState();
}

class _AnswerScreenQuestionDetailsState
    extends State<AnswerScreenQuestionDetails> {
  void setParentState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Implement our own appBar (with title passable, and want back or not)
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here.
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white70,
        title: Text(
          "View Answer",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                width: ScreenSize.width * 0.88,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: kWhiteish,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          subjects[int.parse(widget.question.subject)].path,
                          width: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: ScreenSize.width * 0.69,
                      height: ScreenSize.height * 0.103,
                      decoration: BoxDecoration(
                          color: kWhiteish,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.description),
                                Text(
                                  widget.question.title,
                                  style: kTitleStyle.copyWith(
                                      fontSize: 15, color: Colors.black),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6.1,
                            ),
                            Row(
                              children: [
                                Icon(Icons.today),
                                Text(
                                  widget.question.dateOfSubmission,
                                  style: kTitleStyle.copyWith(
                                      fontSize: 15, color: Colors.black),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 9,
            ),
            Container(
              width: ScreenSize.width * 0.88,
              child: Divider(
                height: 15,
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Question Description ",
                  style:
                      kTitleStyle.copyWith(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Container(
                alignment: Alignment.topLeft,
                height: ScreenSize.height * 0.4,
                child: Text(
                  widget.question.description,
                  style: kTitleStyle.copyWith(
                      color: kGreyerish,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                EZButton(
                    width: ScreenSize.width * 0.5,
                    buttonColor: kColorScheme[2],
                    textColor: Colors.white,
                    isGradient: true,
                    colors: [kColorScheme[0], kColorScheme[3]],
                    buttonText: "Answer",
                    hasBorder: false,
                    borderColor: null,
                    onPressed: () {
                      print("Pressed answer");
                      showAddQuestion(setParentState);
                      // SHOW ANSWER BOTTOM BAR
                    }),
                EZButton(
                    width: ScreenSize.width * 0.5,
                    buttonColor: kColorScheme[2],
                    textColor: Colors.white,
                    isGradient: true,
                    colors: [kColorScheme[0], kColorScheme[3]],
                    buttonText: "Schedule with student",
                    hasBorder: false,
                    borderColor: null,
                    onPressed: () {
                      scheduleWithStudent();
                      // SHOW ANSWER BOTTOM BAR
                    })
              ],
            )
          ],
        ),
      ),
    );
  }

  void showAddQuestion(Function setParentState) {
    TextEditingController answerController = TextEditingController();
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
              height: ScreenSize.height * 0.50,
              child: Scaffold(
                body: Container(
                  //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: ScreenSize.height * 0.50,
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
                                "Answer",
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  // ADD NEW QUESTION
                                  if (answerController.text.isNotEmpty) {
                                    // ADD ABOUT ME TO STUDENT...
                                    print("adding answer");
                                    DatabaseAPI.answerQuestion(widget.question,
                                            answerController.text)
                                        .then((value) =>
                                            {Navigator.pop(context)});
                                  } else {
                                    print("empty parameters");
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
                                    "Provide an answer",
                                    style: GoogleFonts.secularOne(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                ),
                                TextField(
                                  controller: answerController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: 'Type something...',
                                    hintStyle: TextStyle(
                                        fontSize: 17.0, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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

  void scheduleWithStudent() {
    String _preffredDate;
    TextEditingController timeController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController problemController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width;
    double height = mediaQueryData.size.height;
    problemController.text = widget.question.description;
    titleController.text = widget.question.title;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: height * 0.60,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: height * 0.60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                            "Session details",
                            style: TextStyle(fontSize: 20),
                          ),
                          IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                if (titleController.text.isNotEmpty &&
                                    dateController.text.isNotEmpty &&
                                    problemController.text.isNotEmpty &&
                                    timeController.text.isNotEmpty) {
                                  DatabaseAPI.scheduleWithStudent(Session(
                                          titleController.text,
                                          SessionManager.loggedInTutor.userId,
                                          widget.question.issuer.userId,
                                          "",
                                          timeController.text,
                                          new DateFormat("yyyy-MM-dd")
                                              .parse(dateController.text),
                                          problemController.text,
                                          "",
                                          int.parse(widget.question.subject)))
                                      .then((value) => {
                                            value == "success"
                                                ? AwesomeDialog(
                                                    context: context,
                                                    animType: AnimType.SCALE,
                                                    dialogType:
                                                        DialogType.SUCCES,
                                                    body: Center(
                                                      child: Text(
                                                        'the session created successfully. wait till the student accept it to start tutoring.',
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic),
                                                      ),
                                                    ),
                                                    btnOkOnPress: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ).show()
                                                : AwesomeDialog(
                                                    context: context,
                                                    animType: AnimType.SCALE,
                                                    dialogType:
                                                        DialogType.ERROR,
                                                    body: Center(
                                                      child: Text(
                                                        'check the entered data and try again ',
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,),
                                                      ),
                                                    ),
                                                    btnOkOnPress: () {

                                                    },
                                                  ).show(),
                                          });

                                }
                              }),
                        ],
                      ),
                      Text("Requesting",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                      Text(
                        widget.question.issuer.name,
                        style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey)),
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
                                "SessionTitle",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: TextStyle(
                                    fontSize: 17.0, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Problem Description",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
                              controller: problemController,
                              decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: TextStyle(
                                    fontSize: 17.0, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Preferred Date",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
                              controller: dateController,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(Icons.date_range),
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: _preffredDate == null
                                                ? DateTime.now()
                                                : _preffredDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2022))
                                        .then((value) => dateController.text =
                                            value.year.toString() +
                                                "-" +
                                                value.month.toString() +
                                                "-" +
                                                value.day.toString());
                                  },
                                ),
                                hintText: 'Type something...',
                                hintStyle: TextStyle(
                                    fontSize: 17.0, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Preferred Time, am/pm",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
                              controller: timeController,
                              decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: TextStyle(
                                    fontSize: 17.0, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
