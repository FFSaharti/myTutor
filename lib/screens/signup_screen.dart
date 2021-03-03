import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/screens/specify_role_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/regEx.dart';
import 'package:mytutor/utilities/screen_size.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          gradient: kBackgroundGradient,
        ),
        child: Scaffold(
          appBar: buildAppBar(context, Colors.white, ""),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
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
                            color: kColorScheme[4],
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
                    color: Colors.white,
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
                      colorScheme: kColorScheme[4],
                      suffixIconData:
                          Validator.isValidName(name) ? Icons.check : null,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                        DatabaseAPI.tempUser.name = name;
                        Validator.isValidName(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      colorScheme: kColorScheme[4],
                      suffixIconData:
                          Validator.isValidEmail(email) ? Icons.check : null,
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                        DatabaseAPI.tempUser.email = email;
                        Validator.isValidEmail(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
                      suffixIconData: SignupScreen.passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      colorScheme: kColorScheme[4],
                      // isVisible: passwordVisible,
                    ),
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.02,
                  ),
                  SizedBox(
                    height: ScreenSize.height * 0.04,
                  ),
                  Villain(
                    villainAnimation: VillainAnimation.fromBottom(
                      from: Duration(milliseconds: 200),
                      to: Duration(milliseconds: 400),
                    ),
                    child: CircularButton(
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
                        buttonText: 'Next',
                        hasBorder: true,
                        borderColor: kColorScheme[3],
                        onPressed: () {
                          Navigator.pushNamed(context, SpecifyRoleScreen.id);
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
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              SignupScreen.passwordVisible = !SignupScreen.passwordVisible;
              widget.obscureText = !widget.obscureText;
            });
          },
          child: Icon(
            widget.suffixIconData,
            size: 18,
            color: widget.colorScheme,
          ),
        ),
        labelStyle: TextStyle(color: widget.colorScheme, fontSize: 20),
      ),
    );
    // return TextField(
    //   obscureText: widget.obscureText,
    //   onChanged: widget.onChanged,
    //   style: TextStyle(color: kColorScheme[4], fontSize: 14),
    //   decoration: InputDecoration(
    //     labelText: widget.hintText,
    //     prefixIcon: Icon(
    //       widget.prefixIconData,
    //       size: 18,
    //       color: widget.colorScheme,
    //     ),
    //     filled: true,
    //     enabledBorder: UnderlineInputBorder(
    //         borderRadius: BorderRadius.circular(10),
    //         borderSide: BorderSide.none),
    //     focusedBorder: OutlineInputBorder(
    //       borderRadius: BorderRadius.circular(10),
    //       borderSide: BorderSide(color: widget.colorScheme),
    //     ),
    //     suffixIcon: GestureDetector(
    //       onTap: () {
    //         setState(() {
    //           SignupScreen.passwordVisible = !SignupScreen.passwordVisible;
    //           widget.obscureText = !widget.obscureText;
    //         });
    //       },
    //       child: Icon(
    //         widget.suffixIconData,
    //         size: 18,
    //         color: widget.colorScheme,
    //       ),
    //     ),
    //     labelStyle: TextStyle(color: widget.colorScheme),
    //   ),
    // );
  }
}
