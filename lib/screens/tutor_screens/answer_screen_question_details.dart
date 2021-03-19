import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(
            context, Theme.of(context).accentColor, "View Question"),
        body: Container(
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  width: ScreenSize.width * 0.88,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            subjects[int.parse(widget.question.subject)].path,
                            width: ScreenSize.width * 0.12,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width * 0.02,
                      ),
                      Container(
                        width: ScreenSize.width * 0.69,
                        height: ScreenSize.height * 0.103,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
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
                                    style: GoogleFonts.sen(
                                        fontSize: 15,
                                        color: Theme.of(context).buttonColor,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenSize.width * 0.01,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.today),
                                  Text(
                                    widget.question.dateOfSubmission,
                                    style: GoogleFonts.sen(
                                        fontSize: 15,
                                        color: Theme.of(context).buttonColor,
                                        fontWeight: FontWeight.bold),
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
                height: ScreenSize.height * 0.009,
              ),
              Container(
                width: ScreenSize.width * 0.88,
                child: Divider(
                  height: ScreenSize.height * 0.02,
                ),
              ),
              SizedBox(height: ScreenSize.height * 0.01),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Question Description ",
                    style: GoogleFonts.sen(
                        fontSize: 25,
                        color: Theme.of(context).buttonColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: ScreenSize.height * 0.005),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  height: ScreenSize.height * 0.4,
                  child: Text(
                    widget.question.description,
                    style: GoogleFonts.sen(
                        fontSize: 15,
                        color: Theme.of(context).buttonColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Container(
                width: ScreenSize.width * 0.88,
                child: Divider(
                  height: ScreenSize.height * 0.02,
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularButton(
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
                  CircularButton(
                      width: ScreenSize.width * 0.5,
                      buttonColor: kColorScheme[2],
                      textColor: Colors.white,
                      isGradient: true,
                      colors: [kColorScheme[0], kColorScheme[3]],
                      buttonText: "Schedule",
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
      ),
    );
  }

  void showAddQuestion(Function setParentState) {
    TextEditingController answerController = TextEditingController();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              height: ScreenSize.height * 0.70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                            style: GoogleFonts.sen(
                                fontSize: 20,
                                color: Theme.of(context).buttonColor),
                          ),
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              if (answerController.text.isNotEmpty) {
                                print("adding answer");
                                DatabaseAPI.answerQuestion(
                                        widget.question, answerController.text)
                                    .then((value) => {
                                          Navigator.pop(context),
                                          Fluttertoast.showToast(
                                              msg: 'Answer sent!')
                                        });
                                //TODO: Show dialog for answering message successfully

                              } else {
                                print("empty parameters");
                                //TODO: Show error message cannot leave empty...
                                Fluttertoast.showToast(
                                    msg: 'Please provide an answer');
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
                              child: Text(
                                "Provide an answer",
                                style: GoogleFonts.sen(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).buttonColor)),
                              ),
                            ),
                            TextField(
                              controller: answerController,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  color: Theme.of(context).buttonColor),
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: 'Type something...',
                                hintStyle: GoogleFonts.sen(
                                    fontSize: 17.0,
                                    color: Theme.of(context)
                                        .buttonColor
                                        .withOpacity(0.6)),
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
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            height: height * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          "Session Details",
                          style: GoogleFonts.sen(
                              fontSize: 20,
                              color: Theme.of(context).buttonColor),
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
                                                  dialogType: DialogType.SUCCES,
                                                  body: Center(
                                                    child: Text(
                                                      'Session sent to student!',
                                                      style: TextStyle(
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                  btnOkOnPress: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ).show()
                                              : AwesomeDialog(
                                                  context: context,
                                                  animType: AnimType.SCALE,
                                                  dialogType: DialogType.ERROR,
                                                  body: Center(
                                                    child: Text(
                                                      'Invalid Data',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                  btnOkOnPress: () {},
                                                ).show(),
                                        });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please fill up all the Fields");
                              }
                            }),
                      ],
                    ),
                    Text("Requesting",
                        style: GoogleFonts.sen(
                            fontSize: 22,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).buttonColor)),
                    Text(
                      widget.question.issuer.name,
                      style: GoogleFonts.sen(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "SessionTitle",
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).buttonColor)),
                            ),
                          ),
                          TextField(
                            style: GoogleFonts.sen(
                                fontSize: 17.0,
                                color: Theme.of(context).buttonColor),
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Type something...',
                              hintStyle: GoogleFonts.sen(
                                  fontSize: 17.0,
                                  color: Theme.of(context).buttonColor),
                            ),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.03,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Problem Description",
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).buttonColor)),
                            ),
                          ),
                          TextField(
                            style: GoogleFonts.sen(
                                fontSize: 17.0,
                                color: Theme.of(context).buttonColor),
                            controller: problemController,
                            decoration: InputDecoration(
                              hintText: 'Type something...',
                              hintStyle: GoogleFonts.sen(
                                  fontSize: 17.0,
                                  color: Theme.of(context).buttonColor),
                            ),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.03,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Preferred Date",
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).buttonColor)),
                            ),
                          ),
                          TextField(
                            controller: dateController,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                child: Icon(
                                  Icons.date_range,
                                  color: Theme.of(context).buttonColor,
                                ),
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
                              fillColor: Theme.of(context).buttonColor,
                              hintStyle: GoogleFonts.sen(
                                  fontSize: 17.0,
                                  color: Theme.of(context).buttonColor),
                            ),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.03,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Preferred Time, am/pm",
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).buttonColor)),
                            ),
                          ),
                          TextField(
                            readOnly: true,
                            controller: timeController,
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    TimeOfDay _PreferredTime = TimeOfDay.now();
                                    TimeOfDay _selectedTimeConvFormat;
                                    String dayOrNight = "";
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Theme(
                                          data: Theme.of(context),
                                          child: child,
                                        );
                                      },
                                    ).then((value) => {
                                          if (value != null)
                                            {
                                              _PreferredTime = value,
                                              _selectedTimeConvFormat =
                                                  _PreferredTime.replacing(
                                                      hour: _PreferredTime
                                                          .hourOfPeriod),
                                              dayOrNight =
                                                  _PreferredTime.period ==
                                                          DayPeriod.am
                                                      ? "AM"
                                                      : "PM",
                                              print(_selectedTimeConvFormat
                                                          .hour ==
                                                      0 &&
                                                  _PreferredTime.period ==
                                                      DayPeriod.pm),
                                              if (_selectedTimeConvFormat
                                                          .hour ==
                                                      0 &&
                                                  _PreferredTime.period ==
                                                      DayPeriod.pm)
                                                {
                                                  // unique case where the system view 12pm as 0 so we will set it manually
                                                  timeController.text = "12" +
                                                      ":" +
                                                      _selectedTimeConvFormat
                                                          .minute
                                                          .toString() +
                                                      " " +
                                                      dayOrNight,
                                                }
                                              else
                                                {
                                                  timeController.text =
                                                      _selectedTimeConvFormat
                                                              .hour
                                                              .toString() +
                                                          ":" +
                                                          _selectedTimeConvFormat
                                                              .minute
                                                              .toString() +
                                                          " " +
                                                          dayOrNight,
                                                }
                                            }
                                        });
                                  },
                                  child: Icon(
                                    Icons.access_time,
                                    color: Theme.of(context).buttonColor,
                                  )),
                              hintText: 'Type something...',
                              hintStyle: GoogleFonts.sen(
                                  fontSize: 17.0,
                                  color: Theme.of(context).buttonColor),
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
        });
  }
}
