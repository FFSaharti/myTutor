import 'dart:io';

import 'package:mytutor/classes/material.dart';
import 'package:mytutor/classes/subject.dart';

class Document extends MyMaterial {
  String _title;
  String _fileType;
  int _type;
  String _url;
  String _description;
  Subject _subject;
  String _issuerId;
  File _file;
  String _docid;

  String get fileType => _fileType;

  set fileType(String value) {
    _fileType = value;
  }

  Document(this._title, this._type, this._url, this._subject, this._issuerId,
      this._file, this._description, this._fileType)
      : super(_issuerId, _type, _subject.id, _title, _description);

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  File get file => _file;

  set file(File value) {
    _file = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  Subject get subject => _subject;

  set subject(Subject value) {
    _subject = value;
  }

  String get issuer => _issuerId;

  set issuer(String value) {
    _issuerId = value;
  }

  String get issuerId => _issuerId;

  set issuerId(String value) {
    _issuerId = value;
  }

  String get docid => _docid;

  set docid(String value) {
    _docid = value;
  }
}
