import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

class QuestionTutorWidget extends StatefulWidget {
  final Question question;

  QuestionTutorWidget(this.question);

  @override
  _QuestionTutorWidgetState createState() => _QuestionTutorWidgetState();
}

class _QuestionTutorWidgetState extends State<QuestionTutorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        height: ScreenSize.height * 0.15,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
                width: ScreenSize.width * 0.15,
              ),
              SizedBox(
                width: ScreenSize.width * 0.03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenSize.height * 0.05,
                    child: Text(
                      widget.question.title,
                      style: GoogleFonts.sen(fontSize: 25, color: Theme.of(context).buttonColor),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                            color: Theme.of(context).buttonColor,
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width * 0.009,
                      ),
                      Container(
                        height: ScreenSize.height * 0.027,
                        child: Text(
                          widget.question.dateOfSubmission,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: GoogleFonts.sarala(
                              fontSize: 14, color: Theme.of(context).buttonColor),
                        ),
                      ),
                    ],
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
