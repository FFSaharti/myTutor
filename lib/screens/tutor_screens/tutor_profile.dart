import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/profile_info_widget.dart';
import 'package:mytutor/components/view_rate_bottom_sheet_widget.dart';
import 'package:mytutor/screens/view_reviews_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

import 'interests_screen.dart';

class TutorProfile extends StatefulWidget {
  @override
  _TutorProfileState createState() => _TutorProfileState();
}

class _TutorProfileState extends State<TutorProfile> {
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
              else
                {
                  // no data mean no review  or rate yet.
                  setState(() {
                    reviewHelper = "0";
                    sessionNumHelper = "0";
                    finishedLoadingTutorRate = true;
                  }),
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
    //VillainController.playAllVillains(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context, Theme.of(context).accentColor, "Profile", true),
        body: SafeArea(
          child: Center(
            child: Container(
              width: ScreenSize.width * 0.91,
              height: ScreenSize.height * 0.9,
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
                        child: SessionManager.loggedInTutor.profileImag == ""
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
                                                    SessionManager.loggedInTutor
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
                                          .loggedInTutor.profileImag),
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
                                                          .loggedInTutor
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
                        DatabaseAPI.tempTutor.name,
                        style:
                            GoogleFonts.sen(color: Theme.of(context).buttonColor, fontSize: 30),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: ScreenSize.width * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: kColorScheme[3],
                        ),
                        child: Text("Tutor",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sen(
                                color: Colors.white, fontSize: 21)),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProfileInfoWidget("Sessions",
                            sessionNumHelper == "" ? "load" : sessionNumHelper),
                        SizedBox(
                          width: ScreenSize.width * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            ViewRateBottomSheet.show(tutorRates, context);
                          },
                          child: ProfileInfoWidget(
                              "Rating",
                              finishedLoadingTutorRate == true
                                  ? tutorRates.length == 0
                                      ? "0"
                                      : Rate.getAverageRate(tutorRates)
                                          .toString()
                                  : "load"),
                        ),
                        SizedBox(
                          width: ScreenSize.width * 0.02,
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
                                  color: Theme.of(context).buttonColor),
                            ),
                            Spacer(),
                            (SessionManager.loggedInTutor.aboutMe == '')
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
                        !(SessionManager.loggedInTutor.aboutMe == '')
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      SessionManager.loggedInTutor.aboutMe,
                                      style: TextStyle(
                                          fontSize: 16.5,
                                          color:
                                          Theme.of(context).buttonColor),
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
                                            color: Theme.of(context).buttonColor,
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
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: 18,
                            ),
                            SizedBox(
                              width: ScreenSize.width * 0.02,
                            ),
                            Text(
                              "Experiences",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).buttonColor),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                showEditInterests(setParentStateEx());
                              },
                              child: Icon(
                                Icons.edit,
                                size: 20,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.01,
                        ),
                        Container(
                          height: ScreenSize.height * 0.07,
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
                                width: ScreenSize.width * 0.02,
                              ),
                              Text(
                                "Materials",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context).buttonColor),
                              )
                            ],
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.01,
                          ),
                          MaterialStreamTutor(
                            tutorId: SessionManager.loggedInTutor.userId,
                            isSameUser: true,
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
      ),
    );
  }

  List<Widget> getExperiences() {
    List<Widget> widgets = [];
    List<Subject> experiences = [];
print("----");

    for (int i = 0; i < SessionManager.loggedInTutor.experiences.length; i++) {
      for (int j = 0; j < subjects.length; j++) {

        if (SessionManager.loggedInTutor.experiences[i] == subjects[j].id) {
          print(subjects[j].title);
          subjects[j].chosen = true;
          experiences.add(subjects[j]);
        }
      }
    }

    int from = 50;
    int to = 500;

    for (int i = 0; i < experiences.length; i++) {
      widgets.add(
        Villain(
          villainAnimation: VillainAnimation.fromRight(
            from: Duration(milliseconds: from),
            to: Duration(milliseconds: to),
          ),
          child: SubjectWidget(experiences[i]),
        ),
      );
      widgets.add(SizedBox(width: 9));

      from += 100;
      to += 100;
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
                //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                height: ScreenSize.height * 0.70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
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
                              style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
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
                                          color: Theme.of(context).buttonColor)),
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
                                    style: TextStyle(color: Theme.of(context).accentColor),
                                    textAlignVertical:
                                        TextAlignVertical.center,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(0),
                                      filled: true,
                                      hintText: 'Search',
                                      hintStyle:
                                      TextStyle(color: Theme.of(context).accentColor),
                                      prefixIcon: Icon(Icons.search,
                                         color: Theme.of(context).accentColor),
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

        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
                //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                height: ScreenSize.height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
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
                              style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
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
                                                Fluttertoast.showToast(msg: "About me has been changed successful")
                                              },
                                    Fluttertoast.showToast(msg: "Something went wrong. Please try again later..")
                                          });
                                  print("POP...");
                                } else {
                                  Fluttertoast.showToast(msg: "Please fill up About me field");
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height*0.015,
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
                                          color: Theme.of(context).buttonColor)),
                                ),
                              ),
                              TextField(
                                style: TextStyle(color: Theme.of(context).buttonColor),
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
        color: Theme.of(context).cardColor,
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
