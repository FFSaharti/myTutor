import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';

const List<Color> kColorScheme = [
  Color(0xFF9ACA69),
  Color(0xFF90ce4e),
  Color(0xFF7ccc26),
  Color(0xFF6acc02),
  Color(0xFF4F9900),
];

TextStyle kTitleStyle = GoogleFonts.secularOne(
    textStyle: TextStyle(
        fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white));

Gradient kBackgroundGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  stops: [0.2, 0.4, 0.6, 0.8],
  colors: [kColorScheme[0], kColorScheme[1], kColorScheme[2], kColorScheme[3]],
);

const Color kBlackish = Color(0xFF070707);
const Color kGreyish = Color(0xFFb5b5b5);

const List validEmail = ['test@gmail.com'];

List<Subject> subjects = [
  Subject(0, 'JAVA', 'images/Sub-Icons/Java.png'),
  Subject(1, 'HTML', 'images/Sub-Icons/HTML.png'),
  Subject(2, 'C#', 'images/Sub-Icons/C#.png'),
];
