import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    @required this.question,
  });

  final Question question;

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool finish = false;

  void initState() {
    // get the tutor name.
    // means that the current user is not student, so get the student name
    widget.question.answers.clear();
    DatabaseAPI.getQuestion(widget.question).then((data) {
      print("question inside question widget --> " + data.data()["title"]);
      print("answers inside question widget --> " +
          data.data()["answers"].toString());

      if ((data.data()["answers"] as List).length == 0) {
        setState(() {
          finish = true;
        });
      } else {
        List.from(data.data()["answers"]).forEach((element) {
          print("element inside list is --> " + element.toString());
          DatabaseAPI.getAnswer(element).then((value) => {
                //TODO: Fetch tutor to add to answer instead of tempTutor
                widget.question.addAnswer(Answer(
                    value.data()["answer"],
                    //TODO: Build Tutor from answer query.
                    Tutor("TEST-BABA", "", "pass", "aboutMe",
                        value.data()["Tutor"].toString(), []))),
                setState(() {
                  finish = true;
                })
              });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Question " +
        widget.question.title.toString() +
        " has answers of length " +
        widget.question.answers.length.toString());
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: ScreenSize.height * 0.15,
        decoration: BoxDecoration(
          color: kWhiteish,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                subjects[int.parse(widget.question.subject)].path,
                width: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenSize.height * 0.05,
                    child: Text(
                      widget.question.title,
                      style: GoogleFonts.sarala(fontSize: 25, color: kBlackish),
                    ),
                  ),
                  Container(
                    height: ScreenSize.height * 0.027,
                    child: Text(
                      widget.question.description,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style:
                          GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
                    ),
                  ),
                  Container(
                    height: ScreenSize.height * 0.024,
                    child: Row(
                      children: [
                        !finish
                            ? SizedBox(
                                width: ScreenSize.width * 0.35,
                              )
                            : SizedBox(
                                width: ScreenSize.width * 0.45,
                              ),
                        Text(
                          !finish
                              ? "Loading Answers..."
                              : widget.question.answers.length.toString() +
                                  " Answers",
                          style: GoogleFonts.sarala(
                              fontSize: 13, color: kColorScheme[4]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
