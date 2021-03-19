import 'package:bd_progress_bar/bdprogreebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/screens/login_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:page_transition/page_transition.dart';

class InterestsScreen extends StatefulWidget {
  static String id = 'interests_screen';

  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  List<Widget> selectedInterests = [];
  List<Widget> searchResults = [];
  String searchBox = '';
  bool loading = false;

  void setParentState() {
    setState(() {
      getSelectedSubjects();
    });
  }

  @override
  void initState() {
    stopLoading();
    resetInterests();
    super.initState();
  }

  void beginLoading() {
    setState(() {
      loading = true;
    });
  }

  void stopLoading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DisableDefaultPop(
      child: Scaffold(
          appBar: buildAppBar(
              context, Theme.of(context).accentColor, "Pick Interests"),
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Villain(
                  villainAnimation: VillainAnimation.fromRight(
                    from: Duration(milliseconds: 200),
                    to: Duration(milliseconds: 500),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchBox = value;
                        getSubjects(searchBox);
                      });
                    },
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      filled: true,
                      fillColor:
                          Theme.of(context).primaryColorLight.withOpacity(0.6),
                      hintText: 'Search',
                      hintStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                      prefixIcon: Icon(Icons.search,
                          color: Theme.of(context).accentColor),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.01,
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
                  height: ScreenSize.height * 0.01,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  height: ScreenSize.height * 0.07,
                  child: disableBlueOverflow(
                    context,
                    ListView(
                      scrollDirection: Axis.horizontal,
                      children: searchResults,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.01,
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
                  height: ScreenSize.height * 0.01,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  height: ScreenSize.height * 0.07,
                  child: disableBlueOverflow(
                    context,
                    ListView(
                      scrollDirection: Axis.horizontal,
                      children: selectedInterests,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.1,
                ),
                CircularButton(
                  width: ScreenSize.width * 0.7,
                  buttonColor: Theme.of(context).primaryColorLight,
                  textColor: Colors.white,
                  isGradient: Theme.of(context).primaryColorLight == kWhiteish
                      ? true
                      : false,
                  colors: [
                    kColorScheme[1],
                    kColorScheme[2],
                    kColorScheme[3],
                    kColorScheme[4],
                  ],
                  buttonText: "Sign Up",
                  hasBorder: false,
                  borderColor: null,
                  onPressed: () {
                    beginLoading();
                    int count;
                    DatabaseAPI.createTutor(DatabaseAPI.tempUser.email)
                        .then((value) => {
                              if (value == "Success")
                                {
                                  Fluttertoast.showToast(
                                      msg: "welcome to myTutor :)"),
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType
                                                .leftToRightWithFade,
                                            duration:
                                                Duration(milliseconds: 500),
                                            child: LoginScreen()));
                                  })
                                }
                              else
                                {
                                  // SHOW TOAST MESSAGE OF FAIL
                                  Fluttertoast.showToast(msg: value),
                                  count = 0,
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  }),
                                },
                              stopLoading()
                            });
                    resetInterests();
                  },
                ),
                SizedBox(
                  height: ScreenSize.height * 0.1,
                ),
                loading
                    ? Loader4(
                        dotOneColor: Theme.of(context).accentColor,
                        dotTwoColor: Theme.of(context).accentColor,
                        dotThreeColor: Theme.of(context).accentColor,
                      )
                    : Container(),
              ],
            ),
          )),
    );
  }

  void getSubjects(String searchBox) {
    searchResults = [];
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].searchKeyword(searchBox)) {
        searchResults.add(
          InterestWidget(subjects[i], setParentState),
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
          InterestWidget(subjects[i], setParentState),
        );
        selectedInterests.add(SizedBox(
          width: 15,
        ));
        print(subjects[i].title + " was added to selected interests");
      }
    }
  }

  void resetInterests() {
    for (int i = 0; i < subjects.length; i++) {
      subjects[i].chosen = false;
    }
  }
}

class InterestWidget extends StatefulWidget {
  Subject subject;
  bool chosen = false;
  Function setParentState;
  Function setModalState;

  InterestWidget(this.subject, this.setParentState, [this.setModalState]);

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
            if (widget.setModalState != null) {
              widget.setModalState(() {
                widget.chosen = !widget.chosen;
                widget.subject.toggleChosen();
                widget.setParentState();
                widget.setParentState;
              });
            } else {
              widget.chosen = !widget.chosen;
              widget.subject.toggleChosen();
              widget.setParentState();
              widget.setParentState;
            }
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
