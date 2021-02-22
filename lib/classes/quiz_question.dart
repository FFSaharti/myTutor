class QuizQuestion {
  String _question;
  List<String> _answers = [];
  int _correctAnswerIndex;

  QuizQuestion(this._question);

  int get correctAnswerIndex => _correctAnswerIndex;

  set correctAnswerIndex(int value) {
    _correctAnswerIndex = value;
  }

  List<String> get answers => _answers;

  set answers(List<String> value) {
    _answers = value;
  }

  String get question => _question;

  set question(String value) {
    _question = value;
  }

  void addAnswer(String temp) {
    answers.add(temp);
  }
}
