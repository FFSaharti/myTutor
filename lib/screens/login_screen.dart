import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/animated_login_widget.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/homepage_screen_student.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/regEx.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  static bool passwordVisible = true;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double width;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
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
                    buttonText: "Login",
                    hasBorder: false,
                    borderColor: null,
                    onPressed: () {
                      DatabaseAPI.userLogin(email, password).then((value) => {
                            if (value == "Success")
                              {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: new Text("Welcome"),
                                    duration:
                                        const Duration(milliseconds: 500))),
                                Navigator.pushNamed(
                                    context, HomepageScreenStudent.id)
                              }
                            else
                              {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: new Text(value),
                                    duration:
                                        const Duration(milliseconds: 500)))
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
