import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/student.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/profile_info_widget.dart';
import 'package:mytutor/components/view_rate_bottom_sheet_widget.dart';
import 'package:mytutor/screens/student_screens/view_tutor_profile_screen.dart';
import 'package:mytutor/screens/tutor_screens/tutor_profile.dart';
import 'package:mytutor/screens/view_reviews_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

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
              user = Student(value.data()["name"], "email", "pass", "aboutMe",
                  value.id, [], value.data()["profileImg"]),
              setState(() {
                loading = !loading;
              }),
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          height: ScreenSize.height * 0.9,
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
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
                    "Tutor ",
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileInfoWidget("Sessions",
                          sessionNumHelper == "" ? "load" : sessionNumHelper),
                      SizedBox(
                        width: 5,
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
                  !(widget.tutor.aboutMe == '')
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                widget.tutor.aboutMe,
                                style: TextStyle(
                                    fontSize: 16.5, color: kGreyerish),
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
                                height: ScreenSize.height *0.020,
                              ),
                              Center(
                                child: Text(
                                  "the tutor does not have a \"About me\" :( ",
                                  style: TextStyle(
                                      fontSize: 16.5, color: kGreyerish),
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
                    ],

                  ),
                  widget.tutor.experiences.isEmpty == true ? Container(
                    height: ScreenSize.height * 0.090,
                    child: Column(
                      children: [
                        SizedBox(
                          height: ScreenSize.height *0.020,
                        ),
                        Center(
                          child: Text(
                            "the tutor does not have any experience yet ",
                            style: TextStyle(
                                fontSize: 16.5, color: kGreyerish),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ): Container(
                    height: ScreenSize.height * 0.07,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: getExperiences(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
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


class ViewProfileStudent extends StatelessWidget {
  final Student student;

  const ViewProfileStudent({this.student});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ScreenSize.width * 0.91,
        height: ScreenSize.height * 0.9,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: student.profileImag == ""
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
                            image: NetworkImage(student.profileImag),
                            fit: BoxFit.fill),
                      ),
                    ),
            ),
            Center(
              child: Text(
                student.name,
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
                  "Student ",
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
                !(student.aboutMe == '')
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              student.aboutMe,
                              style:
                                  TextStyle(fontSize: 16.5, color: kGreyerish),
                            ),
                          ),
                          Spacer(),
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
                                "the Student does not have a \"About me\" :( ",
                                style: TextStyle(
                                    fontSize: 16.5, color: kGreyerish),
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
            Divider(
              color: kGreyish,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
