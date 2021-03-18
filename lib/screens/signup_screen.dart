import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/screens/specify_role_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/regEx.dart';
import 'package:mytutor/utilities/screen_size.dart';

import 'file:///C:/Users/faisa/Desktop/Developer/AndroidStudioProjects/mytutor/lib/components/disable_default_pop.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'signup_screen';
  static bool passwordVisible = true;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File _file;
  final picker = ImagePicker();
  String email = '';
  String name = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return DisableDefaultPop(
      child: Container(
        decoration: BoxDecoration(
          gradient:
              !(Theme.of(context).scaffoldBackgroundColor == Color(0xff29273d))
                  ? kBackgroundGradient
                  : null,
        ),
        child: Scaffold(
          appBar: buildAppBar(context, Colors.white, ""),
          resizeToAvoidBottomInset: true,
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor == Colors.white
                  ? Colors.transparent
                  : Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'images/myTutorLogoWhite.png',
                      width: double.infinity,
                      height: ScreenSize.height * 0.09,
                    ),
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fade(
                      from: Duration(milliseconds: 300),
                      to: Duration(milliseconds: 700),
                    ),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.sen(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: ScreenSize.height * 0.08,
                        width: ScreenSize.width * 0.15,
                        child: FloatingActionButton(
                          child: Icon(
                            Icons.upload_outlined,
                            color: Theme.of(context).primaryColorDark,
                            size: ScreenSize.height * 0.05,
                          ),
                          backgroundColor: Colors.white,
                          elevation: 2,
                          onPressed: () async {
                            //TODO : implement FileHelper class.....
                            FilePickerResult file = await FilePicker.platform
                                .pickFiles(type: FileType.image);
                            file == null
                                ? null
                                : _file = File(file.files.single.path);
                            DatabaseAPI.tempFile = _file;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width * 0.02,
                      ),
                      Center(
                        child: Text(
                          "Upload Profile Picture",
                          style: GoogleFonts.sen(
                              color: Colors.white,
                              fontSize: 19,
                              letterSpacing: -1),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.015,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor == Colors.transparent
                        ? Colors.white
                        : Theme.of(context).dividerColor,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.015,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromLeft(
                      from: Duration(milliseconds: 50),
                      to: Duration(milliseconds: 300),
                    ),
                    child: TextFieldWidget(
                      hintText: 'Full Name',
                      obscureText: false,
                      prefixIconData: Icons.person,
                      colorScheme: Theme.of(context).primaryColorDark,
                      suffixIcon: Validator.isValidName(name)
                          ? Icon(Icons.check,
                              color: Theme.of(context).primaryColorDark)
                          : Icon(Icons.check, color: Colors.transparent),
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                        DatabaseAPI.tempUser.name = name;
                        Validator.isValidName(value);
                      },
                      isPassword: false,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromRight(
                      from: Duration(milliseconds: 50),
                      to: Duration(milliseconds: 300),
                    ),
                    child: TextFieldWidget(
                      hintText: 'Email',
                      obscureText: false,
                      prefixIconData: Icons.mail_outline,
                      colorScheme: Theme.of(context).primaryColorDark,
                      suffixIcon: Validator.isValidEmail(email)
                          ? Icon(Icons.check,
                              color: Theme.of(context).primaryColorDark)
                          : Icon(Icons.check, color: Colors.transparent),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                          print(email);
                        });
                        DatabaseAPI.tempUser.email = email;
                        Validator.isValidEmail(value);
                      },
                      isPassword: false,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.01,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromLeft(
                      from: Duration(milliseconds: 50),
                      to: Duration(milliseconds: 300),
                    ),
                    child: TextFieldWidget(
                      onChanged: (value) {
                        password = value;
                        DatabaseAPI.tempUser.password = value;
                      },
                      hintText: 'Password',
                      obscureText: SignupScreen.passwordVisible,
                      prefixIconData: Icons.lock,
                      colorScheme: Theme.of(context).primaryColorDark,
                      isPassword: true,
                      // isVisible: passwordVisible,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.06,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromBottom(
                      from: Duration(milliseconds: 200),
                      to: Duration(milliseconds: 400),
                    ),
                    child: CircularButton(
                        width: ScreenSize.width * 0.9,
                        buttonColor: Colors.white,
                        textColor: Theme.of(context).primaryColorDark,
                        isGradient: false,
                        colors: [
                          kColorScheme[1],
                          kColorScheme[2],
                          kColorScheme[3],
                          kColorScheme[4]
                        ],
                        buttonText: 'Next',
                        hasBorder: true,
                        borderColor: Theme.of(context).primaryColorDark,
                        onPressed: () {
                          if (Validator.isValidName(name) &&
                              Validator.isValidEmail(email) &&
                              password.length > 6 &&
                              email != null &&
                              email != '') {
                            DatabaseAPI.checkIfEmailExists(email)
                                .then((value) => {
                                      if (value == 'Exists')
                                        {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "the email already has been used please choose another one")
                                        }
                                      else
                                        {
                                          Navigator.pushNamed(
                                              context, SpecifyRoleScreen.id),
                                        }
                                    });
                          } else {
                            password.length <= 6
                                ? Fluttertoast.showToast(
                                    msg:
                                        'Password length should be more then 6')
                                : Fluttertoast.showToast(
                                    msg:
                                        'Please fill up all the information before proceed to next step');
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final IconData prefixIconData;
  final Icon suffixIcon;
  bool obscureText;
  final Function onChanged;
  final Color colorScheme;
  bool isPassword;

  TextFieldWidget(
      {this.hintText,
      this.obscureText,
      this.onChanged,
      this.prefixIconData,
      this.suffixIcon,
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
      style: TextStyle(color: Theme.of(context).primaryColorDark, fontSize: 18),
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
                  ? widget.suffixIcon.icon
                  : !SignupScreen.passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
              size: 21,
              color: (!widget.isPassword)
                  ? widget.suffixIcon.color
                  : widget.colorScheme,
            ),
          ),
          onTap: () {
            setState(() {
              SignupScreen.passwordVisible = !SignupScreen.passwordVisible;
              widget.obscureText = !widget.obscureText;
            });
          },
        ),
        labelStyle: TextStyle(color: widget.colorScheme, fontSize: 20),
      ),
    );
  }
}
