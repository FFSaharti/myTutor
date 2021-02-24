import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/user.dart';

class Student extends MyUser {
  List<Question> _questions = [];
  // List<Session> sessions;
  // List<Material> bookmarkedMaterials;

  Student(String name, String email, String pass, String aboutMe, String userId,
      List<Question> _questions,Profileimg)
      : super(name, email, pass, aboutMe, userId,Profileimg);

  List<Question> get questions => _questions;

  set questions(List<Question> value) {
    _questions = value;
  }

  void addQuestion(Question question) {
    questions.add(question);
  }
}
