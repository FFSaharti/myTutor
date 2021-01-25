import 'package:flutter/material.dart';

import 'scale_img_widget.dart';

class AnimatedmMaterialsWidget extends StatelessWidget {
  const AnimatedmMaterialsWidget({
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
            imgPath: 'images/TourScreen/PersonProblem.png',
            width: 160,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 70,
          top: 40,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Book.png',
            width: 90,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 105.9,
          top: 130,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Question.png',
            width: 90,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 105.9,
          top: -50,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Answer.png',
            width: 90,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 50,
          top: -30,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Answer.png',
            width: 90,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 160,
          top: -30,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
