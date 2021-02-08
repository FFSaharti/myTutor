import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mytutor/classes/Student.dart';


FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;


class DatabaseHelper {

   static Student stu = Student("","","");
   String _errorcode = '';

   String get errorcode => _errorcode;

  set errorcode(String value) {
    _errorcode = value;
  }

  void createUser() async {
//TODO:catch.

    UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: stu.email, password: stu.pass);
    if (user == null) {
      return;
    } else {
      uplodeuser();
    }
  }

  void uplodeuser() {
    _firestore.collection("Student").add({
      "email": stu.email,
      "pass": stu.pass,
      "name": stu.name,
    });
  }

  Future<String> userLogin(String email, String pass) async {

    try {
      UserCredential userlogin = await _auth.signInWithEmailAndPassword(
          email: email, password: pass);
      await _firestore.collection("Student").where("email", isEqualTo: email).get().then((value) => stu = Student(value.docs.single.data()['name'], email, pass));
      return "signin";
    }
    on FirebaseAuthException catch (e) {
     return e.code;
    }
  }


   Stream<QuerySnapshot> fetchSessionData(){
    return _firestore.collection("session").where("student", isEqualTo: stu.email).snapshots();
  }

   Stream<QuerySnapshot> fetchSessionMessages(String sessionid){
     return _firestore.collection('session').doc(sessionid).collection("messages").orderBy("time", descending: true).snapshots();
   }


   void saveNewMessage(String sessionid , String msg , String sender){
    _firestore.collection("session").doc(sessionid).collection("messages").add({
      'text': msg,
      'sender': sender,
      'time': DateTime.now(),
    });
  }




}
