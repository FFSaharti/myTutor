import 'package:flutter/material.dart';
import 'package:mytutor/utilities/constants.dart';

class ProfileInfoWidget extends StatelessWidget {
  ProfileInfoWidget(this.infoTitle, this.infoNum);

  String infoTitle = "";
  String infoNum = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 53,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                infoTitle,
                style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 18,fontWeight: FontWeight.bold),
              ),
              Text(
                infoNum,
                style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 18,fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }
}