import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/components/question_tutor_widget.dart';
import 'package:mytutor/screens/tutor_screens/answer_screen_question_details.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';

class QuestionStreamTutor extends StatelessWidget {
  final List<dynamic> exp;
  final String search;
  int from = 100;
  int to = 450;

  QuestionStreamTutor({@required this.exp, this.search});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchQuestionsForTutor(),
      builder: (context, snapshot) {
        // List to fill up with all the session the user has.
        from = 100;
        to = 450;
        List<Widget> TutorQuestions = [];
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> questions = snapshot.data.docs;
          for (var question in questions) {
            final qSubject = question.data()["subject"];

            if ((isTutorExperienced(exp, qSubject))) {
              final qTitle = question.data()["title"];
              final qState = question.data()["date"];
              final qIssuer = question.data()["issuer"];
              final qDesc = question.data()["description"];
              final qDOS = question.data()["dateOfSubmission"];
              final qID = question.data()['doc_id'];
              if (search == '') {
                addQuestion(context, TutorQuestions, qTitle, question, qDesc,
                    qDOS, qIssuer, qSubject, qState);
              } else {
                if (subjects[qSubject].searchKeyword(search) ||
                    (qTitle as String).contains(search)) {
                  addQuestion(context, TutorQuestions, qTitle, question, qDesc,
                      qDOS, qIssuer, qSubject, qState);
                }
              }
            }
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: TutorQuestions,
          ),
        );
      },
    );
  }

  bool isTutorExperienced(List<dynamic> exp, qSubject) {
    for (int i = 0; i < exp.length; i++) {
      if (qSubject == exp[i]) {
        return true;
      }
    }

    return false;
  }

  void addQuestion(BuildContext context, List<Widget> TutorQuestions, qTitle,
      QueryDocumentSnapshot question, qDesc, qDOS, qIssuer, qSubject, qState) {
    TutorQuestions.add(
      Villain(
        villainAnimation: VillainAnimation.fromBottom(
          from: Duration(milliseconds: from),
          to: Duration(milliseconds: to),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AnswerScreenQuestionDetails(
                        Question(
                            qTitle,
                            question.id,
                            qDesc,
                            qDOS,
                            Student("", "", "", "", qIssuer.toString(), [], ""),
                            [],
                            qSubject.toString(),
                            qState),
                      )),
            );
          },
          child: QuestionTutorWidget(Question(
              qTitle,
              question.id,
              qDesc,
              qDOS,
              Student("", "", "", "", qIssuer.toString(), [], ""),
              [],
              qSubject.toString(),
              qState)),
        ),
      ),
    );

    from += 100;
    to += 100;
  }
}
