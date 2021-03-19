import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/material.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/profile_info_widget.dart';
import 'package:mytutor/components/view_rate_bottom_sheet_widget.dart';
import 'package:mytutor/screens/take_quiz_screen.dart';
import 'package:mytutor/screens/tutor_screens/tutor_profile.dart';
import 'package:mytutor/screens/view_reviews_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewReceiverProfile extends StatefulWidget {
  final String userId;
  final String role;

  const ViewReceiverProfile({this.role, this.userId});

  @override
  _ViewReceiverProfileState createState() => _ViewReceiverProfileState();
}

class _ViewReceiverProfileState extends State<ViewReceiverProfile> {
  MyUser user;
  bool loading = false;
  List<MyMaterial> favDocs = [];

  @override
  void initState() {
    // inislize user object.
    print(widget.userId);
    widget.role == "tutor"
        ? DatabaseAPI.getUserbyid(widget.userId, 0).then((value) => {
              user = Tutor(
                  value.data()["name"],
                  "email",
                  "pass",
                  value.data()["aboutMe"],
                  value.id,
                  [],
                  value.data()["profileImg"]),
              List.from(value.data()['experiences']).forEach((element) {
                (user as Tutor).addExperience(element);
              }),
              setState(() {
                loading = !loading;
              }),
            })
        : DatabaseAPI.getUserbyid(widget.userId, 1).then((value) => {
              user = Student(
                  value.data()["name"],
                  "email",
                  "pass",
                  value.data()["aboutMe"],
                  value.id,
                  [],
                  value.data()["profileImg"]),
              (user as Student).favMats = value.data()["listOfFavMats"],
              setState(() {
                loading = !loading;
              }),
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
        },
        child: Scaffold(
          appBar:
              buildAppBar(context, Theme.of(context).accentColor, "Profile"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loading == false
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : widget.role == "tutor"
                      ? ViewProfileTutor(
                          tutor: user,
                        )
                      : ViewProfileStudent(
                          student: user,
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

class ViewProfileTutor extends StatefulWidget {
  final Tutor tutor;

  const ViewProfileTutor({this.tutor});

  @override
  _ViewProfileTutorState createState() => _ViewProfileTutorState();
}

class _ViewProfileTutorState extends State<ViewProfileTutor> {
  List<Rate> tutorRates = [];
  String sessionNumHelper = "";
  String reviewHelper = "";
  bool finishedLoadingTutorRate = false;

  void initState() {
    Timestamp stamptemp;
    int reviewSum = 0;
    //load more information about the tutors, since rate/review need one more query to do we will do it here.
    DatabaseAPI.getTutorRates(widget.tutor.userId).then((value) => {
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
              setState(() {
                reviewHelper = "0";
                sessionNumHelper = "0";
                finishedLoadingTutorRate = true;
              }),
            }
        });

    // get the session num
    DatabaseAPI.getSessionNumber(widget.tutor.userId).then((value) => {
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
    return SafeArea(
      child: Center(
        child: Container(
          width: ScreenSize.width * 0.91,
          height: ScreenSize.height * 0.89,
          child: ListView(
            children: [
              Center(
                child: widget.tutor.profileImag == ""
                    ? Container(
                        width: ScreenSize.width * 0.30,
                        height: ScreenSize.height * 0.21,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_circle_sharp,
                          size: 120,
                        ),
                      )
                    : Container(
                        width: ScreenSize.width * 0.30,
                        height: ScreenSize.height * 0.21,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(widget.tutor.profileImag),
                              fit: BoxFit.fill),
                        ),
                      ),
              ),
              Center(
                child: Text(
                  widget.tutor.name,
                  style: kTitleStyle.copyWith(
                      color: Theme.of(context).buttonColor, fontSize: 30),
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
                    "Tutor ",
                    textAlign: TextAlign.center,
                    style: kTitleStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileInfoWidget("Sessions",
                          sessionNumHelper == "" ? "load" : sessionNumHelper),
                      SizedBox(
                        width: ScreenSize.width * 0.05,
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
                                    : Rate.getAverageRate(tutorRates).toString()
                                : "load"),
                      ),
                      SizedBox(
                        width: ScreenSize.width * 0.05,
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
                        width: ScreenSize.width * 0.05,
                      ),
                      Text(
                        "About Me",
                        style: TextStyle(
                            fontSize: 18, color: Theme.of(context).buttonColor),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  !(widget.tutor.aboutMe == '')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: SizedBox(
                                width: ScreenSize.width*0.80,
                                child: Text(
                                  widget.tutor.aboutMe,
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      color: Theme.of(context).buttonColor),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        )
                      : Container(
                          height: ScreenSize.height * 0.090,
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenSize.height * 0.020,
                              ),
                              Center(
                                child: Text(
                                  "the tutor does not have a \"About me\" :( ",
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      color: Theme.of(context).buttonColor),
                                ),
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.015,
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
                        width: ScreenSize.width * 0.05,
                      ),
                      Text(
                        "Experiences",
                        style: TextStyle(
                            fontSize: 18, color: Theme.of(context).buttonColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  widget.tutor.experiences.isEmpty == true
                      ? Container(
                          height: ScreenSize.height * 0.090,
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenSize.height * 0.020,
                              ),
                              Center(
                                child: Text(
                                  "the tutor does not have any experience yet ",
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      color: Theme.of(context).buttonColor),
                                ),
                              ),
                              SizedBox(
                                height: ScreenSize.height * 0.020,
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: ScreenSize.height * 0.07,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: getExperiences(),
                          ),
                        ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
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
                          width: ScreenSize.width * 0.05,
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
                      tutorId: widget.tutor.userId,
                      isSameUser: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getExperiences() {
    List<Widget> widgets = [];
    List<Subject> experiences = [];

    for (int i = 0; i < widget.tutor.experiences.length; i++) {
      for (int j = 0; j < subjects.length; j++) {
        if (widget.tutor.experiences[i] == subjects[j].id) {
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
}

class ViewProfileStudent extends StatefulWidget {
  final Student student;

  const ViewProfileStudent({this.student});

  @override
  _ViewProfileStudentState createState() => _ViewProfileStudentState();
}

class _ViewProfileStudentState extends State<ViewProfileStudent> {
  PDFDocument doc;
  int counter = 0;
  List<MyMaterial> favDocs = [];

  @override
  void initState() {
    DatabaseAPI.fetchDocument().then((data) {
      if (data.docs.isNotEmpty) {
        for (var material in data.docs) {
          if (widget.student.favMats.contains(material.id)) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    child: widget.student.profileImag == ""
                        ? Container(
                            width: ScreenSize.width * 0.30,
                            height: ScreenSize.height * 0.21,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onTap: () async {},
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
                                  image:
                                      NetworkImage(widget.student.profileImag),
                                  fit: BoxFit.fill),
                            ),
                          ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.student.name,
                    style: GoogleFonts.sen(
                        color: Theme.of(context).buttonColor, fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.01,
                ),
                Center(
                  child: Container(
                    width: ScreenSize.width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: kColorScheme[3],
                    ),
                    child: Text("Student",
                        textAlign: TextAlign.center,
                        style:
                            GoogleFonts.sen(color: Colors.white, fontSize: 21)),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.01,
                ),
                Divider(
                  color: Theme.of(context).dividerColor,
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
                      ],
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.01,
                    ),
                    !(widget.student.aboutMe == '')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  widget.student.aboutMe,
                                  style: TextStyle(
                                      fontSize: 16.5,
                                      color: Theme.of(context).buttonColor),
                                ),
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
                  color: Theme.of(context).dividerColor,
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
                                color: Theme.of(context).buttonColor),
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
    );
  }

  List<Widget> getFavDocs() {
    List<Widget> widgets = [];

    for (int i = 0; i < favDocs.length; i++) {
      widgets.add(
        Container(
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 15, 5, 15),
              child: ListTile(
                leading: Image.asset(subjects[favDocs[i].subjectID].path),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favDocs[i].title,
                      style: TextStyle(color: Theme.of(context).buttonColor),
                    ),
                    favDocs[i].type == 1
                        ? Text(
                            (favDocs[i] as Document).fileType.toUpperCase(),
                            style: GoogleFonts.sen(
                                color: Theme.of(context).buttonColor),
                          )
                        : Text(
                            "QUIZ",
                            style: GoogleFonts.sen(
                                color: Theme.of(context).buttonColor),
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
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).buttonColor,
                  ),
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
      if (await canLaunch(
          (widget.student.favMats.elementAt(index) as Document).url)) {
        await launch((widget.student.favMats.elementAt(index) as Document).url);
      } else {
        throw 'Could not launch' +
            widget.student.favMats.elementAt(index).toString();
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

  List<Widget> getFavMats(List<dynamic> favMats) {
    List<Widget> widgets = [];

    for (int i = 0; i < favMats.length; i++) {
      widgets.add(
        Text(favMats[i].toString()),
      );
    }

    return widgets;
  }
}
