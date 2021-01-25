import 'package:flutter/material.dart';
import 'package:mytutor/screens/welcome_screen.dart';
import 'package:mytutor/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  static Widget logo = Image.asset('images/myTutorLogoWhite.png', height: 150);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.2, 0.4, 0.6, 0.8],
          colors: [
            kColorScheme[0],
            kColorScheme[1],
            kColorScheme[2],
            kColorScheme[3]
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, WelcomeScreen.id);
                },
                child: Hero(tag: 'logo', child: logo),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
