import 'package:flutter/material.dart';

import 'scale_img_widget.dart';

class AnimatedSolveProblemWidget extends StatelessWidget {
  const AnimatedSolveProblemWidget({
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
            width: 80,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 190,
          top: 30,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Question.png',
            width: 20,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 250,
          top: 5,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/QuestionText.png',
            width: 165,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 20,
          top: 37,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/PersonProblem.png',
            width: 80,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 10,
          top: 150,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/Answer.png',
            width: 30,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 0,
          top: 135,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3000,
            imgPath: 'images/TourScreen/AnswerText.png',
            width: 165,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 100,
          top: 155,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
