import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/components/material_widget.dart';
import 'package:mytutor/screens/take_quiz_screen.dart';
import 'package:mytutor/screens/tutor_screens/edit_quiz_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialStreamTutor extends StatefulWidget {
  // is same user used to determine if the user should see edit options or not.
  final String tutorId;
  final bool isSameUser;

  const MaterialStreamTutor({this.tutorId, this.isSameUser});

  @override
  _MaterialStreamTutorState createState() => _MaterialStreamTutorState();
}

class _MaterialStreamTutorState extends State<MaterialStreamTutor> {
  @override
  Widget build(BuildContext context) {
    int from = 100;
    int to = 300;
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchAllMaterialsData(widget.tutorId),
      builder: (context, snapshot) {
        // List to fill up with all the session the user has.
        List<Widget> UserMaterials = [];

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          if(widget.isSameUser){
            return Center(child: Text(
              "you don't have any materials", style: GoogleFonts.sen(color: Theme
                .of(context)
                .buttonColor, fontSize: 25,), textAlign: TextAlign.center,),);
          } else{
            return Center(child: Text(
              "This tutor does not have any materials - Yet", style: GoogleFonts.sen(color: Theme
                .of(context)
                .buttonColor, fontSize: 25,), textAlign: TextAlign.center,),);
          }
        }
        else if (snapshot.hasData) {
          List<QueryDocumentSnapshot> materials = snapshot.data.docs;
          for (var material in materials) {
            int materialType = material.data()["type"];

            if (material.data()['issuerId'] == widget.tutorId) {
              // MATERIALS IS HIS....

              if (materialType == 1) {
                // MATERIAL IS DOCUMENT...
                Document tempDoc = Document(
                    material.data()['documentTitle'],
                    material.data()['type'],
                    material.data()['documentUrl'],
                    subjects[material.data()['subject']],
                    material.data()['issuerId'],
                    null,
                    material.data()['documentDesc'],
                    material.data()['fileType'],
                    material.id);
                UserMaterials.add(
                  GestureDetector(
                    onTap: () {
                      // view/edit?
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            print(widget.isSameUser.toString());
                            return Container(
                              height: ScreenSize.height * 0.20,
                              decoration: kCurvedShapeDecoration(
                                  Theme
                                      .of(context)
                                      .scaffoldBackgroundColor),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color:
                                            Theme
                                                .of(context)
                                                .buttonColor,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      Text(
                                        tempDoc.title,
                                        style: GoogleFonts.sen(
                                            fontSize: 19,
                                            color:
                                            Theme
                                                .of(context)
                                                .buttonColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.transparent,
                                          ),
                                          onPressed: () {}),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenSize.height * 0.010,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(23.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      widget.isSameUser == false
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            height: ScreenSize.height * 0.04,
                                            child: RaisedButton(
                                              onPressed: () async {
                                                if (tempDoc.fileType == "pdf") {
                                                  PDFDocument doc =
                                                  await PDFDocument.fromURL(
                                                      tempDoc.url);
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return Container(
                                                          height:
                                                          ScreenSize.height,
                                                          child: Scaffold(
                                                              body: PDFViewer(
                                                                  document:
                                                                  doc)));
                                                    },
                                                  );
                                                } else {
                                                  if (await canLaunch(
                                                      tempDoc.url)) {
                                                    await launch(tempDoc.url);
                                                  }
                                                }
                                              },
                                              child: Text(
                                                "View Document",
                                                style: GoogleFonts.sen(
                                                  textStyle: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.normal,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: kColorScheme[2],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(30.0),
                                              ),
                                            )),
                                        widget.isSameUser == false
                                            ? Container()
                                            : Container(
                                          height:
                                          ScreenSize.height * 0.04,
                                          child: RaisedButton(
                                            onPressed: () {
                                              showBottomSheetForEditDocument(
                                                tempDoc.title,
                                                material.id,
                                              );
                                            },
                                            child: Text(
                                              "Edit Document",
                                              style: GoogleFonts.sen(
                                                textStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            color: kColorScheme[2],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  30.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Villain(
                      villainAnimation: VillainAnimation.fromBottom(
                        from: Duration(milliseconds: from),
                        to: Duration(milliseconds: to),
                      ),
                      child: MaterialWidget(
                        material: tempDoc,
                        matID: material.id,
                      ),
                    ),
                  ),
                );
              } else {
                // MATERIAL IS QUIZ
                UserMaterials.add(
                  GestureDetector(
                    onTap: () {
                      print(material.id);
                      // material.data()['documentTitle'];
                      Quiz tempQuiz = Quiz(
                          material.data()['issuerID'],
                          2,
                          material.data()['subject'],
                          material.data()['quizTitle'],
                          material.data()['quizDesc'],
                          material.id);

                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              height: ScreenSize.height * 0.20,
                              width: ScreenSize.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                                color:
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.cancel),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }),
                                      Text(
                                        tempQuiz.title,
                                        style: GoogleFonts.sen(
                                            fontSize: 19,
                                            color:
                                            Theme
                                                .of(context)
                                                .buttonColor,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.check,
                                            color: Colors.transparent,
                                          ),
                                          onPressed: () {}),
                                    ],
                                  ),
                                  SizedBox(
                                    height: ScreenSize.height * 0.010,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      widget.isSameUser == false
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: ScreenSize.height * 0.04,
                                          child: RaisedButton(
                                            onPressed: () {
                                              // TAKE QUIZ
                                              print("clicked take quiz");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TakeQuizScreen(tempQuiz,
                                                          material.id),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              "Take Quiz",
                                              style: GoogleFonts.sen(
                                                textStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            color: kColorScheme[2],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30.0),
                                            ),
                                          ),
                                        ),
                                        widget.isSameUser == false
                                            ? Container()
                                            : Container(
                                          height:
                                          ScreenSize.height * 0.04,
                                          child: RaisedButton(
                                            onPressed: () {
                                              showBottomSheetForEditQuiz(
                                                tempQuiz.title,
                                                material.id,
                                              );
                                            },
                                            child: Text(
                                              "Edit Quiz",
                                              style: GoogleFonts.sen(
                                                textStyle: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            color: kColorScheme[2],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  30.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Villain(
                      villainAnimation: VillainAnimation.fromBottom(
                        from: Duration(milliseconds: from),
                        to: Duration(milliseconds: to),
                      ),
                      child: MaterialWidget(
                        material: Quiz(
                            SessionManager.loggedInTutor.userId,
                            2,
                            material.data()['subject'],
                            material.data()['quizTitle'],
                            material.data()['quizDesc'],
                            material.id),
                        matID: material.id,
                      ),
                    ),
                  ),
                );
              }
              to += 100;
              from += 100;
            }
          }
        }
        return Expanded(
          child: ListView(
            reverse: false,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: UserMaterials,
          ),
        );
      },
    );
  }

  void showBottomSheetForEditDocument(String title, String id) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
            height: ScreenSize.height * 0.50,
            decoration: kCurvedShapeDecoration(
                Theme
                    .of(context)
                    .scaffoldBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.030,
                  ),
                  Center(
                    child: Text(
                      "Edit [" + title + "]",
                      style: kTitleStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Theme
                              .of(context)
                              .buttonColor),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0090,
                  ),
                  Text(
                    "Title:",
                    style: GoogleFonts.sen(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Theme
                            .of(context)
                            .buttonColor),
                  ),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Theme
                        .of(context)
                        .buttonColor),
                    onChanged: (value) {
                      print(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your new title here....',
                      hintStyle: TextStyle(
                          color:
                          Theme
                              .of(context)
                              .buttonColor
                              .withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                  Text(
                    "Description:",
                    style: GoogleFonts.sen(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Theme
                            .of(context)
                            .buttonColor),
                  ),
                  TextField(
                    controller: descController,
                    style: TextStyle(color: Theme
                        .of(context)
                        .buttonColor),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Type your new description here....',
                      hintStyle: TextStyle(
                          color:
                          Theme
                              .of(context)
                              .buttonColor
                              .withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: ScreenSize.height * 0.04,
                        child: RaisedButton(
                          onPressed: () {
                            if (descController.text.isNotEmpty ||
                                titleController.text.isNotEmpty) {
                              DatabaseAPI.editMaterial(id, titleController.text,
                                  descController.text, 1)
                                  .then((value) =>
                              {
                                value == "success"
                                    ? AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  body: Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Updated successfully',
                                        style:
                                        kTitleStyle.copyWith(
                                            color: Theme
                                                .of(
                                                context)
                                                .buttonColor,
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight
                                                .normal),
                                      ),
                                    ),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show()
                                    : AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.ERROR,
                                  body: Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'erorr',
                                        style:
                                        kTitleStyle.copyWith(
                                            color: Theme
                                                .of(
                                                context)
                                                .buttonColor,
                                            fontSize: 20,
                                            fontWeight:
                                            FontWeight
                                                .normal),
                                      ),
                                    ),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show()
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill all of the information");
                            }
                          },
                          child: Text(
                            "Insert Edit",
                            style: GoogleFonts.sarabun(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                          color: kColorScheme[2],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenSize.height * 0.04,
                        child: RaisedButton(
                          onPressed: () {
                            DatabaseAPI.deleteMaterial(title, id)
                                .then((value) =>
                            {
                              value == "success"
                                  ? AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.SUCCES,
                                body: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Deleted successfully',
                                      style: kTitleStyle.copyWith(
                                          color: Theme
                                              .of(context)
                                              .buttonColor,
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {
                                  int count = 0;
                                  Navigator.popUntil(context,
                                          (route) {
                                        return count++ == 2;
                                      });
                                },
                              ).show()
                                  : AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.ERROR,
                                body: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'erorr',
                                      style: kTitleStyle.copyWith(
                                          color: Theme
                                              .of(context)
                                              .buttonColor,
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {
                                  Navigator.pop(context);
                                },
                              ).show()
                            });
                          },
                          child: Text(
                            "Delete",
                            style: GoogleFonts.sarabun(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void showBottomSheetForEditQuiz(String title, String id) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
            height: ScreenSize.height * 0.50,
            decoration: kCurvedShapeDecoration(
                Theme
                    .of(context)
                    .scaffoldBackgroundColor),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.010,
                  ),
                  Container(
                    width: ScreenSize.width,
                    child: Center(
                      child: Text(
                        "Edit [" + title + "]",
                        style: GoogleFonts.sen(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Theme
                                .of(context)
                                .buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0090,
                  ),
                  Text(
                    "Title:",
                    style: GoogleFonts.sen(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Theme
                            .of(context)
                            .buttonColor),
                  ),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Theme
                        .of(context)
                        .buttonColor),
                    onChanged: (value) {
                      print(value);
                    },
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Type your new title here....',
                      hintStyle: GoogleFonts.sen(
                          color:
                          Theme
                              .of(context)
                              .buttonColor
                              .withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                  Text(
                    "Description:",
                    style: GoogleFonts.sen(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Theme
                            .of(context)
                            .buttonColor),
                  ),
                  TextField(
                    controller: descController,
                    style: TextStyle(color: Theme
                        .of(context)
                        .buttonColor),
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: 'Type your new description here....',
                      hintStyle: GoogleFonts.sen(
                          color:
                          Theme
                              .of(context)
                              .buttonColor
                              .withOpacity(0.6)),
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(
                    color: Theme
                        .of(context)
                        .dividerColor,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.010,
                  ),
                  Row(
                    children: [
                      Text(
                        "Questions:",
                        style: GoogleFonts.sen(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Theme
                                .of(context)
                                .buttonColor),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditQuizScreen(
                                      quizID: id,
                                    )),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          size: 18,
                          color: Theme
                              .of(context)
                              .buttonColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: ScreenSize.height * 0.04,
                        child: RaisedButton(
                          onPressed: () {
                            if (descController.text.isNotEmpty ||
                                titleController.text.isNotEmpty) {
                              DatabaseAPI.editMaterial(id, titleController.text,
                                  descController.text, 2)
                                  .then((value) =>
                              {
                                value == "success"
                                    ? AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  body: Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Updated Successfully',
                                        style: GoogleFonts.sen(
                                            color:
                                            Theme
                                                .of(context)
                                                .buttonColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight
                                                .normal),
                                      ),
                                    ),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show()
                                    : AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.ERROR,
                                  body: Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Error Occured',
                                        style: GoogleFonts.sen(
                                            color:
                                            Theme
                                                .of(context)
                                                .buttonColor,
                                            fontSize: 20,
                                            fontWeight: FontWeight
                                                .normal),
                                      ),
                                    ),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show()
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill all of the information");
                            }
                          },
                          child: Text(
                            "Insert Edit",
                            style: GoogleFonts.sen(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                          color: kColorScheme[2],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenSize.height * 0.04,
                        child: RaisedButton(
                          onPressed: () {
                            DatabaseAPI.deleteMaterial(title, id)
                                .then((value) =>
                            {
                              value == "success"
                                  ? AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.SUCCES,
                                body: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Deleted Successfully',
                                      style: GoogleFonts.sen(
                                          color: Theme
                                              .of(context)
                                              .buttonColor,
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {
                                  int count = 0;
                                  Navigator.popUntil(context,
                                          (route) {
                                        return count++ == 2;
                                      });
                                },
                              ).show()
                                  : AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.ERROR,
                                body: Padding(
                                  padding:
                                  const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'erorr',
                                      style: GoogleFonts.sen(
                                          color: Theme
                                              .of(context)
                                              .buttonColor,
                                          fontSize: 20,
                                          fontWeight:
                                          FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {
                                  Navigator.pop(context);
                                },
                              ).show()
                            });
                          },
                          child: Text(
                            "Delete",
                            style: GoogleFonts.sen(
                              textStyle: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }
}
