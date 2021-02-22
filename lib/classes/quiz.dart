import 'package:mytutor/classes/quiz_question.dart';

class Quiz {
  List<QuizQuestion> _questions = [];
  String _quizTitle = '';
  String _quizDesc = '';

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
