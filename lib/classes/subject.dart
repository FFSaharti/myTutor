class Subject {
  int _id;
  String _title;
  List<String> _keywords;
  String _path;

  Subject(this._id, this._title, this._keywords, this._path);

  String get path => _path;

  set path(String value) {
    _path = value;
  }

  List<String> get keywords => _keywords;

  set keywords(List<String> value) {
    _keywords = value;
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
