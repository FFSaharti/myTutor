

import 'dart:io';

import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/classes/tutor.dart';

class Document{

  String _title;
  int _type;
  String _url;
  String _description;
  Subject _subject;
  String _issuerId;
  File _file;


  Document(this._title, this._type, this._url, this._subject,
      this._issuerId,this._file,this._description);


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
}