import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/utilities/screen_size.dart';

class ProfileInfoWidget extends StatelessWidget {
  ProfileInfoWidget(this.infoTitle, this.infoNum);

  String infoTitle = "";
  String infoNum = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width * 0.22,
      height: ScreenSize.height * 0.075,
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
                style: GoogleFonts.sen(
                    color: Theme.of(context).buttonColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                infoNum,
                style: GoogleFonts.sen(
                    color: Theme.of(context).buttonColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ]),
      ),
    );
  }
}
