import 'package:flutter/material.dart';

import 'scale_img_widget.dart';

class AnimatedResumeWidget extends StatelessWidget {
  const AnimatedResumeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScaleImgWidget(
          milliseconds: 3000,
          imgPath: 'images/TourScreen/BG.png',
          width: 300,
          animationStyleCurve: Curves.fastLinearToSlowEaseIn,
          repeat: true,
          frame: false,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Paper.png',
            width: 160,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 50,
          top: 30,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Pencil.png',
            width: 31,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 220,
          top: 41,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 2900,
            imgPath: 'images/TourScreen/PersonProblem.png',
            width: 55,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 140,
          top: 70,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 2900,
            imgPath: 'images/TourScreen/Knowledge.png',
            width: 55,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 140,
          top: 150,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 2800,
            imgPath: 'images/TourScreen/Check.png',
            width: 55,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 70,
          top: 90,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 2850,
            imgPath: 'images/TourScreen/Check.png',
            width: 55,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 70,
          top: 130,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 2900,
            imgPath: 'images/TourScreen/Check.png',
            width: 55,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 70,
          top: 170,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
