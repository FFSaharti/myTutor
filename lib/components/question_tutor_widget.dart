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
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).buttonColor,
            ),
            leading: Image.asset(
              subjects[int.parse(widget.question.subject)].path,
              // width: ScreenSize.width * 0.14,
              height: ScreenSize.height * 0.15,
            ),
            title: Padding(
              padding: const EdgeInsets.fromLTRB(3, 10, 3, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.question.title,
                    maxLines: 1,
                    style: GoogleFonts.sen(
                        fontSize: 18, color: Theme.of(context).buttonColor),
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
                              fontSize: 14,
                              color: Theme.of(context).buttonColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
