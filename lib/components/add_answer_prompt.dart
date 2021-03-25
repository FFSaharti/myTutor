import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AddAnswerPrompt extends StatefulWidget {
  List<int> answersCounter;
  Function setModalState;
  List<bool> showAddAnswer;
  int showAddAnswerIndex;

  AddAnswerPrompt(this.answersCounter, this.setModalState, this.showAddAnswer,
      this.showAddAnswerIndex);

  @override
  _AddAnswerPromptState createState() => _AddAnswerPromptState();
}

class _AddAnswerPromptState extends State<AddAnswerPrompt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            "Add Answer",
            style: GoogleFonts.sen(
                color: Theme.of(context).buttonColor, fontSize: 17),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                widget.setModalState(() {
                  widget.answersCounter[0]++;
                  widget.showAddAnswer[widget.showAddAnswerIndex] = true;
                });
              },
              child: Container(
                child: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).dividerColor,
        )
      ],
    );
  }
}
