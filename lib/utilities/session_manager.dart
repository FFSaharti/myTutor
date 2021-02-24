import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';

class SessionManager {
  static MyUser _loggedInUser = MyUser("", "", "", "", "","");
  static Tutor _loggedInTutor = Tutor("", "", "", "", "", [],"");
  static Student _loggedInStudent = Student("", "", "", "", "", [],"");

  static MyUser get loggedInUser => _loggedInUser;

  static set loggedInUser(MyUser value) {
    _loggedInUser = value;
  }

  static Tutor get loggedInTutor => _loggedInTutor;

  static set loggedInTutor(Tutor value) {
    _loggedInTutor = value;
  } // TODO: Implement sign in user (assigning loggedInUser to a student or tutor object)

  static void signOut() {
    _loggedInUser = MyUser("", "", "", "", "","");
  }

  static Student get loggedInStudent => _loggedInStudent;

  static set loggedInStudent(Student value) {
    _loggedInStudent = value;
  }
}
