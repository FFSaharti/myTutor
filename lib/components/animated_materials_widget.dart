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
          imgPath: 'images/frame.jpg',
          width: 290,
          animationStyleCurve: Curves.fastLinearToSlowEaseIn,
          repeat: false,
          frame: true,
        ),

        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/books.png',
            width: 110,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          left: 40,
          top: 100,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/reading.png',
            width: 110,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          right: 17,
          top: 100,
        ),
        Positioned(
          child: ScaleImgWidget(
            milliseconds: 3050,
            imgPath: 'images/lamp.png',
            width: 50,
            animationStyleCurve: Curves.fastLinearToSlowEaseIn,
            repeat: false,
            frame: false,
          ),
          right: 20,
          top: 40,
        ),
      ],
      overflow: Overflow.visible,
    );
  }
}
