class Subject {
  int _id;
  String _title;
  String _path;

  Subject(this._id, this._title, this._path);

  String get path => _path;

  set path(String value) {
    _path = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
