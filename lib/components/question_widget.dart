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
    String tempAnswer;
    Tutor tempTutor =
        Tutor("TEST-BABA", "", "pass", "aboutMe", "id", [], "img");
    String tempDate;
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
                DatabaseAPI.getTutor(value.data()["Tutor"]).then((tutor) => {
                      tempTutor = Tutor(
                          tutor.data()["name"],
                          tutor.data()["email"],
                          "encrypted password",
                          "aboutMe",
                          tutor.id,
                          [],
                          tutor.data()["profileImg"]),
                      List.from(tutor.data()["experiences"]).forEach((element) {
                        tempTutor.addExperience(element);
                      }),
                      tempAnswer = value.data()["answer"],
                      tempDate = value.data()["date"],
                      print("After building tutor answer is --> " + tempAnswer),
                      widget.question
                          .addAnswer(Answer(tempAnswer, tempTutor, tempDate)),
                      setState(() {
                        finish = true;
                      }),
                    }),
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
      padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 5),
      child: Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 13, 5, 13),
          child: ListTile(
            leading: Image.asset(
              subjects[int.parse(widget.question.subject)].path,
              width: 50,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: ScreenSize.height * 0.035,
                  child: Text(
                    widget.question.title,
                    style: GoogleFonts.sen(fontSize: 20, color: Theme.of(context).buttonColor),
                  ),
                ),
                Container(
                  height: ScreenSize.height * 0.027,
                  child: Text(
                    widget.question.description,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.sen(fontSize: 14, color: Theme.of(context).buttonColor),
                  ),
                ),
                Container(
                  height: ScreenSize.height * 0.024,
                  child: Row(
                    children: [
                      !finish
                          ? SizedBox(
                              width: ScreenSize.width * 0.28,
                            )
                          : SizedBox(
                              width: ScreenSize.width * 0.40,
                            ),
                      Text(
                        !finish
                            ? "Loading Answers..."
                            : widget.question.answers.length.toString() +
                                " Answers",
                        style: GoogleFonts.sen(
                            fontSize: 13, color: kColorScheme[4]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Image.asset(
          //       subjects[int.parse(widget.question.subject)].path,
          //       width: 50,
          //     ),
          //     SizedBox(
          //       width: ScreenSize.width * 0.02,
          //     ),
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Container(
          //           height: ScreenSize.height * 0.05,
          //           child: Text(
          //             widget.question.title,
          //             style: GoogleFonts.sen(fontSize: 25, color: kBlackish),
          //           ),
          //         ),
          //         Container(
          //           height: ScreenSize.height * 0.027,
          //           child: Text(
          //             widget.question.description,
          //             overflow: TextOverflow.ellipsis,
          //             softWrap: false,
          //             style: GoogleFonts.sen(fontSize: 14, color: kGreyerish),
          //           ),
          //         ),
          //         Container(
          //           height: ScreenSize.height * 0.024,
          //           child: Row(
          //             children: [
          //               !finish
          //                   ? SizedBox(
          //                       width: ScreenSize.width * 0.30,
          //                     )
          //                   : SizedBox(
          //                       width: ScreenSize.width * 0.45,
          //                     ),
          //               Text(
          //                 !finish
          //                     ? "Loading Answers..."
          //                     : widget.question.answers.length.toString() +
          //                         " Answers",
          //                 style: GoogleFonts.sen(
          //                     fontSize: 13, color: kColorScheme[4]),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
