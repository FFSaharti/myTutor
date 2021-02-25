import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/animated_login_widget.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/student_screens/homepage_screen_student.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/regEx.dart';
import 'package:mytutor/utilities/screen_size.dart';

import 'tutor_screens/homepage_screen_tutor.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  static bool passwordVisible = true;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/myTutorLogoColored.png',
                  width: double.infinity,
                  height: 50,
                ),
              ),
              AnimatedLoginWidget(),
              SizedBox(
                height: 60,
              ),
              Text(
                'Login to your account',
                style: GoogleFonts.secularOne(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(
                height: 50,
              ),
              TextFieldWidget(
                hintText: 'Email',
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
              SizedBox(
                height: 10,
              ),
              TextFieldWidget(
                hintText: 'Password',
                obscureText: LoginScreen.passwordVisible,
                prefixIconData: Icons.lock,
                suffixIconData: LoginScreen.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                colorScheme: kColorScheme[4],
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      //TODO : Implement forgetting password action
                      resetPasswordBottomSheet();
                      //DatabaseAPI.resetUserPassword("11111@");
                    },
                    child: Text(
                      'Forgot your password?',
                      style: kTitleStyle.copyWith(
                          fontSize: 13,
                          color: Colors.lightBlue,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Builder(builder: (context) {
                return EZButton(
                    width: ScreenSize.width,
                    buttonColor: kColorScheme[1],
                    textColor: Colors.white,
                    isGradient: true,
                    colors: [
                      kColorScheme[1],
                      kColorScheme[2],
                      kColorScheme[3],
                      kColorScheme[4],
                    ],
                    buttonText: "Login",
                    hasBorder: false,
                    borderColor: null,
                    onPressed: () {
                      // TODO: Implement progress bar...
                      DatabaseAPI.userLogin(email, password).then((value) => {
                            if (value == "Student Login")
                              {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: new Text("Welcome"),
                                    backgroundColor: kColorScheme[2],
                                    duration:
                                        const Duration(milliseconds: 500))),
                                Navigator.pushNamed(
                                    context, HomepageScreenStudent.id)
                              }
                            else if (value == "Tutor Login")
                              {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: new Text("Welcome"),
                                    backgroundColor: kColorScheme[2],
                                    duration:
                                        const Duration(milliseconds: 500))),
                                Navigator.pushNamed(
                                    context, HomepageScreenTutor.id)
                              }
                            else
                              {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: new Text("Invalid Information"),
                                    backgroundColor: Colors.red,
                                    duration:
                                        const Duration(milliseconds: 500))),
                                // Navigator.pushNamed(
                                //     context, HomepageScreenTutor.id)
                              }
                          });
                    });
              }),
            ],
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
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: ScreenSize.height *0.30,
              child: Column(

                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.030,
                  ),
                  Text(
                    "enter your email",
                    style: kTitleStyle.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0090,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.0090,
                  ),
                  TextField(
                    controller: EmailController,
                    onChanged: (value) {

                    },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        onPressed: () async{
                          if (EmailController.text.isNotEmpty){
                            String errorCode = await DatabaseAPI.resetUserPassword(EmailController.text);
                            if (errorCode == "success"){
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.SUCCES,
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'check your email for reset link..',
                                      style: kTitleStyle.copyWith(
                                          color: kBlackish,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {
                                   Navigator.pop(context);
                                },
                              ).show();
                            } else if(errorCode == "invalid-email"){
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.ERROR,
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'Invalid email',
                                      style: kTitleStyle.copyWith(
                                          color: kBlackish,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {

                                },
                              ).show();
                            } else if(errorCode == "user-not-found"){
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.SCALE,
                                dialogType: DialogType.ERROR,
                                body: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'we dont have a user with that email.',
                                      style: kTitleStyle.copyWith(
                                          color: kBlackish,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                                btnOkOnPress: () {

                                },
                              ).show();
                            }
                          }


                        },
                        child: Text(
                          "Submit",
                          style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white),
                          ),
                        ),
                        color: kColorScheme[2],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ],
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

  TextFieldWidget({
    this.hintText,
    this.obscureText,
    this.onChanged,
    this.prefixIconData,
    this.suffixIconData,
    this.colorScheme,
  });

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      style: TextStyle(color: kColorScheme[4], fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.hintText,
        prefixIcon: Icon(
          widget.prefixIconData,
          size: 18,
          color: widget.colorScheme,
        ),
        filled: true,
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: widget.colorScheme),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              LoginScreen.passwordVisible = !LoginScreen.passwordVisible;
              widget.obscureText = !widget.obscureText;
            });
          },
          child: Icon(
            widget.suffixIconData,
            size: 18,
            color: widget.colorScheme,
          ),
        ),
        labelStyle: TextStyle(color: widget.colorScheme),
      ),
    );
  }
}
