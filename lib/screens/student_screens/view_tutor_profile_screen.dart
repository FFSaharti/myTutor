import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/material_stream_widget.dart';
import 'package:mytutor/components/profile_info_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

import '../view_reviews_screen.dart';

class ViewTutorProfileScreen extends StatefulWidget {
  final Tutor tutor;

  const ViewTutorProfileScreen({Key key, this.tutor}) : super(key: key);

  @override
  _ViewTutorProfileScreenState createState() => _ViewTutorProfileScreenState();
}

class _ViewTutorProfileScreenState extends State<ViewTutorProfileScreen> {
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
                                        tutorRates: tutorRates,)),
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
                            height: ScreenSize.height * 0.17,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
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
                      // child: ListView(
                      //   scrollDirection: Axis.horizontal,
                      //   children: getExperiences(),
                      // ),
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
}
