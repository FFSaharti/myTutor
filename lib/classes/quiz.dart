import 'package:mytutor/classes/material.dart';
import 'package:mytutor/classes/quiz_question.dart';

class Quiz extends MyMaterial {
  List<QuizQuestion> _questions = [];
  String _quizTitle = '';
  String _quizDesc = '';
  String doc_id;

  Quiz(String issuerId, int type, int subject, this._quizTitle, this._quizDesc,
      this.doc_id)
      : super(issuerId, type, subject, _quizTitle, _quizDesc, doc_id);

  String get quizTitle => _quizTitle;

  set quizTitle(String value) {
    _quizTitle = value;
  }

  List<QuizQuestion> get questions => _questions;

  set questions(List<QuizQuestion> value) {
    _questions = value;
  }

  void addQuestion(QuizQuestion temp) {
    questions.add(temp);
  }

  String get quizDesc => _quizDesc;

  set quizDesc(String value) {
    _quizDesc = value;
  }
}
