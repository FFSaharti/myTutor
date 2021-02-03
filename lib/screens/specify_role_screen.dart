import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/interests_screen.dart';
import 'package:mytutor/utilities/constants.dart';

class SpecifyRoleScreen extends StatefulWidget {
  static String id = 'specify_role_screen';
  static bool passwordVisible = true;

  @override
  _SpecifyRoleScreenState createState() => _SpecifyRoleScreenState();
}

class _SpecifyRoleScreenState extends State<SpecifyRoleScreen> {
  double width;
  String email = '';
  String name = '';
  String tutorRolePath = 'images/Roles/Tutor.png';
  String studentRolePath = 'images/Roles/Student.png';

  Widget tutorWidget = Container(
    key: Key('Tutor'),
    child: Image.asset(
      'images/Roles/Tutor.png',
      width: 250,
    ),
  );

  Widget studentWidget = Container(
    key: Key('Student'),
    child: Image.asset(
      'images/Roles/Student.png',
      width: 250,
    ),
  );

  Widget selectedWidget = Container(
    key: Key('Tutor'),
    child: Image.asset(
      'images/Roles/Tutor.png',
      width: 250,
    ),
  );

  String selectedPath = 'images/Roles/Tutor.png';

  void changeRole() {
    if (selectedPath == tutorRolePath) {
      selectedPath = studentRolePath;
      selectedWidget = studentWidget;
      print("student");
    } else {
      selectedPath = tutorRolePath;
      selectedWidget = tutorWidget;
      print("tutor");
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Text(
              'Specify Role',
              style: GoogleFonts.secularOne(
                  textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: kBlackish)),
            ),
            SizedBox(
              height: 25,
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              // child: Image.asset(
              //   selectedPath,
              //   width: 250,
              // ),
              child: selectedWidget,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(child: child, scale: animation);
              },
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 38,
                onSelectedItemChanged: (selectedIndex) {
                  setState(() {
                    if (selectedIndex == 0) {
                      selectedWidget = tutorWidget;
                    } else {
                      selectedWidget = studentWidget;
                    }
                  });
                },
                children: [
                  Text(
                    'Tutor',
                    style: GoogleFonts.secularOne(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: kBlackish)),
                  ),
                  Text(
                    'Student',
                    style: GoogleFonts.secularOne(
                        textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.normal,
                            color: kBlackish)),
                  ),
                ],
              ),
            ),
            EZButton(
                width: width,
                buttonColor: kColorScheme[1],
                textColor: Colors.white,
                isGradient: true,
                colors: [
                  kColorScheme[1],
                  kColorScheme[2],
                  kColorScheme[3],
                  kColorScheme[4],
                ],
                buttonText: "Sign Up",
                hasBorder: false,
                borderColor: null,
                onPressed: () {
                  if (selectedWidget == studentWidget) {
                    // Navigator.pushNamed(context, SpecifyRoleScreen.id);
                  } else {
                    // Chosen Tutor
                    Navigator.pushNamed(context, InterestsScreen.id);
                  }
                }),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
