import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/components/material_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class MaterialStreamTutor extends StatefulWidget {
  final String tutorId;

  const MaterialStreamTutor({this.tutorId});

  @override
  _MaterialStreamTutorState createState() => _MaterialStreamTutorState();
}

class _MaterialStreamTutorState extends State<MaterialStreamTutor> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchAllMaterialsData(widget.tutorId),
      builder: (context, snapshot) {
        // List to fill up with all the session the user has.
        List<Widget> UserMaterials = [];
        if (snapshot.hasData) {
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
                    material.data()['fileType']);
                UserMaterials.add(
                  GestureDetector(
                    onTap: () {
                      // view/edit?
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0))),
                          context: context,
                          builder: (context) {
                            return Container(
                              height: ScreenSize.height * 0.30,
                              width: ScreenSize.width,
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
                                        tempDoc.title,
                                        style: kTitleStyle.copyWith(
                                            fontSize: 19,
                                            color: Colors.black,
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
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          height: ScreenSize.height * 0.04,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              if(tempDoc.fileType == "pdf"){
                                                PDFDocument doc =
                                                await PDFDocument.fromURL(tempDoc.url);
                                                showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) {
                                                    return Container(
                                                        height: ScreenSize.height,
                                                        child: Scaffold(
                                                            body: PDFViewer(
                                                                document: doc)));
                                                  },
                                                );
                                              } else{
                                                if (await canLaunch(tempDoc.url)) {
                                                  await launch(tempDoc.url);
                                                }
                                              }

                                            },
                                            child: Text(
                                              "View Document",
                                              style: GoogleFonts.sarabun(
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
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: ScreenSize.height * 0.04,
                                          child: RaisedButton(
                                            onPressed: () {
                                              showBottomSheetForEditDocument(
                                               tempDoc.title , material.id,);
                                            },
                                            child: Text(
                                              "Edit Document",
                                              style: GoogleFonts.sarabun(
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
                                                  BorderRadius.circular(15.0),
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
                    child: MaterialWidget(
                      material: tempDoc,
                      matID: material.id,
                    ),
                  ),
                );
              } else {
                // MATERIAL IS QUIZ
                UserMaterials.add(
                  GestureDetector(
                    onTap: () {
                      print(material.id);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => QuestionAnswersScreenStudent(
                      //             Question(qTitle, question.id, qDesc, qDOS,
                      //                 qIssuer, qAnswers, qSubject, qState),
                      //           )),
                      // );
                    },
                    child: MaterialWidget(
                      material: Quiz(
                          SessionManager.loggedInTutor.userId,
                          2,
                          material.data()['subject'],
                          material.data()['quizTitle'],
                          material.data()['quizDesc']),
                      matID: material.id,
                    ),
                  ),
                );
              }
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

  void showBottomSheetForEditDocument(String title , String id) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
            height: ScreenSize.height * 0.50,
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
                          color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0090,
                  ),
                  Text(
                    "title:",
                    style: kTitleStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  TextField(
                    controller: titleController,
                    onChanged: (value) {
                      print(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type your new title here....',
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(),
                  Text(
                    "description:",
                    style: kTitleStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  TextField(
                    controller: descController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      hintText: 'Type your new description here....',
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.090,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: ScreenSize.height * 0.04,
                        child: RaisedButton(
                          onPressed: () {

                            if (descController.text.isNotEmpty || titleController.text.isNotEmpty){
                              DatabaseAPI.editMaterial(id, titleController.text,descController.text).then((value) => {

                                value == "success" ? AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                      'Updated successfully',
                                      style: kTitleStyle.copyWith(color: kBlackish,fontSize: 20,fontWeight: FontWeight.normal),
                                    ),),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show() : AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.ERROR,
                                  body: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: Text(
                                      'erorr',
                                      style: kTitleStyle.copyWith(color: kBlackish,fontSize: 20,fontWeight: FontWeight.normal),
                                    ),),
                                  ),
                                  btnOkOnPress: () {
                                    Navigator.pop(context);
                                  },
                                ).show()
                              });
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

                            DatabaseAPI.deleteMaterial(title,id).then((value) => {
                              value == "success" ? AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.SUCCES,
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(
                                    'Deleted successfully',
                                    style: kTitleStyle.copyWith(color: kBlackish,fontSize: 20,fontWeight: FontWeight.normal),
                                  ),),
                                ),
                                btnOkOnPress: () {
                                  int count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                },
                              ).show() : AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.ERROR,
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(child: Text(
                                    'erorr',
                                    style: kTitleStyle.copyWith(color: kBlackish,fontSize: 20,fontWeight: FontWeight.normal),
                                  ),),
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
}
