import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/profile_info_widget.dart';
import 'package:mytutor/screens/view_reviews_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

import 'interests_screen.dart';

//TODO: the whole screen can be manage with view Tutor Profile Screen.
class tutorProfile extends StatefulWidget {
  @override
  _tutorProfileState createState() => _tutorProfileState();
}

class _tutorProfileState extends State<tutorProfile> {
  List<Rate> tutorRates = [];
  String sessionNumHelper = "";
  String reviewHelper = "";
  bool finishedLoadingTutorRate = false;

  Function setParentState(String aboutMe) {
    setState(() {
      SessionManager.loggedInTutor.aboutMe = aboutMe;
    });
  }

  Function setParentStateInt() {
    setState(() {});
  }

  Function setParentStateEx() {
    List<int> chosenSubjects = [];

    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].chosen) {
        chosenSubjects.add(subjects[i].id);
      }
    }

    setState(() {
      SessionManager.loggedInTutor.experiences = chosenSubjects;
    });
  }

  void initState() {
    Timestamp stamptemp;
    int reviewSum = 0;
    //load more information about the tutors, since rate/review need one more query to do we will do it here.
    DatabaseAPI.getTutorRates(SessionManager.loggedInTutor.userId)
        .then((value) => {
              if (value.docs.isNotEmpty)
                {
                  for (var rate in value.docs)
                    {
                      stamptemp = rate.data()["rateDate"],
                      tutorRates.add(Rate(
                        rate.data()["review"],
                        rate.data()["teachingSkills"],
                        rate.data()["friendliness"],
                        rate.data()["communication"],
                        rate.data()["creativity"],
                        stamptemp.toDate(),
                        rate.data()["sessionTitle"],
                      )),
                    },
                  if (this.mounted)
                    {
                      for (Rate rate in tutorRates)
                        {if (rate.review != null) reviewSum++},
                      setState(() {
                        reviewHelper = reviewSum.toString();
                        finishedLoadingTutorRate = true;
                      }),
                    }
                }
            });

    // get the session num
    DatabaseAPI.getSessionNumber(SessionManager.loggedInTutor.userId)
        .then((value) => {
              if (this.mounted)
                {
                  setState(() {
                    sessionNumHelper = value.docs.length.toString();
                  }),
                }
            });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        //TODO: Implement sign out button (that clears session manager objects)
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
                  child: SessionManager.loggedInTutor.profileImag == ""
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
                                    SessionManager.loggedInTutor.profileImag),
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
                              },
                              child: Align(
                                child: Icon(Icons.edit),
                                alignment: Alignment.bottomRight,
                              )),
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
                    ProfileInfoWidget("Sessions",
                        sessionNumHelper == "" ? "load" : sessionNumHelper),
                    SizedBox(
                      width: 5,
                    ),
                    ProfileInfoWidget(
                        "Rating",
                        finishedLoadingTutorRate == true
                            ? Rate.getAverageRate(tutorRates).toString()
                            : "load"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: ProfileInfoWidget("Reviews",
                          reviewHelper == "" ? "load" : reviewHelper),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewReviewsScreen(
                                    tutorRates: tutorRates,
                                  )),
                        );
                      },
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
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  SessionManager.loggedInTutor.aboutMe,
                                  style: TextStyle(
                                      fontSize: 16.5, color: kGreyerish),
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
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              )
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
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            showEditInterests(setParentStateEx());
                          },
                          child: Icon(
                            Icons.edit,
                            size: 20,
                          ),
                        ),
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
                      // TODO: Add ability for tutor to preview his own materials (open file, edit quiz)
                      MaterialStreamTutor(
                        tutorId: SessionManager.loggedInTutor.userId,
                      ),
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
          subjects[j].chosen = true;
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

  void showEditInterests(Function setParentState) {
    String searchBox = '';
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
              height: ScreenSize.height * 0.75,
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
                                    resetInterests();
                                    Navigator.of(context).pop();
                                  }),
                              Text(
                                "Add Experiences",
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                icon: Icon(Icons.check),
                                onPressed: () {
                                  // ADD EXPERIENCE
                                  printNewChosen();
                                  DatabaseAPI.editExperiences()
                                      .then((value) => {
                                            if (value == "done")
                                              {
                                                setParentStateEx(),
                                                Navigator.of(context).pop()
                                              }
                                          });
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
                                    "Subject",
                                    style: GoogleFonts.secularOne(
                                        textStyle: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: [
                                    TextField(
                                      onChanged: (value) {
                                        setModalState(() {
                                          searchBox = value;
                                          getSubjects(searchBox);
                                          // getSelectedSubjects(selectedInterests);
                                        });
                                      },
                                      style: TextStyle(
                                        color: kBlackish,
                                      ),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(0),
                                        filled: true,
                                        hintText: 'Search',
                                        prefixIcon: Icon(Icons.search,
                                            color: kColorScheme[2]),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      height: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          setModalState(() {
                                            print("Entered Set State new");
                                          });
                                        },
                                        child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: getSubjects(searchBox)),
                                      ),
                                    ),
                                  ],
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

  List<Widget> getSubjects(String searchBox) {
    List<Widget> searchResults = [];
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].searchKeyword(searchBox)) {
        searchResults.add(
          InterestWidget(subjects[i], setParentStateInt),
        );
        searchResults.add(SizedBox(
          width: 15,
        ));
      }
    }

    return searchResults;
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
                                  //
                                  decoration: InputDecoration(
                                    hintText: !(SessionManager.loggedInTutor
                                                .aboutMe.isNotEmpty ||
                                            SessionManager
                                                    .loggedInTutor.aboutMe ==
                                                '')
                                        ? 'Describe yourself briefly...'
                                        : SessionManager.loggedInTutor.aboutMe,
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

  void printNewChosen() {
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].chosen) print(subjects[i].title);
    }
  }

  void resetInterests() {
    for (int i = 0; i < subjects.length; i++) {
      subjects[i].chosen = false;
    }

    for (int i = 0; i < SessionManager.loggedInTutor.experiences.length; i++) {
      for (int j = 0; j < subjects.length; j++) {
        if (SessionManager.loggedInTutor.experiences[i] == subjects[j].id) {
          subjects[j].chosen = true;
        }
      }
    }
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
