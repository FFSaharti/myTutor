import 'package:flutter/material.dart';

import 'scale_img_widget.dart';

class AnimatedLoginWidget extends StatelessWidget {
  const AnimatedLoginWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ScaleImgWidget(
          milliseconds: 3000,
          imgPath: 'images/Login/Login-1.png',
          width: 150,
          animationStyleCurve: Curves.fastLinearToSlowEaseIn,
          repeat: true,
          frame: false,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 2000,
            imgPath: 'images/Login/Login-2.png',
            width: 120,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: true,
            frame: false,
          ),
          left: 15,
          top: 160,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 1500,
            imgPath: 'images/Login/Login-3-4-5-6-7.png',
            width: 20,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 30,
          top: 170,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 1500,
            imgPath: 'images/Login/Login-3-4-5-6-7.png',
            width: 20,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 50,
          top: 170,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 1500,
            imgPath: 'images/Login/Login-3-4-5-6-7.png',
            width: 20,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 80,
          top: 170,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 1500,
            imgPath: 'images/Login/Login-3-4-5-6-7.png',
            width: 20,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 100,
          top: 170,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
