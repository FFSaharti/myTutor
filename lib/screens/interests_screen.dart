import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/screens/homepage_screen_student.dart';
import 'package:mytutor/utilities/constants.dart';

class InterestsScreen extends StatefulWidget {
  static String id = 'interests_screen';

  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<Subject> selectedInterests = [];
  double width;
  List<Subject> searchResults = [];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            'Pick Interests',
            style: GoogleFonts.sourceSansPro(
                textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: kBlackish)),
          ),
          SizedBox(
            height: 5,
          ),
          TextField(
            style: TextStyle(
              color: kBlackish,
            ),
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              filled: true,
              hintText: 'Search',
              prefixIcon: Icon(Icons.search, color: kColorScheme[2]),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              ' Search Results',
              style: GoogleFonts.sourceSansPro(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: kGreyish)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: <Widget>[
              // TODO: Read subjects from DatabaseAPI and display them in ListView
              InterestWidget(subjects[1]),
              SizedBox(
                width: 15,
              ),
              InterestWidget(subjects[2]),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                child: InterestWidget(
                  subjects[0],
                ),
                onTap: () {
                  setState(() {
                    selectedInterests.add(subjects[0]);
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Divider(
            color: kGreyish,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              ' Selected Interests',
              style: GoogleFonts.sourceSansPro(
                  textStyle: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.normal,
                      color: kGreyish)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          // TODO : Display ListView of Selected Topics...
          Container(
            height: 130,
          ),
          SizedBox(
            height: 8,
          ),
          EZButton(
              width: width,
              buttonColor: kColorScheme[1],
              textColor: Colors.white,
              isGradient: true,
              colors: [
                kColorScheme[1],
                kColorScheme[2],
                kColorScheme[3],
                kColorScheme[4],
              ],
              buttonText: "Complete Sign Up",
              hasBorder: false,
              borderColor: null,
              onPressed: () {
                //TODO: Add selected topics to tutor
                Navigator.pushNamed(context, HomepageScreenStudent.id);
              }),
        ],
      ),
    ));
  }
}

class InterestWidget extends StatefulWidget {
  Subject subject;

  InterestWidget(this.subject);

  @override
  _InterestWidgetState createState() => _InterestWidgetState();
}

class _InterestWidgetState extends State<InterestWidget> {
  bool chosen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: chosen ? Color(0xff99FFB5) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            chosen = !chosen;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: chosen
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        widget.subject.path,
                        width: 40,
                      ),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ],
                )
              : Image.asset(
                  widget.subject.path,
                  width: 40,
                ),
        ),
      ),
    );
  }
}
