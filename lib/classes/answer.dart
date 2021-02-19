import 'package:mytutor/classes/tutor.dart';

class Answer {
  String _answer;
  Tutor _tutor;
  String _date;
  Answer(this._answer, this._tutor, this._date);


  String get answer => _answer;

  set answer(String value) {
    _answer = value;
  }

  Tutor get tutor => _tutor;

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  set tutor(Tutor value) {
    _tutor = value;
  }
}
