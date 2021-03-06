import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/session_stream_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class HomePageTutor extends StatefulWidget {
  @override
  _HomePageTutorState createState() => _HomePageTutorState();
}

class _HomePageTutorState extends State<HomePageTutor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.height * 0.09,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Villain(
                villainAnimation: VillainAnimation.fromLeft(
                  from: Duration(milliseconds: 30),
                  to: Duration(milliseconds: 300),
                ),
                animateEntrance: true,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Welcome,\nTutor ",
                          style: GoogleFonts.sen(
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).buttonColor)),
                        ),
                        TextSpan(
                          text: SessionManager.loggedInTutor.name,
                          style: GoogleFonts.sen(
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).buttonColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.03,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Text(
                    "    Active/Upcoming Sessions",
                    style: GoogleFonts.sen(
                        textStyle: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).buttonColor)),
                  ),
                  //
                ],
              ),
            ),
            disableBlueOverflow(
              context,
              SessionStream(
                status: "active",
                isStudent: false,
                type: 1,
                checkexpire: false,
                expiredSessionView: false,
              ),
            ),
            SizedBox(
              height: ScreenSize.height * 0.02,
            ),
            //SessionWidget(height: height),
          ],
        ),
      ),
    );
  }
}
