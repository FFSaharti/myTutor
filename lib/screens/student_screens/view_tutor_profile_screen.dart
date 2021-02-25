import 'package:flutter/material.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';


class ViewTutorProfileScreen extends StatefulWidget {
  final Tutor tutor;

  const ViewTutorProfileScreen({Key key, this.tutor}) : super(key: key);

  @override
  _ViewTutorProfileScreenState createState() => _ViewTutorProfileScreenState();
}

class _ViewTutorProfileScreenState extends State<ViewTutorProfileScreen> {
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
                          image: NetworkImage(
                              widget.tutor.profileImag),
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
                    //TODO: Fetch information about tutor and view it

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
                      // TODO: Add ability for tutor to preview his own materials (open file, edit quiz)
                      //MaterialStreamTutor(),
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
