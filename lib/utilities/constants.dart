import 'package:flutter/material.dart';
import 'package:mytutor/classes/Subject.dart';

const List<Color> kColorScheme = [
  Color(0xFF9ACA69),
  Color(0xFF90ce4e),
  Color(0xFF7ccc26),
  Color(0xFF6acc02),
  Color(0xFF4F9900),
];

const Color kBlackish = Color(0xFF070707);
const Color kGreyish = Color(0xFFb5b5b5);

const List validEmail = ['test@gmail.com'];

List<Subject> subjects = [
  Subject(0, 'JAVA', ['Java', 'Object-Oriented'], 'images/Sub-Icons/Java.png'),
  Subject(1, 'HTML', ['HTML', 'Web Development'], 'images/Sub-Icons/HTML.png'),
  Subject(2, 'C#', ['C#', 'Game Development', 'C Sharp'],
      'images/Sub-Icons/C#.png'),
];
