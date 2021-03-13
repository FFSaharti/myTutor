import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/material.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/screens/take_quiz_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileStudent extends StatefulWidget {
  @override
  _ProfileStudentState createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
  String _userImage = SessionManager.loggedInStudent.profileImag;

  Function setParentState(String aboutMe) {
    if (this.mounted) {
      setState(() {
        SessionManager.loggedInStudent.aboutMe = aboutMe;
      });
    }
  }

  List<MyMaterial> favDocs = [];

  @override
  void initState() {
    print(
        "FAV MATS IS --> " + SessionManager.loggedInStudent.favMats.toString());

    DatabaseAPI.fetchDocument().then((data) {
      if (data.docs.isNotEmpty) {
        for (var material in data.docs) {
          if (SessionManager.loggedInStudent.favMats.contains(material.id)) {
            if (material.data()['type'] == 1) {
              // DOCUMENT TYPE
              Document tempDoc = Document(
                  material.data()["documentTitle"],
                  material.data()["type"],
                  material.data()["documentUrl"],
                  subjects.elementAt(material.data()["subject"]),
                  material.data()["issuerId"],
                  null,
                  material.data()["documentDesc"],
                  material.data()["fileType"],
                  material.id);
              tempDoc.docid = material.id;
              print("tempDoc id is --> " +
                  tempDoc.docid +
                  " material id is --> " +
                  material.id);
              if (this.mounted) {
                setState(() {
                  favDocs.add(tempDoc);
                });
              }
            } else {
              // QUIZ TYPE

              Quiz tempQ = Quiz(
                  material.data()["issuerId"],
                  material.data()['type'],
                  material.data()['subject'],
                  material.data()['quizTitle'],
                  material.data()['quizDesc'],
                  material.id);
              if (this.mounted) {
                setState(() {
                  favDocs.add(tempQ);
                });
              }
            }
          }
        }
        print("length is --> " + favDocs.length.toString());
      }
    });

    super.initState();
  }

  PDFDocument doc;
  int from = 100;
  int to = 450;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context, kColorScheme[3], "Profile", true),
        body: SafeArea(
          child: Center(
            child: Container(
              width: ScreenSize.width * 0.91,
              height: ScreenSize.height * 0.85,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: ListView(
                  children: [
                    Villain(
                      villainAnimation: VillainAnimation.fade(
                        from: Duration(milliseconds: 100),
                        to: Duration(milliseconds: 500),
                      ),
                      child: Center(
                        child: SessionManager.loggedInStudent.profileImag == ""
                            ? Container(
                                width: ScreenSize.width * 0.30,
                                height: ScreenSize.height * 0.21,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    FilePickerResult file = await FilePicker
                                        .platform
                                        .pickFiles(type: FileType.image);
                                    file == null
                                        ? null
                                        : DatabaseAPI.updateUserProfileImage(
                                                File(file.files.single.path))
                                            .then((value) => {
                                                  setState(() {
                                                    SessionManager
                                                        .loggedInStudent
                                                        .profileImag = value;
                                                  }),
                                                });
                                  },
                                  child: Icon(
                                    Icons.account_circle_sharp,
                                    size: 120,
                                  ),
                                ),
                              )
                            : Container(
                                width: ScreenSize.width * 0.30,
                                height: ScreenSize.height * 0.21,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(SessionManager
                                          .loggedInStudent.profileImag),
                                      fit: BoxFit.fill),
                                ),
                                child: GestureDetector(
                                    onTap: () async {
                                      FilePickerResult file = await FilePicker
                                          .platform
                                          .pickFiles(type: FileType.image);
                                      file == null
                                          ? null
                                          : DatabaseAPI.updateUserProfileImage(
                                                  File(file.files.single.path))
                                              .then((value) => {
                                                    setState(() {
                                                      SessionManager
                                                          .loggedInStudent
                                                          .profileImag = value;
                                                    }),
                                                  });
                                    },
                                    child: Align(
                                      child: Icon(
                                        Icons.edit,
                                        color:
                                            Theme.of(context).iconTheme.color,
                                      ),
                                      alignment: Alignment.bottomRight,
                                    )),
                              ),
                      ),
                    ),
                    Center(
                      child: Text(
                        DatabaseAPI.tempStudent.name,
                        style:
                            GoogleFonts.sen(color: Colors.black, fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    Center(
                      child: Container(
                        width: ScreenSize.width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kColorScheme[3],
                        ),
                        child: Text("Student",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sen(
                                color: Colors.white, fontSize: 21)),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    Divider(
                      color: kGreyish,
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 18,
                            ),
                            SizedBox(
                              width: ScreenSize.width * 0.02,
                            ),
                            Text(
                              "About Me",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Spacer(),
                            (SessionManager.loggedInStudent.aboutMe == '')
                                ? GestureDetector(
                                    onTap: () {
                                      showAboutMe(setParentState);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.01,
                        ),
                        !(SessionManager.loggedInStudent.aboutMe == '')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      SessionManager.loggedInStudent.aboutMe,
                                      style: TextStyle(
                                          fontSize: 16.5,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      showAboutMe(setParentState);
                                    },
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenSize.height * 0.05,
                                  ),
                                ],
                              )
                            : Container(
                                height: ScreenSize.height * 0.05,
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        "No About Me",
                                        style: GoogleFonts.openSans(
                                            color: Colors.grey,
                                            // Theme.of(context).primaryColor,
                                            fontSize: 21),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                    Divider(
                      color: kGreyish,
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    Container(
                      height: ScreenSize.height * 0.5,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite_sharp,
                                size: 18,
                              ),
                              SizedBox(
                                width: ScreenSize.width * 0.02,
                              ),
                              Text(
                                "Bookmarked Materials",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.01,
                          ),
                          Container(
                            height: ScreenSize.height * 0.4,
                            child: ListView(
                              children: getFavDocs(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getFavDocs() {
    List<Widget> widgets = [];

    for (int i = 0; i < favDocs.length; i++) {
      widgets.add(
        Container(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 10, 5, 10),
              child: ListTile(
                leading: Image.asset(subjects[favDocs[i].subjectID].path),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(favDocs[i].title),
                    favDocs[i].type == 1
                        ? Text(
                            (favDocs[i] as Document).fileType.toUpperCase(),
                            style: GoogleFonts.sen(),
                          )
                        : Text(
                            "QUIZ",
                            style: GoogleFonts.sen(),
                          )
                  ],
                ),
                trailing: GestureDetector(
                  onTap: () async {
                    if (favDocs[i].type == 1) {
                      // OPEN-DOWNLOAD DOCUMENT
                      if ((favDocs[i] as Document).fileType == "pdf") {
                        PDFDocument doc = await PDFDocument.fromURL(
                            (favDocs[i] as Document).url);
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Container(
                                height: ScreenSize.height,
                                child:
                                    Scaffold(body: PDFViewer(document: doc)));
                          },
                        );
                      } else {
                        if (await canLaunch((favDocs[i] as Document).url)) {
                          await launch((favDocs[i] as Document).url);
                        }
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakeQuizScreen(
                              favDocs[i] as Quiz, favDocs[i].docid),
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  readPdf(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
            height: ScreenSize.height * 0.90,
            child: PDFViewer(
              document: doc,
            ),
          );
        });
  }

  void downloadFile(int index) async {
    try {
      if (await canLaunch((favDocs.elementAt(index) as Document).url)) {
        await launch((favDocs.elementAt(index) as Document).url);
      } else {
        throw 'Could not launch' + favDocs.elementAt(index).toString();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            e.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
    }
  }

  void showAboutMe(Function setParentState) {
    TextEditingController aboutMeController = TextEditingController();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.vertical(top: Radius.circular(2.0))
            ),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: ScreenSize.height * 0.50,
              child: Scaffold(
                body: Container(
                  //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  height: ScreenSize.height * 0.50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50)
                      //   topRight: Radius.circular(100),
                      //   topLeft: Radius.circular(100),
                      // )
                      ,
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              Text(
                                "About Me",
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  // ADD NEW QUESTION
                                  if (aboutMeController.text.isNotEmpty) {
                                    // ADD ABOUT ME TO STUDENT...
                                    DatabaseAPI.addAboutMeToStudent(
                                            SessionManager.loggedInStudent,
                                            aboutMeController.text)
                                        .then((value) => {
                                              if (value == "Success")
                                                {
                                                  SessionManager.loggedInStudent
                                                          .aboutMe =
                                                      aboutMeController.text,
                                                  setParentState(
                                                      aboutMeController.text),
                                                  Navigator.pop(context),
                                                },
                                              print(value.toString()),
                                            });
                                    print("POP...");
                                  } else {
                                    print("empty parameters");
                                    //TODO: Show error message cannot leave empty...
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "About Me",
                                    style: GoogleFonts.secularOne(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                ),
                                TextField(
                                  controller: aboutMeController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: !(SessionManager.loggedInStudent
                                                .aboutMe.isNotEmpty ||
                                            SessionManager
                                                    .loggedInStudent.aboutMe ==
                                                '')
                                        ? 'Describe yourself briefly...'
                                        : SessionManager
                                            .loggedInStudent.aboutMe,
                                    hintStyle: TextStyle(
                                        fontSize: 17.0, color: Colors.grey),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
