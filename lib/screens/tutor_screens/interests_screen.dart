import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

import 'homepage_screen_tutor.dart';


class InterestsScreen extends StatefulWidget {
  static String id = 'interests_screen';

  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<Widget> selectedInterests = [];
  List<Widget> searchResults = [];
  String searchBox = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                onChanged: (value) {
                  setState(() {
                    searchBox = value;
                    getSubjects(searchBox);
                    // getSelectedSubjects(selectedInterests);
                  });
                },
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                height: 50,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print("Entered Set State");
                      getSelectedSubjects();
                    });
                  },
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: searchResults,
                  ),
                ),
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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: selectedInterests,
                ),
              ),
              Container(
                height: 130,
              ),
              SizedBox(
                height: 8,
              ),
              // EZButton(
              //     width: width,
              //     buttonColor: Colors.red,
              //     textColor: Colors.white,
              //     isGradient: false,
              //     colors: null,
              //     buttonText: "Update",
              //     hasBorder: false,
              //     borderColor: null,
              //     onPressed: () {
              //       setState(() {
              //         getSelectedSubjects(selectedInterests);
              //       });
              //     }),
              Builder(builder: (context) {
                return EZButton(
                    width: ScreenSize.width,
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
                      DatabaseAPI.createTutor(DatabaseAPI.tempUser.email)
                          .then((value) => {
                                if (value == "Success")
                                  {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: new Text("Welcome"),
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(milliseconds: 500))),
                                    Navigator.pushNamed(
                                        context, HomepageScreenTutor.id)
                                  }
                                else
                                  {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: new Text(value),
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(milliseconds: 500))),
                                  }
                              });
                    });
              })
            ],
          ),
        ));
  }

  void getSubjects(String searchBox) {
    searchResults = [];
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].searchKeyword(searchBox)) {
        searchResults.add(
          InterestWidget(subjects[i]),
        );
        searchResults.add(SizedBox(
          width: 15,
        ));
      }
    }
  }

  void getSelectedSubjects() {
    selectedInterests = [];
    for (int i = 0; i < subjects.length; i++) {
      print('Entered Loop for ' + subjects[i].title);
      if (subjects[i].chosen) {
        print(subjects[i].title + ' is chosen! ');
        selectedInterests.add(
          InterestWidget(subjects[i]),
        );
        selectedInterests.add(SizedBox(
          width: 15,
        ));
        print(subjects[i].title + " was added to selected interests");
      }
    }
  }
}

class InterestWidget extends StatefulWidget {
  Subject subject;
  bool chosen = false;

  InterestWidget(this.subject);

  @override
  _InterestWidgetState createState() => _InterestWidgetState();
}

class _InterestWidgetState extends State<InterestWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget.chosen || widget.subject.chosen
            ? Color(0xff99FFB5)
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.chosen = !widget.chosen;
            widget.subject.toggleChosen();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.chosen || widget.subject.chosen
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
