import 'package:mytutor/classes/student.dart';

import 'answer.dart';

class Question {
  String title;
  String id;
  String description;
  String dateOfSubmission;
  Student issuer;
  List<Answer> answers = [];
  String subject;
  String state;

  Question(this.title, this.id, this.description, this.dateOfSubmission,
      this.issuer, this.answers, this.subject, this.state);

  void addAnswer(Answer answer) {
    answers.add(answer);
  }
}
