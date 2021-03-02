import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/material.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/components/session_stream_widget.dart';
import 'package:mytutor/screens/student_screens/request_tutor_screen.dart';
import 'package:mytutor/screens/student_screens/view_materials_screen.dart';
import 'package:mytutor/screens/take_quiz_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../message_screen.dart';
import 'ask_screen_student.dart';

class HomepageScreenStudent extends StatefulWidget {
  static String id = 'homepage_screen_student';

  @override
  _HomepageScreenStudentState createState() => _HomepageScreenStudentState();
}

class _HomepageScreenStudentState extends State<HomepageScreenStudent> {
  List<Widget> widgets = <Widget>[
    HomePageStudent(),
    StudentSection(),
    MessageScreen(),
    ProfileStudent()
  ];
  double width;
  double height;
  int _navindex = 0;

  void changeindex(int index) {
    setState(() {
      _navindex = index;
      print(_navindex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chalkboardTeacher), label: "student"),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: "messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
        currentIndex: _navindex,
        onTap: changeindex,
        selectedItemColor: kColorScheme[3],
      ),
      body: widgets.elementAt(_navindex),
    );
  }
}

class HomePageStudent extends StatefulWidget {
  @override
  _HomePageStudentState createState() => _HomePageStudentState();
}

class _HomePageStudentState extends State<HomePageStudent> {
  PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Homepage",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Welcome,\nStudent ",
                      style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
                    ),
                    TextSpan(
                      text: DatabaseAPI.tempStudent.name,
                      style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            Container(
              height: ScreenSize.height * 0.54,
              child: NotificationListener<OverscrollIndicatorNotification>(
                // ignore: missing_return
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: PageView(
                  controller: _pageController,
                  children: [
                    mainScreenPage(
                        SessionStream(
                          status: "active",
                          type: 0,
                          checkexpire: false,
                          isStudent: true,
                          expiredSessionView: false,
                        ),
                        "Upcoming Sessions"),
                    mainScreenPage(
                        SessionStream(
                          status: "pending",
                          type: 0,
                          checkexpire: false,
                          isStudent: true,
                          expiredSessionView: false,
                        ),
                        "Pending Sessions"),
                    mainScreenPage(
                        SessionStream(
                          status: "waiting for student",
                          type: 0,
                          checkexpire: false,
                          isStudent: true,
                          expiredSessionView: false,
                        ),
                        "waiting for your response"),
                    mainScreenPage(
                        SessionStream(
                          status: "closed",
                          type: 0,
                          checkexpire: false,
                          isStudent: true,
                          expiredSessionView: true,
                        ),
                        "Closed Sessions"),
                  ],
                ),
              ),
            ),
            SmoothPageIndicator(
              effect: WormEffect(
                  dotColor: kGreyish, activeDotColor: kColorScheme[2]),
              controller: _pageController, // PageController
              count: 4,
            ),
          ],
        ),
      ),
    );
  }

  mainScreenPage(Widget StreamWidget, String title) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "    " + title,
            style: GoogleFonts.sarabun(
                textStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.normal,
                    color: kGreyish)),
          ),
        ),
        StreamWidget,
        SizedBox(
          height: ScreenSize.height * 0.05,
        ),
      ],
    );
  }
}

class StudentSection extends StatefulWidget {
  double height;
  double width;

  @override
  _StudentSectionState createState() => _StudentSectionState();
}

