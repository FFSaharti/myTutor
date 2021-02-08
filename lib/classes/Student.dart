class Student{

  String _name;
  String _email;
  String _pass;


  Student(this._name, this._email, this._pass);



  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  String get pass => _pass;

  set pass(String value) {
    _pass = value;
  }

  set email(String value) {
    _email = value;
  }
}