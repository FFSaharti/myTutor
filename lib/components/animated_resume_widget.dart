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
          imgPath: 'images/paper.png',
          width: 300,
          animationStyleCurve: Curves.fastLinearToSlowEaseIn,
          repeat: false,
          frame: false,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/man.png',
            width: 100,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 30,
          top: 20,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/check.png',
            width: 50,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 150,
          top: 90,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/cancel.png',
            width: 50,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 150,
          top: 30,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/pencil.png',
            width: 130,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 170,
          top: -15,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3090,
            imgPath: 'images/list-text.png',
            width: 130,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 40,
          top: 130,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3090,
            imgPath: 'images/skill.png',
            width: 70,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 190,
          top: 130,
        ),

        // )
      ],
      overflow: Overflow.visible,
    );
  }
}
