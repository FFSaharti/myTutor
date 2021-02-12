import 'package:mytutor/classes/tutor.dart';

class Answer {
  String _answer;
  Tutor _tutor;

  Answer(this._answer, this._tutor);

  String get answer => _answer;

  set answer(String value) {
    _answer = value;
  }

  Tutor get tutor => _tutor;

  set tutor(Tutor value) {
    _tutor = value;
  }
}
