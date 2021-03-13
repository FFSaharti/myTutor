import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bd_progress_bar/bdprogreebar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/screens/student_screens/homepage_screen_student.dart';
import 'package:mytutor/screens/welcome_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/regEx.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:page_transition/page_transition.dart';

import 'tutor_screens/tutor_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  static bool passwordVisible = true;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';
  bool loading = false;

  void beginLoading() {
    setState(() {
      loading = true;
    });
  }

  void stopLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height,
      decoration: BoxDecoration(
        gradient: kBackgroundGradient,
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: buildAppBar(context, Colors.white, "", false, () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    duration: Duration(milliseconds: 500),
                    child: WelcomeScreen()));
          }),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'images/myTutorLogoWhite.png',
                      width: double.infinity,
                      height: ScreenSize.height * 0.2,
                    ),
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fade(
                      from: Duration(milliseconds: 300),
                      to: Duration(milliseconds: 700),
                    ),
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.sen(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.07,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromRight(
                      from: Duration(milliseconds: 200),
                      to: Duration(milliseconds: 500),
                    ),
                    child: TextFieldWidget(
                      hintText: 'Email',
                      isPassword: false,
                      obscureText: false,
                      prefixIconData: Icons.mail_outline,
                      colorScheme: kColorScheme[4],
                      suffixIconData:
                          Validator.isValidEmail(email) ? Icons.check : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                        Validator.isValidEmail(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromRight(
                      from: Duration(milliseconds: 200),
                      to: Duration(milliseconds: 500),
                    ),
                    child: TextFieldWidget(
                      hintText: 'Password',
                      obscureText: LoginScreen.passwordVisible,
                      prefixIconData: Icons.lock,
                      suffixIconData: LoginScreen.passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      colorScheme: kColorScheme[4],
                      isPassword: true,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          resetPasswordBottomSheet();
                        },
                        child: Text(
                          'Forgot your password?',
                          style: GoogleFonts.sen(
                              color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.05,
                  ),
                  CircularButton(
                      width: ScreenSize.width * 0.9,
                      buttonColor: Colors.white,
                      textColor: kColorScheme[2],
                      isGradient: false,
                      colors: [
                        kColorScheme[1],
                        kColorScheme[2],
                        kColorScheme[3],
                        kColorScheme[4]
                      ],
                      buttonText: 'Sign In',
                      hasBorder: true,
                      borderColor: kColorScheme[3],
                      onPressed: () {
                        beginLoading();
                        DatabaseAPI.userLogin(email, password).then((value) => {
                              if (value == "Student Login")
                                {
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    Fluttertoast.showToast(
                                        msg: 'Signed in as ' +
                                            SessionManager
                                                .loggedInStudent.name);
                                    Navigator.pushNamed(
                                        context, HomepageScreenStudent.id);
                                  })
                                }
                              else if (value == "Tutor Login")
                                {
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    Fluttertoast.showToast(
                                        msg: 'Signed in as ' +
                                            SessionManager.loggedInTutor.name);
                                    Navigator.pushNamed(
                                        context, HomepageScreenTutor.id);
                                  })
                                }
                              else
                                {
                                  // USER NOT FOUND
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    stopLoading();
                                    Fluttertoast.showToast(
                                        msg: 'Invalid Email/Password');
                                  })
                                }
                            });
                      }),
                  SizedBox(
                    height: ScreenSize.height * 0.05,
                  ),
                  loading
                      ? Loader4(
                          dotOneColor: Colors.white,
                          dotTwoColor: Colors.white,
                          dotThreeColor: Colors.white,
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  resetPasswordBottomSheet() {
    TextEditingController EmailController = TextEditingController();

    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: ScreenSize.height * 0.30,
              child: Column(
                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.030,
                  ),
                  Text(
                    "Provide us with your E-mail",
                    style: GoogleFonts.sen(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0180,
                  ),
                  TextField(
                    controller: EmailController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      hintText: 'Type Your E-mail here....',
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.020,
                  ),
                  CircularButton(
                    width: ScreenSize.width * 0.5,
                    buttonColor: kColorScheme[2],
                    textColor: Colors.white,
                    isGradient: true,
                    colors: [
                      kColorScheme[1],
                      kColorScheme[2],
                      kColorScheme[3],
                      kColorScheme[4]
                    ],
                    buttonText: 'Proceed',
                    hasBorder: true,
                    borderColor: kColorScheme[3],
                    onPressed: () async {
                      if (EmailController.text.isNotEmpty) {
                        String errorCode = await DatabaseAPI.resetUserPassword(
                            EmailController.text);
                        if (errorCode == "success") {
                        } else if (errorCode == "invalid-email") {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.SCALE,
                            dialogType: DialogType.ERROR,
                            body: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Invalid E-Mail',
                                  style: kTitleStyle.copyWith(
                                      color: kBlackish,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            btnOkOnPress: () {},
                          ).show();
                        } else if (errorCode == "user-not-found") {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.SCALE,
                            dialogType: DialogType.ERROR,
                            body: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'User not found!',
                                  style: kTitleStyle.copyWith(
                                      color: kBlackish,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            btnOkOnPress: () {
                              // Navigator.pop(context);
                            },
                          ).show();
                        }
                      } else {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.SCALE,
                          dialogType: DialogType.ERROR,
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Please Provide an E-mail',
                                style: kTitleStyle.copyWith(
                                    color: kBlackish,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          btnOkOnPress: () {
                            // Navigator.pop(context);
                          },
                        ).show();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  bool obscureText;
  final Function onChanged;
  final Color colorScheme;
  bool isPassword;

  TextFieldWidget(
      {this.hintText,
      this.obscureText,
      this.onChanged,
      this.prefixIconData,
      this.suffixIconData,
      this.colorScheme,
      this.isPassword});

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      style: TextStyle(color: kColorScheme[4], fontSize: 18),
      decoration: InputDecoration(
        labelText: widget.hintText,
        prefixIcon: Icon(
          widget.prefixIconData,
          size: 18,
          color: widget.colorScheme,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: widget.colorScheme)),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide(color: widget.colorScheme),
        ),
        suffix: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 11),
            child: Icon(
              (!widget.isPassword)
                  ? widget.suffixIconData
                  : !LoginScreen.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
              size: 21,
              color: widget.colorScheme,
            ),
          ),
          onTap: () {
            setState(() {
              LoginScreen.passwordVisible = !LoginScreen.passwordVisible;
              widget.obscureText = !widget.obscureText;
            });
          },
        ),
        labelStyle: TextStyle(color: widget.colorScheme, fontSize: 20),
      ),
    );
  }
}
