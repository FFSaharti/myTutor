import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/screens/student_screens/request_tutor_screen.dart';
import 'package:mytutor/screens/student_screens/view_materials_screen.dart';
import 'package:mytutor/utilities/screen_size.dart';

import 'ask_screen_student.dart';

class StudentSection extends StatefulWidget {
  double height;
  double width;

  @override
  _StudentSectionState createState() => _StudentSectionState();
}

class _StudentSectionState extends State<StudentSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.07,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fade(
                      from: Duration(milliseconds: 0),
                      to: Duration(milliseconds: 500),
                    ),
                    child: Text(
                      "Select an option",
                      style: GoogleFonts.sen(
                          fontSize: 25,
                          color:
                              Theme.of(context).buttonColor.withOpacity(0.6)),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.06,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromBottom(
                      from: Duration(milliseconds: 0),
                      to: Duration(milliseconds: 600),
                    ),
                    child: Container(
                      child: StudentSectionWidget(
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
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromBottom(
                      from: Duration(milliseconds: 300),
                      to: Duration(milliseconds: 700),
                    ),
                    child: Container(
                      key: const ValueKey("request_button"),
                      child: StudentSectionWidget(
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
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromBottom(
                      from: Duration(milliseconds: 300),
                      to: Duration(milliseconds: 700),
                    ),
                    child: Container(
                      child: StudentSectionWidget(
                        widget: widget,
                        onClick: () {
                          print("clicked MATERIALS");
                          Navigator.pushNamed(context, ViewMaterialsScreen.id);
                        },
                        imgPath: "images/Student_Section/Materials_Logo.png",
                        title: "Materials",
                        description:
                            "Search for Materials posted by \nother Tutors and bookmark them",
                      ),
                    ),
                  )
                ],
              ),
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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imgPath,
                    width: 50,
                  ),
                ],
              ),
              title: Text(
                title,
                style: GoogleFonts.sen(
                    fontSize: 25, color: Theme.of(context).buttonColor),
              ),
              subtitle: Text(
                description,
                style: GoogleFonts.sen(
                    fontSize: 14, color: Theme.of(context).buttonColor),
              ),
              trailing: Container(
                height: double.infinity,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
