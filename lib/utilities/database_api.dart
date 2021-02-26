import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:mytutor/classes/answer.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/question.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/utilities/session_manager.dart';

import 'constants.dart';

// Creating the DB Instance...
FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
firebase_storage.UploadTask uploadTask;
firebase_storage.Reference ref;

class DatabaseAPI {
  static MyUser _tempUser = MyUser("", "", "", "", "", "");
  static Tutor _tempTutor = Tutor("", "", "", "", "", [], "");
  static Student _tempStudent = Student("", "", "", "", "", [], "");
  static File _tempFile;

  static File get tempFile => _tempFile;

  static set tempFile(File value) {
    _tempFile = value;
  }

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

  static Student get tempStudent => _tempStudent;

  static set tempStudent(Student value) {
    _tempStudent = value;
  }

  // user log/sign up
  static Future<String> createStudent() async {
    try {
      UserCredential user = await _auth
          .createUserWithEmailAndPassword(
              email: tempUser.email, password: tempUser.pass)
          .then((value) => value);
      if (user != null) {
        if (tempFile == null) {
          // the user didn't pick any image
          tempUser.profileImag = "";
          uploadUser();
          _tempStudent = Student(tempUser.name, tempUser.email, tempUser.pass,
              "", "", [], tempUser.profileImag);
          SessionManager.loggedInStudent = _tempStudent;
        } else {
          await uploadUserProfileImage();
          uploadUser();
          _tempStudent = Student(tempUser.name, tempUser.email, tempUser.pass,
              "", "", [], tempUser.profileImag);
          SessionManager.loggedInStudent = _tempStudent;
        }

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
      "questions": [],
      "aboutMe": "",
      "profileImg": tempUser.profileImag,
    });
  }

  static Future<String> resetUserPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // user profile image methods
  static Future<String> uploadUserProfileImage() async {
    try {
      ref =
          firebase_storage.FirebaseStorage.instance.ref().child(tempUser.name);
      uploadTask = ref.putData(tempFile.readAsBytesSync());
      String url =
          await (await uploadTask.then((value) => value.ref.getDownloadURL()));
      tempUser.profileImag = url;
      // await uplodeDocumentToTutorCollection(document);
      return "done";
    } on FirebaseException catch (e) {
      return "error";
    }
  }

  static void updateUserProfileImage(File newImage) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(SessionManager.loggedInUser.name);
    uploadTask = ref.putData(newImage.readAsBytesSync());
    String url =
        await (await uploadTask.then((value) => value.ref.getDownloadURL()));

