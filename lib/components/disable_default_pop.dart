import 'package:flutter/material.dart';

class DisableDefaultPop extends StatefulWidget {
  Widget child;

  DisableDefaultPop({Key key, this.child}) : super(key: key);

  @override
  _DisableDefaultPopState createState() => _DisableDefaultPopState();
}

class _DisableDefaultPopState extends State<DisableDefaultPop> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false, child: widget.child);
  }
}
