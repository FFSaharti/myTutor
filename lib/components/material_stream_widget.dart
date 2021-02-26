import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/components/material_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/session_manager.dart';

class MaterialStreamTutor extends StatelessWidget {
  final String tutorId;

  const MaterialStreamTutor({this.tutorId});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchAllMaterialsData(tutorId),
      builder: (context, snapshot) {
        // List to fill up with all the session the user has.
        List<Widget> UserMaterials = [];
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> materials = snapshot.data.docs;
          for (var material in materials) {
            int materialType = material.data()["type"];

            if (material.data()['issuerId'] ==
                tutorId) {
              // MATERIALS IS HIS....
              if (materialType == 1) {
                // MATERIAL IS DOCUMENT...
                UserMaterials.add(
                  GestureDetector(
                    onTap: () {
                      print(material.id);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => QuestionAnswersScreenStudent(
                      //             Question(qTitle, question.id, qDesc, qDOS,
                      //                 qIssuer, qAnswers, qSubject, qState),
                      //           )),
                      // );
                    },
                    child: MaterialWidget(
                      material: Document(
                          material.data()['documentTitle'],
                          material.data()['type'],
                          material.data()['documentUrl'],
                          subjects[material.data()['subject']],
                          material.data()['issuerId'],
                          null,
                          material.data()['documentDesc'],
                          material.data()['fileType']),
                      matID: material.id,
                    ),
                  ),
                );
              } else {
                // MATERIAL IS QUIZ
                UserMaterials.add(
                  GestureDetector(
                    onTap: () {
                      print(material.id);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => QuestionAnswersScreenStudent(
                      //             Question(qTitle, question.id, qDesc, qDOS,
                      //                 qIssuer, qAnswers, qSubject, qState),
                      //           )),
                      // );
                    },
                    child: MaterialWidget(
                      material: Quiz(
                          SessionManager.loggedInTutor.userId,
                          2,
                          material.data()['subject'],
                          material.data()['quizTitle'],
                          material.data()['quizDesc']),
                      matID: material.id,
                    ),
                  ),
                );
              }
            }
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: UserMaterials,
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