class _StudentSectionState extends State<StudentSection> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widget.width = mediaQueryData.size.width;
    widget.height = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Student",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Select an option",
                  style: GoogleFonts.sarala(fontSize: 25, color: kGreyerish),
                ),
                SizedBox(
                  height: 20,
                ),
                StudentSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked ASK");
                    Navigator.pushNamed(context, AskScreenStudent.id);
                  },
                  imgPath: "images/Student_Section/Ask_Logo.png",
                  title: "Ask",
                  description:
                      "Post questions that can be viewed and \nanswered by tutors!",
                ),
                SizedBox(
                  height: 20,
                ),
                StudentSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked REQUEST");
                    Navigator.pushNamed(context, RequestTutorScreen.id);
                  },
                  imgPath: "images/Student_Section/Request_Logo.png",
                  title: "Request",
                  description:
                      "Search for Tutors with a variety of \nfilters and request them!",
                ),
                SizedBox(
                  height: 20,
                ),
                StudentSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked MATERIALS");
                    Navigator.pushNamed(context, ViewMaterialsScreen.id);
                  },
                  imgPath: "images/Student_Section/Materials_Logo.png",
                  title: "Materials",
                  description:
                      "Search for Materials posted by \nother Tutors and bookmark them",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentSectionWidget extends StatelessWidget {
  StudentSectionWidget(
      {@required this.widget,
      @required this.onClick,
      @required this.imgPath,
      @required this.title,
      @required this.description});

  final StudentSection widget;
  final Function onClick;
  final String imgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: widget.width * 0.8,
        decoration: BoxDecoration(
          color: kWhiteish,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                imgPath,
                width: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.sarala(fontSize: 25, color: kBlackish),
                  ),
                  Text(
                    description,
                    style: GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileStudent extends StatefulWidget {
  @override
  _ProfileStudentState createState() => _ProfileStudentState();
}

class _ProfileStudentState extends State<ProfileStudent> {
  String _userImage = SessionManager.loggedInStudent.profileImag;
  Function setParentState(String aboutMe) {
    setState(() {
      SessionManager.loggedInStudent.aboutMe = aboutMe;
    });
  }

  List<MyMaterial> favDocs = [];

  @override
  void initState() {
    // TODO: implement initState

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
              setState(() {
                favDocs.add(tempDoc);
              });
            } else {
              // QUIZ TYPE

              Quiz tempQ = Quiz(
                  material.data()["issuerId"],
                  material.data()['type'],
                  material.data()['subject'],
                  material.data()['quizTitle'],
                  material.data()['quizDesc'],
                  material.id);
              setState(() {
                favDocs.add(tempQ);
              });
            }
          }
        }
        print("length is --> " + favDocs.length.toString());
      }
    });
    super.initState();
  }

  PDFDocument doc;

  @override
  Widget build(BuildContext context) {
    print("here" +
        (SessionManager.loggedInStudent.profileImag == null).toString());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Profile",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: ScreenSize.width * 0.91,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: SessionManager.loggedInStudent.profileImag == null
                      ? Container(
                          width: ScreenSize.width * 0.30,
                          height: ScreenSize.height * 0.21,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              FilePickerResult file = await FilePicker.platform
                                  .pickFiles(type: FileType.image);
                              file == null
                                  ? null
                                  : DatabaseAPI.updateUserProfileImage(
                                      File(file.files.single.path));
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
                                image: NetworkImage(
                                    SessionManager.loggedInStudent.profileImag),
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
                                        File(file.files.single.path));
                                setState(() {});
                              },
                              child: Align(
                                child: Icon(Icons.edit),
                                alignment: Alignment.bottomRight,
                              )),
                        ),
                ),
                Text(
                  SessionManager.loggedInStudent.name,
                  style: kTitleStyle.copyWith(color: kBlackish, fontSize: 30),
                ),
                Center(
                  child: Container(
                    width: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kColorScheme[3],
                    ),
                    child: Text(
                      "Student",
                      textAlign: TextAlign.center,
                      style: kTitleStyle.copyWith(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Divider(
                  color: kGreyish,
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "About Me",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    !(SessionManager.loggedInStudent.aboutMe == '')
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  SessionManager.loggedInStudent.aboutMe,
                                  style: TextStyle(
                                      fontSize: 16.5, color: kGreyerish),
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.edit),
                                iconSize: 20,
                                onPressed: () {
                                  showAboutMe(setParentState);
                                },
                              ),
                            ],
                          )
                        : Container(
                            height: ScreenSize.height * 0.17,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: Text(
                                    "No \"About me\" :( ",
                                    style: TextStyle(
                                        fontSize: 16.5, color: kGreyerish),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                EZButton(
                                    width: ScreenSize.width * 0.5,
                                    buttonColor: null,
                                    textColor: Colors.white,
                                    isGradient: true,
                                    colors: [kColorScheme[0], kColorScheme[3]],
                                    buttonText: "Set An About Me",
                                    hasBorder: false,
                                    borderColor: null,
                                    onPressed: () {
                                      print("pressed set about me");
                                      showAboutMe(setParentState);
                                      // setState(() {});
                                    })
                              ],
                            ),
                          ),
                  ],
                ),
                Divider(
                  color: kGreyish,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_outline_sharp,
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Bookmarked Materials",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favDocs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.asset(
                                (subjects[favDocs.elementAt(index).subjectID])
                                    .path),
                            title: Text(favDocs.elementAt(index).title),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: GestureDetector(
                                    child: Icon(Icons.visibility),
                                    onTap: () {
                                      // open the file reader if the file is pdf, else let the user download the file
                                      if (favDocs.elementAt(index).type == 1) {
                                        (favDocs.elementAt(index) as Document)
                                                    .fileType ==
                                                "pdf"
                                            ? PDFDocument.fromURL(
                                                    (favDocs.elementAt(index)
                                                            as Document)
                                                        .url)
                                                .then((value) => {
                                                      doc = value,
                                                      readPdf(index),
                                                    })
                                            : downloadFile(index);
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TakeQuizScreen(
                                                      favDocs.elementAt(index),
                                                      favDocs
                                                          .elementAt(index)
                                                          .docid)),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
