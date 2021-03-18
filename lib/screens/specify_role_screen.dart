import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/screens/login_screen.dart';
import 'package:mytutor/screens/tutor_screens/interests_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:page_transition/page_transition.dart';

class SpecifyRoleScreen extends StatefulWidget {
  static String id = 'specify_role_screen';

  @override
  _SpecifyRoleScreenState createState() => _SpecifyRoleScreenState();
}

class _SpecifyRoleScreenState extends State<SpecifyRoleScreen> {
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
    } else {
      selectedPath = tutorRolePath;
      selectedWidget = tutorWidget;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DisableDefaultPop(
      child: Scaffold(
        appBar:
            buildAppBar(context, Theme.of(context).accentColor, "Specify Role"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: ScreenSize.height * 0.05,
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 350),
                child: selectedWidget,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(child: child, scale: animation);
                },
              ),
              disableBlueOverflow(
                context,
                Expanded(
                  child: CupertinoPicker(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    itemExtent: 35,
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
                        style: GoogleFonts.sen(
                            color: Theme.of(context).buttonColor,
                            fontSize: 25,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        'Student',
                        style: GoogleFonts.sen(
                            color: Theme.of(context).buttonColor,
                            fontSize: 25,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ),
              Villain(
                villainAnimation: VillainAnimation.fromBottom(
                  from: Duration(milliseconds: 100),
                  to: Duration(milliseconds: 300),
                ),
                child: CircularButton(
                    width: ScreenSize.width * 0.8,
                    buttonColor: Theme.of(context).primaryColorLight,
                    textColor: Colors.white,
                    isGradient: Theme.of(context).primaryColorLight == kWhiteish
                        ? true
                        : false,
                    colors: [
                      kColorScheme[1],
                      kColorScheme[2],
                      kColorScheme[3],
                      kColorScheme[4],
                    ],
                    buttonText: "Sign Up",
                    hasBorder: false,
                    borderColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (selectedWidget == studentWidget) {
                        DatabaseAPI.createStudent().then((value) => {
                              if (value == "Success")
                                {
                                  Fluttertoast.showToast(
                                      msg: "Welcome to MyTutor :)"),
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType
                                              .leftToRightWithFade,
                                          duration: Duration(milliseconds: 500),
                                          child: LoginScreen()))
                                }
                              else
                                {
                                  Fluttertoast.showToast(msg: value),
                                  Navigator.pop(context),
                                }
                            });
                      } else {
                        // Chosen Tutor
                        Navigator.pushNamed(context, InterestsScreen.id);
                      }
                    }),
              ),
              SizedBox(
                height: ScreenSize.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
