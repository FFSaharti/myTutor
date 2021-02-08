import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/specify_role_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/regEx.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'signup_screen';
  static bool passwordVisible = true;

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  double width;
  String email = '';
  String name = '';

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
              SizedBox(
                height: 50,
              ),
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/myTutorLogoColored.png',
                  width: double.infinity,
                  height: 100,
                ),
              ),
              Text(
                'My Tutor',
                style: GoogleFonts.secularOne(
                    textStyle: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: kColorScheme[2])),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Fill up your information',
                style: GoogleFonts.secularOne(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey)),
              ),
              SizedBox(
                height: 50,
              ),
              TextFieldWidget(
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
                  Validator.isValidName(value);
                },
              ),
              SizedBox(
                height: 10,
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
                obscureText: SignupScreen.passwordVisible,
                prefixIconData: Icons.lock,
                suffixIconData: SignupScreen.passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                colorScheme: kColorScheme[4],
                // isVisible: passwordVisible,
              ),
              SizedBox(
                height: 2,
              ),
              SizedBox(
                height: 40,
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
                  buttonText: "Next",
                  hasBorder: false,
                  borderColor: null,
                  onPressed: () {
                    Navigator.pushNamed(context, SpecifyRoleScreen.id);
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
        labelStyle: TextStyle(color: widget.colorScheme),
      ),
    );
  }
}
