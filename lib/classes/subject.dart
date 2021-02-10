class Subject {
  int _id;
  String _title;
  String _path;
  List<String> _keywords;
  bool _chosen;

  Subject(this._id, this._title, this._path, this._keywords, this._chosen);

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

  List<String> get keywords => _keywords;

  set keywords(List<String> value) {
    _keywords = value;
  }

  bool searchKeyword(String searchBox) {
    for (int i = 0; i < keywords.length; i++) {
      if (searchBox == keywords[i]) {
        return true;
      }
    }
    return false;
  }

  void toggleChosen() {
    chosen = !chosen;
  }

  bool get chosen => _chosen;

  set chosen(bool value) {
    _chosen = value;
  }
}
