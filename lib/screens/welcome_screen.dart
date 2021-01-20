import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tour_screen.dart';

class WelcomeScreen extends StatelessWidget {
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/myTutorLogoColored.png',
                    width: 100,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'My Tutor',
                  style: GoogleFonts.secularOne(
                      textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3F6CF4))),
                ),
                SizedBox(
                  height: 170,
                ),
                // EZButton(
                //   width: width,
                //   buttonColor: Color(0xFF9ACA69),
                //   textColor: Colors.white,
                //   buttonText: 'Get Started',
                //   hasBorder: false,
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                // EZButton(
                //   width: width,
                //   buttonColor: Colors.white,
                //   textColor: Color(0xFF9ACA69),
                //   buttonText: 'Login',
                //   hasBorder: true,
                //   borderColor: Color(0xFF9ACA69),
                // ),
                GradientButton(
                  width: width,
                  buttonColor: null,
                  textColor: Colors.white,
                  isGradient: true,
                  colors: [Color(0xFF59A1FF), Color(0xFF3F6CF4)],
                  buttonText: 'Get Started',
                  hasBorder: false,
                  borderColor: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => tour_screen()),
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                GradientButton(
                  width: width,
                  buttonColor: Colors.white,
                  textColor: Color(0xFF3F6CF4),
                  isGradient: false,
                  colors: [Color(0xFF59A1FF), Color(0xFF3F6CF4)],
                  buttonText: 'Login',
                  hasBorder: true,
                  borderColor: Color(0xFF59A1FF),
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  GradientButton({@required this.width,
    @required this.buttonColor,
    @required this.textColor,
    @required this.isGradient,
    @required this.colors,
    @required this.buttonText,
    @required this.hasBorder,
    @required this.borderColor,
    @required this.onPressed});

  final double width;
  final Color buttonColor;
  final bool isGradient;
  final List<Color> colors;
  final Color textColor;
  final String buttonText;
  final bool hasBorder;
  final Color borderColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: hasBorder ? BorderSide(color: borderColor) : BorderSide.none),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: isGradient
                  ? LinearGradient(
                colors: [colors[0], colors[1]],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
                  : null,
              color: isGradient ? null : buttonColor,
              borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            constraints:
            BoxConstraints(maxWidth: width * 0.75, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
