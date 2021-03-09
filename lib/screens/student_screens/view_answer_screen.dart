import 'package:flutter/material.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/components/ez_button.dart';
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
                          width: 5,
                        ),
                        Text(
                          answer.tutor.name,
                          style: kTitleStyle.copyWith(
                              fontSize: 20, color: Colors.black),
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
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            answer.date,
                            style: kTitleStyle.copyWith(
                                fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ],
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
                  "Provided Answer ",
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
                  answer.answer,
                  style: kTitleStyle.copyWith(
                      color: kGreyerish,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            (this.question.question.state == "Active")
                ? EZButton(
                    width: ScreenSize.width * 0.5,
                    buttonColor: kColorScheme[2],
                    textColor: Colors.white,
                    isGradient: true,
                    colors: [kColorScheme[0], kColorScheme[3]],
                    buttonText: "Close Question",
                    hasBorder: false,
                    borderColor: null,
                    onPressed: () {
                      print("Pressed Close");
                      DatabaseAPI.closeQuestion(this.question.question);
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
