import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/quiz_question.dart';
import 'package:mytutor/utilities/screen_size.dart';

// ignore: must_be_immutable
class TypeAnswerWidget extends StatefulWidget {
  TextEditingController textController;
  List<int> correctAnswer;
  Function setModalState;
  int answerIndex;
  QuizQuestion quizQuestion;

  TypeAnswerWidget(
    this.textController,
    this.correctAnswer,
    this.setModalState,
    this.answerIndex, [
    this.quizQuestion,
  ]);

  @override
  _TypeAnswerWidgetState createState() => _TypeAnswerWidgetState();
}

class _TypeAnswerWidgetState extends State<TypeAnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            title: TextField(
              controller: widget.textController,
              style: TextStyle(color: Theme.of(context).buttonColor),
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: widget.quizQuestion == null
                    ? 'Type Answer...'
                    : (widget.quizQuestion.answers.length <= widget.answerIndex)
                        ? 'Type Answer...'
                        : widget.quizQuestion.answers[widget.answerIndex],
                hintStyle: GoogleFonts.sen(
                    fontSize: 17.0,
                    color: Theme.of(context).buttonColor.withOpacity(0.75)),
              ),
            ),
            trailing: widget.quizQuestion == null
                ? ((widget.correctAnswer[0] == widget.answerIndex)
                    ? IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () {})
                    : IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          widget.setModalState(() {
                            widget.correctAnswer[0] = widget.answerIndex;
                          });
                        }))
                : (widget.quizQuestion.correctAnswerIndex == widget.answerIndex)
                    ? IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                        onPressed: () {})
                    : IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          widget.setModalState(() {
                            widget.quizQuestion.correctAnswerIndex =
                                widget.answerIndex;
                          });
                        })),
        Divider(color: Theme.of(context).dividerColor),
        SizedBox(
          height: ScreenSize.height * 0.01,
        ),
      ],
    );
  }
}
