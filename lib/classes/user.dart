import 'package:flutter/cupertino.dart';

class MyUser {
  String _name;
  String _email;
  String _password;
  String _aboutMe;
  String _userId;

  MyUser(@required this._name, @required this._email, @required this._password,
      this._aboutMe,@required this._userId);

  String get name => _name;

  String get email => _email;

  String get aboutMe => _aboutMe;

  String get pass => _password;


  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  set aboutMe(String value) {
    _aboutMe = value;
  }

  set password(String value) {
    _password = value;
  }

  set email(String value) {
    _email = value;
  }

  set name(String value) {
    _name = value;
  }
}
