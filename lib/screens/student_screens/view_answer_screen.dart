import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/screens/student_screens/question_answers_page_screen_student.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

class ViewAnswerScreen extends StatelessWidget {
  final Answer answer;
  final QuestionAnswersScreenStudent question;

  ViewAnswerScreen(this.answer, this.question);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, Theme.of(context).buttonColor, "View Answer"),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: ScreenSize.width * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 40,
                          ),
                          SizedBox(
                            width: ScreenSize.width * 0.03,
                          ),
                          Text(
                            answer.tutor.name,
                            style: kTitleStyle.copyWith(
                                fontSize: 20, color: Theme.of(context).buttonColor),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 40,
                          ),
                          SizedBox(
                            width: ScreenSize.width * 0.03,
                          ),
                          Container(
                            child: Text(
                              answer.date,
                              style: kTitleStyle.copyWith(
                                  fontSize: 20, color: Theme.of(context).buttonColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.01,
            ),
            Container(
              width: ScreenSize.width * 0.88,
              child: Divider(
                height: ScreenSize.height * 0.02,
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.01),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Provided Answer ",
                style: kTitleStyle.copyWith(fontSize: 20, color: Theme.of(context).buttonColor),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    height: ScreenSize.height * 0.4,
                    child: Text(
                      answer.answer,
                      style: kTitleStyle.copyWith(
                          color: Theme.of(context).buttonColor,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ),
            ),
            (this.question.question.state == "Active")
                ? CircularButton(
                    width: ScreenSize.width * 0.5,
                    fontSize: 15,
                    buttonColor: kColorScheme[2],
                    textColor: Theme.of(context).buttonColor,
                    isGradient: true,
                    colors: [kColorScheme[0], kColorScheme[3]],
                    buttonText: "Close Question",
                    hasBorder: false,
                    borderColor: null,
                    onPressed: () {
                      print("Pressed Close");
                      DatabaseAPI.closeQuestion(this.question.question);
                      Fluttertoast.showToast(
                          msg: 'Question Closed Successfully!');
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
                : Container()
          ],
        ),
      ),
    );
  }
}
