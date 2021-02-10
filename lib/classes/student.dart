import 'package:mytutor/classes/user.dart';

class Student extends MyUser {
  // List<Question> questions;
  // List<Session> sessions;
  // List<Material> bookmarkedMaterials;

  Student(String name, String email, String pass, String aboutMe, String userId)
      : super(name, email, pass, aboutMe, userId);
}
