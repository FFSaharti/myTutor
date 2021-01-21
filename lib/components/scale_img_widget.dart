import 'package:flutter/material.dart';

class ScaleImgWidget extends StatefulWidget {
  ScaleImgWidget(
      {@required this.milliseconds,
      @required this.imgPath,
      @required this.width,
      @required this.animationStyleCurve,
      this.repeat,
      this.imgcolor,
      this.frame});

  final int milliseconds;
  final String imgPath;
  final double width;
  final Curve animationStyleCurve;
  final bool repeat;
  final Color imgcolor;
  final bool frame;

  @override
  _ScaleImgWidgetState createState() => _ScaleImgWidgetState();
}

class _ScaleImgWidgetState extends State<ScaleImgWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.milliseconds),
      vsync: this,
    )..repeat(reverse: widget.repeat);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationStyleCurve,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScaleTransition(
        scale: _animation,
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
              widget.imgPath,
              color: widget.frame ? Color(0x00000000) : null,
              width: widget.width,
            )),
      ),
    );
  }
}
