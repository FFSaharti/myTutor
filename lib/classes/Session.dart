class Session{


  //Todo: change the tutor/student into objects.
  //Todo: convert and add time.

  String _title;
  String _tutor;
  String _student;
  String _session_id;


  Session(this._title, this._tutor, this._student,this._session_id);
  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get session_id => _session_id;

  set session_id(String value) {
    _session_id = value;
  }

  String get tutor => _tutor;

  String get student => _student;

  set student(String value) {
    _student = value;
  }

  set tutor(String value) {
    _tutor = value;
  }
}