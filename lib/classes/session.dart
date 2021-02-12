import 'package:mytutor/classes/user.dart';

class Session{


  //Todo: change the tutor into objects.
  //Todo: convert and add time.

  String _title;
  String _tutor;
  String _student;
  String _session_id;
  String _time;
  String _date;

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  Session(this._title, this._tutor, this._student,this._session_id,this._time,this._date);
  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get student => _student;

  set student(String value) {
    _student = value;
  }

  String get session_id => _session_id;

  set session_id(String value) {
    _session_id = value;
  }

  String get tutor => _tutor;



  set tutor(String value) {
    _tutor = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }
}