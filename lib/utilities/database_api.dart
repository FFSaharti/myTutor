import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mytutor/classes/Student.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';

// Creating the DB Instance...
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DatabaseAPI {
  static MyUser _tempUser = MyUser("", "", "", "");
  String _errorcode = '';

  String get errorcode => _errorcode;

  static MyUser get tempUser => _tempUser;

  static set tempUser(MyUser value) {
    _tempUser = value;
  }

  static Future<String> createUser(int type) async {
    // Type == 0 : Tutor, 1 : Student
    //TODO:catch.
    try {
      UserCredential user = await _auth
          .createUserWithEmailAndPassword(
              email: tempUser.email, password: tempUser.pass)
          .then((value) => value);
      if (user != null) {
        uploadUser(type);
        return "Success";
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static void uploadUser(int type) {
    if (type == 0) {
      _firestore.collection("Tutor").add({
        "email": tempUser.email,
        "pass": tempUser.pass,
        "name": tempUser.name,
      });
    } else if (type == 1) {
      _firestore.collection("Student").add({
        "email": tempUser.email,
        "pass": tempUser.pass,
        "name": tempUser.name,
      });
    }
  }

  static Future<String> userLogin(String email, String pass) async {
    try {
      UserCredential userlogin =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      return e.message + " MISMATCH";
    }
    try {
      await _firestore
          .collection("Student")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => tempUser =
              Student(value.docs.single.data()['name'], email, pass, ""));
      return "Success";
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }

    try {
      await _firestore
          .collection("Tutor")
          .where("email", isEqualTo: email)
          .get()
          .then((value) => tempUser =
              Tutor(value.docs.single.data()['name'], email, pass, ""));
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  static Stream<QuerySnapshot> fetchSessionData() {
    return _firestore
        .collection("session")
        .where("student", isEqualTo: _tempUser.email)
        .snapshots();
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

  //TODO: Adding interests to tutor
  //TODO: fetching interests

}
