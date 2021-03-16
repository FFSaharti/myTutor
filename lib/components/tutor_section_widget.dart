import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/screens/tutor_screens/tutor_options.dart';

class TutorSectionWidget extends StatelessWidget {
  TutorSectionWidget(
      {@required this.widget,
      @required this.onClick,
      @required this.imgPath,
      @required this.title,
      @required this.description});

  final TutorOptions widget;
  final Function onClick;
  final String imgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Theme.of(context).cardColor,
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imgPath,
                    width: 50,
                  ),
                ],
              ),
              title: Text(
                title,
                style: GoogleFonts.sarala(
                    fontSize: 25, color: Theme.of(context).buttonColor),
              ),
              subtitle: Text(
                description,
                style: GoogleFonts.sarala(
                    fontSize: 14, color:Theme.of(context).buttonColor),
              ),
              trailing: Container(
                height: double.infinity,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Theme.of(context).buttonColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
