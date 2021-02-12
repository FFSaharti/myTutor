import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/utilities/session_manager.dart';

import 'constants.dart';

// Creating the DB Instance...
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DatabaseAPI {
  static MyUser _tempUser = MyUser("", "", "", "", "");
  static Tutor _tempTutor = Tutor("", "", "", "", "", []);
  static Student _tempStudent = Student("", "", "", "", "", []);
  String _errorcode = '';

  String get errorcode => _errorcode;

  static MyUser get tempUser => _tempUser;

  static set tempUser(MyUser value) {
    _tempUser = value;
  }

  static Tutor get tempTutor => _tempTutor;

  static set tempTutor(Tutor value) {
    _tempTutor = value;
  }

  static Future<String> createStudent() async {
    //TODO:catch.
    try {
      UserCredential user = await _auth
          .createUserWithEmailAndPassword(
              email: tempUser.email, password: tempUser.pass)
          .then((value) => value);
      if (user != null) {
        uploadUser();
        return "Success";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static void uploadUser() {
    _firestore.collection("Student").add({
      "email": tempUser.email,
      "pass": tempUser.pass,
      "name": tempUser.name,
      "questions": []
    });
  }

  static Future<String> userLogin(String email, String pass) async {
    try {
      UserCredential userlogin =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      //  return e.message + " MISMATCH";
    }

    // try {
    //   await _firestore
    //       .collection("Student")
    //       .where("email", isEqualTo: email)
    //       .get()
    //       .then((value) => {
    //             tempStudent = Student(value.docs.single.data()['name'], email,
    //                 pass, "", value.docs.single.id, []),
    //             List.from(value.docs.single.data()['questions'])
    //                 .forEach((element) {
    //               print("QUESTION PRINTING ... " + element.toString());
    //               buildQuestion(element.toString(), tempStudent);
    //             })
    //           });
    //
    //   SessionManager.loggedInUser = tempUser;
    //   SessionManager.loggedInStudent = tempStudent;
    //   return "Student Login";
    // } on FirebaseAuthException catch (e) {
    //   // print(e.message);
    // }

    try {
      await _firestore
          .collection("Tutor")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => {
                _tempTutor = Tutor(value.docs.single.data()['name'], email,
                    pass, "", value.docs.single.id, []),
                List.from(value.docs.single.data()['experiences'])
                    .forEach((element) {
                  print("Subject PRINTING ... " + element.toString());
                  _tempTutor.addExperience(element);
                })
              });

      SessionManager.loggedInTutor = _tempTutor;
      return "Tutor Login";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // session related


  static Future<QuerySnapshot> getTutors() async{

    return await _firestore
        .collection("Tutor").get();
  }
  static void createNewSession(String title, String problemDesc, String prefDate,MyUser tutor, String time)async {
    await _firestore.collection("session").add({
      'student': DatabaseAPI._tempStudent.userId,
      'title': title,
      'tutor': tutor.userId,
      'date' : prefDate,
      'time' : time,
      'status': "pending",
    });
  }

  static Stream<QuerySnapshot> fetchSessionData(int type) {
    print(SessionManager.loggedInUser.userId);
    if (type == 1) {
      // tutor
      return _firestore
          .collection("session")
          .where("tutor", isEqualTo: SessionManager.loggedInTutor.userId)
          .snapshots();
    } else {
      //student
      return _firestore
          .collection("session")
          .where("student", isEqualTo: DatabaseAPI.tempStudent.userId)
          .snapshots();
    }
  }

  static Stream<QuerySnapshot> fetchSessionMessages(String sessionid) {
    return _firestore
        .collection('session')
        .doc(sessionid)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  static void saveNewMessage(String sessionid, String msg, String sender) {
    _firestore.collection("session").doc(sessionid).collection("messages").add({
      'text': msg,
      'sender': sender,
      'time': DateTime.now(),
    });
  }


  static Future<DocumentSnapshot> getUserbyid(String userID, int type) async {

    if (type == 1) {
      // student
      return await _firestore.collection('Student').doc(userID).get();

    } else {
      // tutor
      return await _firestore
          .collection('Tutor')
          .doc(userID)
          .get();
    }

  }

  static Future<String> createTutor(tutorEmail) async {
    List<int> subjectIDs = getSubjects();

    try {
      UserCredential user = await _auth
          .createUserWithEmailAndPassword(
              email: tempUser.email, password: tempUser.pass)
          .then((value) => value);
      if (user != null) {
        try {
          await _firestore.collection("Tutor").add({
            "email": tempUser.email,
            "pass": tempUser.pass,
            "name": tempUser.name,
            "experiences": subjectIDs
          });
          _tempTutor = Tutor(
              tempUser.name, tempUser.email, tempUser.pass, "", "", subjectIDs);
          SessionManager.loggedInTutor = _tempTutor;
          return "Success";
        } on FirebaseAuthException catch (e) {
          return e.message;
        }
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static List<int> getSubjects() {
    List<int> IDs = [];
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].chosen) {
        IDs.add(subjects[i].id);
      }
    }

    return IDs;
  }

  static void addQuestionToStudent(Student student, List<Question> questions) {
    // Add Question to Student in the database...
  }

  static Student get tempStudent => _tempStudent;

  static set tempStudent(Student value) {
    _tempStudent = value;
  }

  static void buildQuestion(String questionDocID, Student tempStudent) async {
    Question tempQuestion = Question("", "", "", "", _tempStudent, [], "", "");
    print("Build Question ... questiondocId is ---> " +
        questionDocID.substring(27, questionDocID.length - 1));

    questionDocID = questionDocID.substring(27, questionDocID.length - 1);

    await _firestore
        .collection("Question")
        .where("doc_id", isEqualTo: questionDocID)
        .get()
        .then((value) => {
              tempQuestion = Question(
                  value.docs.single.data()['title'],
                  value.docs.single.id,
                  value.docs.single.data()['description'],
                  value.docs.single.data()['dateOfSubmission'],
                  _tempStudent,
                  [],
                  value.docs.single.data()['subject'],
                  value.docs.single.data()['state']),

              print("QUESTION TITLE ... " + tempQuestion.title),

              List.from(value.docs.single.data()['answers']).forEach((element) {
                print("ANSWER PRINTING ... " +
                    element
                        .toString()
                        .substring(25, element.toString().length - 1));
                buildAnswers(
                    element
                        .toString()
                        .substring(25, element.toString().length - 1),
                    tempQuestion);
              })

              // _tempTutor = Tutor(value.docs.single.data()['name'], email,
              //     pass, "", value.docs.single.id, []),
              // List.from(value.docs.single.data()['experiences'])
              //     .forEach((element) {
              //   print("ELEMENT PRINTING ... " + element.toString());
              //   _tempTutor.addExperience(element);
              // })
            });

    _tempStudent.addQuestion(tempQuestion);
  }

  static void buildAnswers(String answerID, Question tempQuestion) async {
    Answer tempAnswer =
        Answer("", Tutor("TEST-BABA", "", "pass", "aboutMe", "userid", []));
    String answer = '';
    String tutorID = '';
    await _firestore
        .collection("Answer")
        .where("doc_id", isEqualTo: answerID)
        .get()
        .then((value) => {
              print("ANSWER PRINTING..." + value.docs.single.data()['answer']),
              print("TUTOR ID is  --> " +
                  value.docs.single.data()['Tutor'].toString().substring(24,
                      value.docs.single.data()['Tutor'].toString().length - 1)),
              answer = value.docs.single.data()['answer'],
              tutorID = value.docs.single.data()['Tutor'].toString().substring(
                  24, value.docs.single.data()['Tutor'].toString().length - 1),
              buildTutor(tutorID).then((value) => {
                    tempTutor = value,
                    tempAnswer = Answer(answer, tempTutor),
                    tempQuestion.addAnswer(tempAnswer),
                  }),
            });
  }

  static Future<Tutor> buildTutor(String tutorID) async {
    await _firestore.collection("Tutor").doc(tutorID).get().then((value) => {
          print("TUTOR IS ....... " + value.data()['name']),
          tempTutor = Tutor(value.data()['name'], value.data()['email'],
              value.data()['pass'], "", value.id, []),
          List.from(value.data()['experiences']).forEach((element) {
            print(
                "EXPERIENCES OF TUTOR ARE PRINTING ... " + element.toString());
            tempTutor.addExperience(element);
          }),
        });

    return tempTutor;
  }
}
