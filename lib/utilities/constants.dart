import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
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
const Color kGreyerish = Color(0xff7B7B7B);
const Color kWhiteish = Color(0xffe2e2e2);

const List validEmail = ['test@gmail.com'];

// TODO: Edit subjects images in photoshop
List<Subject> subjects = [
  Subject(0, 'JAVA', 'images/Sub-Icons/Java.png', ['Object-Oriented', 'JAVA'],
      false),
  Subject(1, 'HTML', 'images/Sub-Icons/HTML.png',
      ['Web Development', 'HTML', 'html', 'web'], false),
  Subject(2, 'C#', 'images/Sub-Icons/C#.png',
      ['C#', 'C Sharp', 'Game Development'], false),
  Subject(3, 'Unity', 'images/Sub-Icons/Unity.png',
      ['Unity', 'Game Development'], false),
  Subject(
      4, 'CSS', 'images/Sub-Icons/CSS.png', ['CSS', 'Web Development'], false),
  Subject(5, 'Photoshop', 'images/Sub-Icons/Photoshop.png',
      ['Photoshop', 'Images', 'Design'], false),
  Subject(6, 'React', 'images/Sub-Icons/React.png',
      ['React', 'JS', 'Javascript', 'JavaScript', 'Web Development'], false),
  Subject(7, 'Blender', 'images/Sub-Icons/Blender.png',
      ['Blender', 'Editing', 'Animation', 'Design'], false),
  Subject(8, 'Firebase', 'images/Sub-Icons/Firebase.png',
      ['Firebase', 'DB', 'Database', 'Backend'], false),
  Subject(9, 'C++', 'images/Sub-Icons/CPlusPlus.png',
      ['C++', 'C', 'C Plus Plus', '++'], false),
  Subject(
      10,
      'Android Studio',
      'images/Sub-Icons/AndroidStudio.png',
      ['Android Studio', 'Application Development', 'Kotlin', 'Flutter'],
      false),
  Subject(11, 'Microsoft Word', 'images/Sub-Icons/MSWord.png',
      ['Microsoft Word', 'Word', 'Microsoft Office', 'MS'], false),
  Subject(12, 'Microsoft Powerpoint', 'images/Sub-Icons/MSPP.png',
      ['Microsoft Powerpoint', 'Powerpoint', 'Microsoft Office', 'MS'], false),
  Subject(13, 'Microsoft Excel', 'images/Sub-Icons/MSExcel.png',
      ['Microsoft Excel', 'Excel', 'Microsoft Office', 'MS'], false),
  Subject(14, '', 'images/Sub-Icons/React.png', [], false),
  Subject(15, 'JavaScript', 'images/Sub-Icons/JavaScript.png',
      ['Web Development', 'JS', 'Javascript', 'JavaScript'], false),
  Subject(
      15,
      'Node JS',
      'images/Sub-Icons/NodeJS.png',
      ['Web Development', 'JS', 'Javascript', 'JavaScript', 'Node JS', 'Node'],
      false),
  Subject(16, 'Matlab', 'images/Sub-Icons/Matlab.png',
      ['Matlab', 'Programming'], false),
  Subject(
      17, '.Net', 'images/Sub-Icons/A#.png', ['A#', 'A Sharp', '.NET'], false),
  Subject(18, 'Cinema4D', 'images/Sub-Icons/Cinema4D.png',
      ['Cinema4D', 'Editing', 'Animation', 'Design'], false),
  Subject(19, 'PHP', 'images/Sub-Icons/PHP.png',
      ['Web Development', 'PHP', 'Backend', 'DB'], false),
  Subject(20, 'Ajax', 'images/Sub-Icons/Ajax.png',
      ['Web Development', 'Ajax', 'Backend', 'DB'], false),
  Subject(21, 'Python', 'images/Sub-Icons/Python.png',
      ['Python', 'Programming'], false),
  Subject(22, 'SQL', 'images/Sub-Icons/SQL.png',
      ['SQL', 'Database', 'Backend', 'DB', 'Storage'], false),
  Subject(
      23,
      'Dart',
      'images/Sub-Icons/Dart.png',
      [
        'Flutter',
        'Android Studio',
        'Dart',
        'Kotlin',
        'Application Development'
      ],
      false),
  Subject(
      24,
      'Flutter',
      'images/Sub-Icons/Flutter.png',
      [
        'Flutter',
        'Android Studio',
        'Dart',
        'Kotlin',
        'Application Development'
      ],
      false),
  Subject(
      25,
      'Kotlin',
      'images/Sub-Icons/Kotlin.png',
      [
        'Flutter',
        'Android Studio',
        'Dart',
        'Kotlin',
        'Application Development'
      ],
      false),
];

AppBar buildAppBar(BuildContext context, Color buttonColor, String title,
    [bool removeBackButton]) {
  if (removeBackButton == null) {
    removeBackButton = false;
  }

  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.sen(color: Colors.black, fontSize: 25),
    ),
    leading: Villain(
      villainAnimation: VillainAnimation.fade(
        from: Duration(milliseconds: 300),
        to: Duration(milliseconds: 700),
      ),
      child: (removeBackButton)
          ? Container()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp, color: buttonColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
