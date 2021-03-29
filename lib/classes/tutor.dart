import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/user.dart';

class Tutor extends MyUser {
  List<dynamic> _experiences = [];
  List<Rate> _rates = [];

  List<Rate> get rates => _rates;

  set rates(List<Rate> value) {
    _rates = value;
  }

  Tutor(String name, String email, String pass, String aboutMe, String userid,
      List<int> experiences, Profileimg)
      : super(name, email, pass, aboutMe, userid, Profileimg);

  List<dynamic> get experiences => _experiences;

  set experiences(List<dynamic> value) {
    _experiences = value;
  }

  void addExperience(dynamic num) {
    _experiences.add(num);
  }
}
