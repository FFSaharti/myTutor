import 'package:mytutor/classes/user.dart';

class Tutor extends MyUser {
  // List<Subject> _experiences;

  Tutor(String name, String email, String pass, String aboutMe, String userId)
      : super(name, email, pass, aboutMe,userId);

  // List<Subject> get experiences => _experiences;
}
