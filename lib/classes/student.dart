import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/utilities/database_api.dart';

class Student extends MyUser {
  List<Question> _questions = [];
  // List<Session> sessions;
  // List<Material> bookmarkedMaterials;

  Student(String name, String email, String pass, String aboutMe, String userId,
      List<Question> _questions)
      : super(name, email, pass, aboutMe, userId);

  List<Question> get questions => _questions;

  set questions(List<Question> value) {
    _questions = value;
  }

  void addQuestion(Question question) {
    questions.add(question);
    DatabaseAPI.addQuestionToStudent(this, questions);
  }
}
