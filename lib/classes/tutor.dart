import 'package:mytutor/classes/user.dart';

class Tutor extends MyUser {
  List<dynamic> _experiences = [];
  // List<Material> bookmarkedMaterials
  // List<Session> sessions;

  Tutor(String name, String email, String pass, String aboutMe, String userid,
      List<int> experiences)
      : super(name, email, pass, aboutMe, userid);

  List<dynamic> get experiences => _experiences;

  set experiences(List<dynamic> value) {
    _experiences = value;
  }

  void addExperience(dynamic num) {
    _experiences.add(num);
  }
}
