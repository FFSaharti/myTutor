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
          imgPath: 'images/frame.jpg',
          width: 290,
          animationStyleCurve: Curves.fastLinearToSlowEaseIn,
          repeat: false,
          frame: true,
        ),

        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/man.png',
            width: 120,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          right: 140,
          top: 100,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/faq.png',
            width: 80,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 180,
          top: 30,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/puzzle.png',
            width: 80,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          right: 50,
          top: 140,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
