import 'package:mytutor/classes/user.dart';

class SessionManager {
  static MyUser _loggedInUser = MyUser("", "", "", "");

  static MyUser get loggedInUser => _loggedInUser;

  static set loggedInUser(MyUser value) {
    _loggedInUser = value;
  }

// TODO: Implement sign in user (assigning loggedInUser to a student or tutor object)

  static void signOut() {
    _loggedInUser = MyUser("", "", "", "");
  }
}
