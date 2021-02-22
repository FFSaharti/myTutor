import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/components/question_widget.dart';
import 'package:mytutor/screens/student_screens/question_answers_page_screen_student.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/session_manager.dart';

class QuestionStream extends StatelessWidget {
  final String status;

  const QuestionStream({@required this.status});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchQuestionData(status),
      builder: (context, snapshot) {
        // List to fill up with all the session the user has.
        List<Widget> UserQuestions = [];
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> questions = snapshot.data.docs;
          for (var question in questions) {
            String SessionStatus = question.data()["state"];

            if (SessionStatus.toLowerCase() == status.toLowerCase()) {
              final qTitle = question.data()["title"];
              final qSubject = question.data()["subject"].toString();
              final qState = question.data()["state"];
              final qIssuer = SessionManager.loggedInStudent;
              final qDesc = question.data()["description"];
              final qDOS = question.data()["dateOfSubmission"];
              final qID = question.data()['doc_id'];

              List<Answer> qAnswers = [];

              //TODO: Get Answers for each question...
              // List.from(question.data()['answers']).forEach((element) {
              //   print("Answer list from --> " + element.toString());
              //   DatabaseAPI.getAnswer(element)
              //       .then((value) => {qAnswers = value});
              // });

              print(qTitle.toString());
              UserQuestions.add(
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionAnswersScreenStudent(
                                Question(qTitle, question.id, qDesc, qDOS,
                                    qIssuer, qAnswers, qSubject, qState),
                              )),
                    );
                  },
                  child: QuestionWidget(
                      question: Question(qTitle, question.id, qDesc, qDOS,
                          qIssuer, qAnswers, qSubject, qState)),
                ),
              );
            }
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: UserQuestions,
          ),
        );
      },
    );
  }

  // List<Answer> getAnswers(List<dynamic> data) {
  //   print("ANSWERS IS --> " + data.toString());
  //   List<Answer> answers = [];
  //
  //   DatabaseAPI.getAnswers(data).then((value) => {answers = value});
  //
  //   return answers;
  // }
}
