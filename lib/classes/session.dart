import 'package:mytutor/classes/user.dart';

class Session{


  //Todo: change the tutor into objects.
  //Todo: convert and add time.

  String _title;
  String _tutor;
  MyUser _student;
  String _session_id;


  Session(this._title, this._tutor, this._student,this._session_id);
  String get title => _title;

  set title(String value) {
    _title = value;
  }

  MyUser get student => _student;

  set student(MyUser value) {
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
}