    // change the url on the user table
    if (SessionManager.loggedInTutor.userId == "") {
      SessionManager.loggedInStudent.profileImag = url;
      await _firestore
          .collection("Student")
          .doc(SessionManager.loggedInUser.userId)
          .update({"profileImg": url});
    } else {
      SessionManager.loggedInTutor.profileImag = url;
      await _firestore
          .collection("Tutor")
          .doc(SessionManager.loggedInUser.userId)
          .update({"profileImg": url});
    }
  }

  static Future<String> userLogin(String email, String pass) async {
    String status = '';
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
          .then((value) async => {
                if (value.docs.isNotEmpty)
                  {
                    tempStudent = Student(
                        value.docs.single.data()['name'],
                        email,
                        pass,
                        value.docs.single.data()['aboutMe'],
                        value.docs.single.id,
                        [],
                        value.docs.single.data()['profileImg']),
                    tempStudent.favMats =
                        value.docs.single.data()['listOfFavMats'],
                    List.from(value.docs.single.data()['questions'])
                        .forEach((element) {
                      print("QUESTION PRINTING ... " + element.toString());
                      buildQuestion(element.toString(), tempStudent);
                    }),
                    SessionManager.loggedInUser = _tempStudent,
                    SessionManager.loggedInStudent = _tempStudent,
                    status = "Student Login",
                  }
                else
                  {
                    await _firestore
                        .collection("Tutor")
                        .where("email", isEqualTo: email)
                        .get()
                        .then((value) => {
                              _tempTutor = Tutor(
                                  value.docs.single.data()['name'],
                                  email,
                                  pass,
                                  value.docs.single.data()['aboutMe'],
                                  value.docs.single.id,
                                  [],
                                  value.docs.single.data()['profileImg']),
                              List.from(value.docs.single.data()['experiences'])
                                  .forEach((element) {
                                print("Subject PRINTING ... " +
                                    element.toString());
                                _tempTutor.addExperience(element);
                              })
                            }),
                    SessionManager.loggedInUser = _tempTutor,
                    SessionManager.loggedInTutor = _tempTutor,
                    status = "Tutor Login",
                  }
              });

      return status;
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

  static void buildQuestion(String questionDocID, Student tempStudent) async {
    Question tempQuestion = Question("", "", "", "", _tempStudent, [], "", "");
    print("Build Question ... questiondocId is ---> " +
        questionDocID.substring(27, questionDocID.length - 1));

    if (questionDocID.length > 20) {
      if (questionDocID.length > 30) {
        questionDocID = questionDocID.substring(27, questionDocID.length - 1);
      } else {
        questionDocID = questionDocID.substring(10);
        print("ELSE PRINTING..." + questionDocID);
      }
    }

    print("QUESTION DOC ID ... " + questionDocID);

    await _firestore
        .collection("Question")
        .doc(questionDocID)
        .get()
        .then((value) => {
              print("QUESTION VALUE ... --> " + value.data().toString()),

              tempQuestion = Question(
                  value.data()["title"],
                  value.id,
                  value.data()["description"],
                  value.data()['dateOfSubmission'],
                  _tempStudent,
                  [],
                  value.data()['subject'].toString(),
                  value.data()['state']),

              print("QUESTION TITLE ... " + tempQuestion.title),

              List.from(value.data()['answers']).forEach((element) {
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
    Answer tempAnswer = Answer(
      "",
      Tutor("TEST-BABA", "", "pass", "aboutMe", "userid", [], ""),
      "",
    );
    String answer = '';
    String tutorID = '';
    String date = '';
    await _firestore.collection("Answer").doc(answerID).get().then((value) => {
          print("ANSWER PRINTING..." + value.data()['answer']),
          print("TUTOR ID is  --> " +
              value
                  .data()['Tutor']
                  .toString()
                  .substring(24, value.data()['Tutor'].toString().length - 1)),
          answer = value.data()['answer'],
          date = value.data()['date'],
          tutorID = value
              .data()['Tutor']
              .toString()
              .substring(24, value.data()['Tutor'].toString().length - 1),
          buildTutor(tutorID).then((value) => {
                tempTutor = value,
                tempAnswer = Answer(answer, tempTutor, date),
                tempQuestion.addAnswer(tempAnswer),
              }),
        });
  }

  static Future<Tutor> buildTutor(String tutorID) async {
    await _firestore.collection("Tutor").doc(tutorID).get().then((value) => {
          print("TUTOR IS ....... " + value.data()['name']),
          tempTutor = Tutor(
              value.data()['name'],
              value.data()['email'],
              value.data()['pass'],
              "",
              value.id,
              [],
              value.data()["profileImg"]),
          List.from(value.data()['experiences']).forEach((element) {
            print(
                "EXPERIENCES OF TUTOR ARE PRINTING ... " + element.toString());
            tempTutor.addExperience(element);
          }),
        });

    return tempTutor;
  }

  static Future<String> createTutor(tutorEmail) async {
    List<int> subjectIDs = getSubjects();

    // check the file
    if (tempFile == null)
      tempUser.profileImag == "";
    else {
      uploadUserProfileImage();
    }
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
            "experiences": subjectIDs,
            "profileImg": tempUser.profileImag,
            "aboutMe": "",
          });
          _tempTutor = Tutor(tempUser.name, tempUser.email, tempUser.pass, "",
              "", subjectIDs, tempUser.profileImag);
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

  static Future<QuerySnapshot> getTutorRates(String tutorid) async {
    return await _firestore
        .collection("Tutor")
        .doc(tutorid)
        .collection("rate")
        .orderBy("rateDate", descending: true)
        .get();
  }

  // session related

  static Future<QuerySnapshot> getTutors() async {
    return await _firestore.collection("Tutor").get();
  }

  static void createNewSession(String title, String problemDesc,
      String prefDate, MyUser tutor, String time) async {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(prefDate);
    await _firestore.collection("session").add({
      'student': SessionManager.loggedInStudent.userId,
      'description': problemDesc,
      'title': title,
      'tutor': tutor.userId,
      'date': tempDate,
      'time': time,
      'status': "pending",
      'lastMessage': "Start texting here...",
      'timeOfLastMessage': DateTime.now(),
    });
  }

  static Stream<QuerySnapshot> getSessionForMessageScreen(int type) {
    // type 1 current user that login in is tutor , type 0 current user that login in is student

    if (type == 1)
      return _firestore
          .collection("session")
          .where("tutor", isEqualTo: SessionManager.loggedInTutor.userId)
          .where("status", isEqualTo: "active")
          .orderBy("timeOfLastMessage", descending: true)
          .snapshots();
    else
      return _firestore
          .collection("session")
          .where("student", isEqualTo: SessionManager.loggedInStudent.userId)
          .where("status", isEqualTo: "active")
          .orderBy("timeOfLastMessage", descending: true)
          .snapshots();
  }

  static Stream<QuerySnapshot> fetchSessionData(int type, bool checkexpire) {
    // check the session that expired.

    if (checkexpire == true) {
      checkAndUpdateExpiredSession();
    }
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
          .where("student", isEqualTo: SessionManager.loggedInStudent.userId)
          .snapshots();
    }
  }

  static Future<Stream<QuerySnapshot>> checkAndUpdateExpiredSession() async {
    // check the session that expired.
    await _firestore
        .collection("session")
        .where("date", isLessThan: DateTime.now())
        .get()
        .then(
            (QuerySnapshot querySnapshot) => querySnapshot.docs.forEach((doc) {
                  Timestamp t = doc["date"];
                  // change the status
                  changeSessionsStatus("expired", doc.id);
                }));
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
    _firestore.collection("session").doc(sessionid).update({
      'lastMessage': msg,
      'timeOfLastMessage': DateTime.now(),
    });
  }

  static Future<DocumentSnapshot> getUserbyid(String userID, int type) async {
    // type 1 = student , type 0 = tutor
    if (type == 1) {
      // student
      return await _firestore.collection('Student').doc(userID).get();
    } else if (type == 0) {
      // tutor
      return await _firestore.collection('Tutor').doc(userID).get();
    }
  }

  static Future<String> changeSessionsStatus(
      String status, String sessionid) async {
    // main status (pending-expired-active-closed-decline)
    await _firestore
        .collection("session")
        .doc(sessionid)
        .update({'status': status});
  }

  // chat screen related.

  static Future<QuerySnapshot> getLastMessage(String sessionId) async {
    return _firestore
        .collection("session")
        .doc(sessionId)
        .collection("messages")
        .orderBy("time", descending: true)
        .limit(1)
        .get();
  }

  static void rateTutor(Rate rate, String tutorId) {
    _firestore.collection("Tutor").doc(tutorId).collection("rate").add({
      'teachingSkills': rate.teachingSkills,
      'communication': rate.communicationSkills,
      'friendliness': rate.friendliness,
      'creativity': rate.creativity,
      'review': rate.review,
      'rateDate': rate.date,
      'sessionTitle': rate.sessionTitle,
    });
  }

  static Future<QuerySnapshot> getSessionNumber(String tutorId) {
    return _firestore
        .collection("session")
        .where("tutor", isEqualTo: tutorId)
        .get();
  }

  // document related

  static void uplodeDocumentToTutorCollection(Document document) async {
    await _firestore.collection("Material").add({
      "documentTitle": document.title,
      "documentDesc": document.description,
      "type": 1,
      "subject": document.subject.id,
      "documentUrl": document.url,
      "issuerId": document.issuer,
      "fileType": document.fileType,
    });
  }

  static Future<String> uploadFileToStorage(Document document) async {
    try {
      firebase_storage.UploadTask uploadTask;
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(document.title);
      uploadTask = ref.putData(document.file.readAsBytesSync());
      String url =
          await (await uploadTask.then((value) => value.ref.getDownloadURL()));
      document.url = url;
      await uplodeDocumentToTutorCollection(document);
      return "done";
    } on FirebaseException catch (e) {
      return "error";
    }
  }

  static Future<QuerySnapshot> fetchDocument() {
    return _firestore.collection("Material").get();
  }

  static Future<String> addQuestionToStudent(String questionTitle,
      String questionDesc, Student loggedInStudent, int chosenSubject) async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);

    String questionID = '';

    await _firestore
        .collection("Student")
        .where("email", isEqualTo: loggedInStudent.email)
        .get()
        .then((value) async => {
              print("PRINTED STUDENT IS ---> " + value.docs.single.id),
              await _firestore.collection("Question").add({
                "title": questionTitle,
                "subject": chosenSubject,
                "state": 'Active',
                "issuer": value.docs.single.id.toString(),
                "description": questionDesc,
                "dateOfSubmission": formatted,
                "answers": []
              }).then((value) async => {
                    await _firestore
                        .collection("Question")
                        .doc(value.id)
                        .update({"doc_id": value.id}),
                    questionID = value
                        .toString()
                        .substring(27, value.toString().length - 1),
                    print("QUESTION ID IS --> " + questionID),
                  }),
              loggedInStudent.addQuestion(Question(
                  questionTitle,
                  "",
                  questionDesc,
                  formatted,
                  loggedInStudent,
                  [],
                  chosenSubject.toString(),
                  "Active")),
              await _firestore
                  .collection("Student")
                  .doc(value.docs.single.id)
                  .update({
                'questions': FieldValue.arrayUnion(['/Question/' + questionID])
              })
            });

    return "Success";
  }

  static Stream<QuerySnapshot> fetchQuestionData(String status) {
    return _firestore
        .collection("Question")
        .where("issuer", isEqualTo: SessionManager.loggedInStudent.userId)
        .snapshots();
  }

  static Future<DocumentSnapshot> getQuestion(Question question) async {
    return await _firestore.collection("Question").doc(question.id).get();
  }

  static Future<DocumentSnapshot> getAnswer(var data) async {
    return await _firestore.collection("Answer").doc(data.toString()).get();
  }

  static Stream<DocumentSnapshot> getAnswers(var data) {
    List<Answer> answers = [
      Answer(
          "", Tutor("TEST-BABA", "", "pass", "aboutMe", "userid", [], ""), "")
    ];
    String tempAnswer = '';
  }

  static Future<DocumentSnapshot> getTutor(String tutorID) {
    return _firestore.collection("Tutor").doc(tutorID).get();
  }

  static void closeQuestion(Question question) async {
    await _firestore
        .collection("Question")
        .doc(question.id)
        .update({"state": "Closed"});
  }

  static Future<String> addAboutMeToStudent(
      Student loggedInStudent, String aboutMe) async {
    String status = 'Fail';
    await _firestore
        .collection("Student")
        .doc(loggedInStudent.userId)
        .update({"aboutMe": aboutMe}).then((value) => {status = "Success"});

    return status;
  }

  static Stream<QuerySnapshot> fetchQuestionsForTutor() {
    return _firestore.collection("Question").snapshots();
  }

  static Future<void> answerQuestion(Question question, String text) async {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    String answerID;

    await _firestore.collection("Answer").add({
      "Tutor": SessionManager.loggedInTutor.userId,
      "answer": text,
      "date": formatted,
    }).then((value) => {
          answerID = value.id,
          _firestore
              .collection("Answer")
              .doc(value.id.toString())
              .update({"doc_id": value.id.toString()}).then((value) => {
                    _firestore.collection("Question").doc(question.id).update({
                      'answers': FieldValue.arrayUnion([answerID.toString()])
                    }),
                  })
        });
  }

  static Future<String> createAndUploadQuiz(
      String quizTitle,
      Subject subjectIndex,
      String userId,
      String quizDesc,
      Quiz tempQuiz) async {
    try {
      _firestore.collection("Quiz").add({
        'quizTitle': quizTitle,
        'quizDesc': quizDesc,
        'subject': subjectIndex.id,
        'type': 2,
        'issuerId': SessionManager.loggedInTutor.userId
      }).then((quiz) => {
            // do here
            List.from(tempQuiz.questions).forEach((question) {
              _firestore.collection("QuizQuestion").add({
                'questionTitle': question.question,
                'correctAnswerIndex': question.correctAnswerIndex,
                'answers': question.answers
              }).then((questionBack) => {
                    _firestore.collection("Quiz").doc(quiz.id).update({
                      'listOfQuestions':
                          FieldValue.arrayUnion([questionBack.id.toString()])
                    })
                  });
            }),

            // _firestore
            //     .collection("Tutor")
            //     .doc(userId)
            //     .collection("Materials")
            //     .add({'type': 2, 'quizId': quiz.id})
          });
      return "done";
    } on FirebaseException catch (e) {
      return "error";
    }
  }

  static Future<String> addAboutMeToTutor(
      Tutor loggedInTutor, String aboutMe) async {
    String status = 'Fail';
    await _firestore
        .collection("Tutor")
        .doc(loggedInTutor.userId)
        .update({"aboutMe": aboutMe}).then((value) => {status = "Success"});

    return status;
  }

  static Stream<QuerySnapshot> fetchAllMaterialsData(String tutorid) {
    // return _firestore.collection("Quiz").snapshots();
    return _firestore
        .collection("Material")
        .where("issuerId", isEqualTo: tutorid)
        .snapshots();
  }

  static Future<String> addMaterialToFavorites(Document doc) async {
    String status = "done";
    await _firestore
        .collection("Student")
        .doc(SessionManager.loggedInStudent.userId)
        .update({
      'listOfFavMats': FieldValue.arrayUnion([doc.docid])
    });

    return status;
  }

// static Future<QuerySnapshot> fetchFavDocs() {
//   return _firestore.collection("Material").get();
// }
}
