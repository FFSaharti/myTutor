import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/session_stream_widget.dart';
import 'package:mytutor/screens/tutor_screens/answer_screen_tutor.dart';
import 'package:mytutor/screens/tutor_screens/create_materials_screen.dart';
import 'package:mytutor/screens/tutor_screens/respond_screen_tutor.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

import '../message_screen.dart';

class HomepageScreenTutor extends StatefulWidget {
  static String id = 'homepage_screen_tutor';

  @override
  _HomepageScreenTutorState createState() => _HomepageScreenTutorState();
}

class _HomepageScreenTutorState extends State<HomepageScreenTutor> {
  List<Widget> widgets = <Widget>[
    HomePageTutor(),
    TutorSection(),
    MessageScreen(),
    ProfileTutor(),
  ];
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
      resizeToAvoidBottomInset: false,
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

class HomePageTutor extends StatefulWidget {
  @override
  _HomePageTutorState createState() => _HomePageTutorState();
}

class _HomePageTutorState extends State<HomePageTutor> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: ScreenSize.height * 0.10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "Welcome,\nTutor ",
                    style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ),
                  TextSpan(
                    text: SessionManager.loggedInTutor.name,
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
            height: ScreenSize.height * 0.04,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  "    Active/Upcoming Sessions",
                  style: GoogleFonts.sarabun(
                      textStyle: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.normal,
                          color: kGreyish)),
                ),
                //
              ],
            ),
          ),

          SessionStream(
            status: "active",
            isStudent: false,
            type: 1,
            checkexpire: false,
            expiredSessionView: false,
          ),
          SizedBox(
            height: ScreenSize.height * 0.05,
          ),
          //SessionWidget(height: height),
        ],
      ),
    );
  }
}

class ProfileTutor extends StatefulWidget {
  @override
  _ProfileTutorState createState() => _ProfileTutorState();
}

class _ProfileTutorState extends State<ProfileTutor> {
  Function setParentState(String aboutMe) {
    setState(() {
      SessionManager.loggedInStudent.aboutMe = aboutMe;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            height: ScreenSize.height * 0.9,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white70),
                    child: Icon(
                      Icons.person,
                      size: 130,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    DatabaseAPI.tempTutor.name,
                    style: kTitleStyle.copyWith(color: kBlackish, fontSize: 30),
                  ),
                ),
                Center(
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kColorScheme[3],
                    ),
                    child: Text(
                      "Tutor",
                      textAlign: TextAlign.center,
                      style: kTitleStyle.copyWith(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileInfoWidget("Sessions", 69.toString()),
                    SizedBox(
                      width: 5,
                    ),
                    ProfileInfoWidget("Rating", 4.5.toString()),
                    SizedBox(
                      width: 5,
                    ),
                    ProfileInfoWidget("Reviews", 69.toString()),
                  ],
                ),
                Divider(
                  color: kGreyish,
                ),
                SizedBox(
                  height: 5,
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
                          width: 5,
                        ),
                        Text(
                          "About Me",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    !(SessionManager.loggedInTutor.aboutMe == '')
                        ? Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              SessionManager.loggedInTutor.aboutMe,
                              style:
                                  TextStyle(fontSize: 16.5, color: kGreyerish),
                            ),
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
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Experiences",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      // child: Text(SessionManager.loggedInTutor.experiences[0]
                      //     .toString()),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: getExperiences(),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: kGreyish,
                ),
                Container(
                  height: ScreenSize.height * 0.5,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.local_library_outlined,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Materials",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      MaterialStreamTutor(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getExperiences() {
    List<Widget> widgets = [];
    List<Subject> experiences = [];

    for (int i = 0; i < SessionManager.loggedInTutor.experiences.length; i++) {
      for (int j = 0; j < subjects.length; j++) {
        if (SessionManager.loggedInTutor.experiences[i] == subjects[j].id) {
          experiences.add(subjects[j]);
        }
      }
    }

    for (int i = 0; i < experiences.length; i++) {
      widgets.add(SubjectWidget(experiences[i]));
      widgets.add(SizedBox(width: 9));
    }

    return widgets;
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
                              // TODO : Add edit button to edit about me anytime...
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  // ADD NEW QUESTION
                                  if (aboutMeController.text.isNotEmpty) {
                                    // ADD ABOUT ME TO STUDENT...
                                    DatabaseAPI.addAboutMeToTutor(
                                            SessionManager.loggedInTutor,
                                            aboutMeController.text)
                                        .then((value) => {
                                              if (value == "Success")
                                                {
                                                  SessionManager.loggedInTutor
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
                                    hintText: 'Describe yourself briefly...',
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

class ProfileInfoWidget extends StatelessWidget {
  ProfileInfoWidget(this.infoTitle, this.infoNum);

  String infoTitle = "";
  String infoNum = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffF5F5F5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                infoTitle,
                style: TextStyle(color: kGreyerish, fontSize: 18),
              ),
              Text(
                infoNum,
                style: TextStyle(color: kBlackish, fontSize: 18),
              ),
            ]),
      ),
    );
  }
}

class SubjectWidget extends StatefulWidget {
  Subject subject;

  SubjectWidget(this.subject);

  @override
  _SubjectWidgetState createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          widget.subject.path,
          width: 40,
        ),
      ),
    );
  }
}

class TutorSection extends StatefulWidget {
  double height;
  double width;

  @override
  _TutorSectionState createState() => _TutorSectionState();
}

class _TutorSectionState extends State<TutorSection> {
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
            "Tutor",
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
                TutorSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked answer");
                    Navigator.pushNamed(context, AnswerScreenTutor.id);
                  },
                  imgPath: "images/Tutor_Section/Answer_Logo.png",
                  title: "Answer",
                  description:
                      "Answer questions that are posted by \nStudents.",
                ),
                SizedBox(
                  height: 20,
                ),
                TutorSectionWidget(
                  widget: widget,
                  onClick: () {
                    print("clicked Respond");
                    Navigator.pushNamed(context, RespondScreenTutor.id);
                  },
                  imgPath: "images/Tutor_Section/Respond_Logo.png",
                  title: "Respond",
                  description:
                      "Respond to request send by \nStudents for creating a session \nwith you!!",
                ),
                SizedBox(
                  height: 20,
                ),
                TutorSectionWidget(
                  widget: widget,
                  onClick: () {
                    Navigator.pushNamed(context, CreateMaterialsScreen.id);
                  },
                  imgPath: "images/Tutor_Section/Subject_Logo.png",
                  title: "Create Materials",
                  description:
                      "Share Materials & Create \nQuizzes with Students that can \nbe bookmarked & taken.",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TutorSectionWidget extends StatelessWidget {
  TutorSectionWidget(
      {@required this.widget,
      @required this.onClick,
      @required this.imgPath,
      @required this.title,
      @required this.description});

  final TutorSection widget;
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
