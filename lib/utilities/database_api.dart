import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  static Tutor _tempTutor = Tutor("", "", "", "","", []);
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
    });
  }

  static Future<String> userLogin(String email, String pass) async {
    try {
      UserCredential userlogin =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      //  return e.message + " MISMATCH";
    }

    try {
      await _firestore
          .collection("Student")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => tempUser = Student(value.docs.single.data()['name'],
              email, pass, "", value.docs.single.id));
      SessionManager.loggedInUser = tempUser;
      return "Student Login";
    } on FirebaseAuthException catch (e) {
      // print(e.message);
    }

    // try {
    //   await _firestore
    //       .collection("Tutor")
    //       .where("email", isEqualTo: email)
    //       .get()
    //
    //       .then((value) => _tempTutor = Tutor(value.docs.single.data()['name'], email, pass, "aboutme", value.docs.single.id, value.docs.single.data()['experiences']));
    //   SessionManager.loggedInUser = _tempTutor;
    //   return "Tutor Login";
    // } on FirebaseAuthException catch (e) {
    //   return e.message;
    // }
  }

  static Stream<QuerySnapshot> fetchSessionData(int type) {

    print(SessionManager.loggedInUser.userId);
    if (type ==1 ){
      // tutor
      return _firestore
          .collection("session")
          .where("tutor", isEqualTo: SessionManager.loggedInUser.userId)
          .snapshots();

    } else{
      //student
      return _firestore
          .collection("session")
          .where("student", isEqualTo: SessionManager.loggedInUser.userId)
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

  //TODO: need adjustment after adding tutors to firebase.
  // static Future<MyUser> getUserbyid(String Sessionstudentid, int type) async {
  //   MyUser temp;
  //   if (type == 1) {
  //     // the stream builder needs in homepage needs to wait?
  //     await _firestore.collection('Student').doc(Sessionstudentid).get().then(
  //         (value) => temp = Student(value.data()["name"], value.data()["email"],
  //             value.data()["pass"], "aboutMe", Sessionstudentid));
  //   } else {
  //     return await _firestore
  //         .collection('Tutor')
  //         .doc(Sessionstudentid)
  //         .get()
  //         .then((value) => temp = Tutor(value.data()["name"],
  //             value.data()["email"], value.data()["pass"], "aboutMe", []));
  //   }
  // }

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
}
