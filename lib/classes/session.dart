
class Session {
  String _title;
  String _tutor;
  String _student;
  String _session_id;
  String _time;
  DateTime _date;
  String _desc;
  String _status;
  int _subject;
  String _lastMessage;

  int get subject => _subject;

  set subject(int value) {
    _subject = value;
  }

  String get lastMessage => _lastMessage;

  set lastMessage(String value) {
    _lastMessage = value;
  }

  String _timeOfLastMessage;

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get time => _time;

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  set time(String value) {
    _time = value;
  }

  Session(this._title, this._tutor, this._student, this._session_id, this._time,
      this._date, this._desc, this._status,this._subject);

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

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get timeOfLastMessage => _timeOfLastMessage;

  set timeOfLastMessage(String value) {
    _timeOfLastMessage = value;
  }
}
