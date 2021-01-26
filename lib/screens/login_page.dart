import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/utilities/regEx.dart';

class LoginPage extends StatefulWidget {
  static String id = 'login_page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Image.asset(
                'images/myTutorLogoColored.png',
                width: double.infinity,
                height: 100,
              ),
            ),
            SizedBox(
              height: 150,
            ),
            TextFieldWidget(
              hintText: 'Email',
              obscureText: false,
              prefixIconData: Icons.mail_outline,
              colorScheme: Colors.teal,
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
              obscureText: !passwordVisible,
              prefixIconData: Icons.lock,
              suffixIconData:
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
              colorScheme: Colors.teal,
              // isVisible: passwordVisible,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIconData;
  final IconData suffixIconData;
  final bool obscureText;
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
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(color: colorScheme, fontSize: 14),
      decoration: InputDecoration(
        labelText: hintText,
        prefixIcon: Icon(
          prefixIconData,
          size: 18,
          color: colorScheme,
        ),
        filled: true,
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            print('pressed');
          },
          child: Icon(
            suffixIconData,
            size: 18,
            color: colorScheme,
          ),
        ),
        labelStyle: TextStyle(color: colorScheme),
      ),
    );
  }
}
