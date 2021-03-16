import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/tutor_section_widget.dart';
import 'package:mytutor/screens/tutor_screens/respond_screen_tutor.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

import 'answer_screen_tutor.dart';
import 'create_materials_screen.dart';

class TutorOptions extends StatefulWidget {
  double height;
  double width;

  @override
  _TutorOptionsState createState() => _TutorOptionsState();
}

class _TutorOptionsState extends State<TutorOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    style: GoogleFonts.sarala(fontSize: 25, color: Theme.of(context).buttonColor.withOpacity(0.6)),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.05,
                ),
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    from: Duration(milliseconds: 0),
                    to: Duration(milliseconds: 400),
                  ),
                  child: TutorSectionWidget(
                    widget: widget,
                    onClick: () {
                      print("clicked answer");
                      Navigator.pushNamed(context, AnswerScreenTutor.id);
                    },
                    imgPath: "images/Tutor_Section/Answer_Logo.png",
                    title: "Answer",
                    description:
                        "Answer questions that are posted by Students.",
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.01,
                ),
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    from: Duration(milliseconds: 100),
                    to: Duration(milliseconds: 500),
                  ),
                  child: TutorSectionWidget(
                    widget: widget,
                    onClick: () {
                      print("clicked Respond");
                      Navigator.pushNamed(context, RespondScreenTutor.id);
                    },
                    imgPath: "images/Tutor_Section/Respond_Logo.png",
                    title: "Respond",
                    description:
                        "Respond to request send by Students for creating a session with you!!",
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.01,
                ),
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    from: Duration(milliseconds: 200),
                    to: Duration(milliseconds: 600),
                  ),
                  child: TutorSectionWidget(
                    widget: widget,
                    onClick: () {
                      Navigator.pushNamed(context, CreateMaterialsScreen.id);
                    },
                    imgPath: "images/Tutor_Section/Subject_Logo.png",
                    title: "Create Materials",
                    description:
                        "Share Materials & Create Quizzes with Students that can be bookmarked & taken.",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
