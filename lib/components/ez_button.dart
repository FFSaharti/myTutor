import 'package:flutter/material.dart';

class EZButton extends StatelessWidget {
  EZButton(
      {@required this.width,
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
