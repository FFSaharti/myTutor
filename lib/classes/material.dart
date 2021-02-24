class MyMaterial {
  String _issuerId;
  int _type;
  int _subject;
  String _title;
  String _desc;

  MyMaterial(
      this._issuerId, this._type, this._subject, this._title, this._desc);

  int get subjectID => _subject;

  set subjectID(int value) {
    _subject = value;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  String get issuerId => _issuerId;

  set issuerId(String value) {
    _issuerId = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }
}
