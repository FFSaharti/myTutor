import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/components/question_stream_widget.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AskScreenStudent extends StatefulWidget {
  static String id = 'ask_screen_student';
  @override
  _AskScreenStudentState createState() => _AskScreenStudentState();
}

class _AskScreenStudentState extends State<AskScreenStudent> {
  PageController _pageController = PageController();
  TextEditingController _searchController = TextEditingController();
  int _dropDownMenuController = 0;

  viewFilters() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return Container(
              height: ScreenSize.height * 0.40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Text(
                          "Filter Options",
                          style: kTitleStyle.copyWith(
                              color: Colors.black, fontSize: 17),
                        ),
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(
                            "Subject",
                            style: GoogleFonts.sen(fontSize: 17),
                          ),
                          Spacer(),
                          DropdownButton(
                            value: _dropDownMenuController,
                            items: fetchSubjects(),
                            onChanged: (value) {
                              setState(() {
                                setModalState(() {
                                  _dropDownMenuController = value;
                                  print("subject chosen is --> " +
                                      _dropDownMenuController.toString());
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  List<DropdownMenuItem> fetchSubjects() {
    List<DropdownMenuItem> items = [];
    items.add(DropdownMenuItem(
      child: Text("All Subjects"),
      value: 0,
    ));
    for (int i = 0; i < subjects.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(subjects.elementAt(i).title),
        value: i + 1,
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: kColorScheme[3]),
              onPressed: () => showAddQuestion(),
            ),
          ],
          centerTitle: true,
          title: Text(
            "Ask",
            style: GoogleFonts.sen(color: Colors.black, fontSize: 25),
          ),
          leading: Villain(
            villainAnimation: VillainAnimation.fade(
              from: Duration(milliseconds: 300),
              to: Duration(milliseconds: 700),
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_sharp, color: kColorScheme[3]),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              print("updating questions...");
            },
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    ListTile(
                      title: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        style: TextStyle(
                          color: kBlackish,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          hintText: 'Search',
                          prefixIcon:
                              Icon(Icons.search, color: kColorScheme[2]),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          viewFilters();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kWhiteish),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.sort,
                              size: 28,
                              color: kColorScheme[2],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: ScreenSize.height * 0.02,
                    ),
                    Container(
                      height: ScreenSize.height * 0.75,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        // ignore: missing_return
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                        },
                        child: PageView(
                          controller: _pageController,
                          children: [
                            mainScreenPage(
                                QuestionStream(
                                  status: "Active",
                                  searchTitle: _searchController.text,
                                  chosenSubject: _dropDownMenuController,
                                ),
                                "Active Questions"),
                            mainScreenPage(
                                QuestionStream(
                                  status: "Closed",
                                  searchTitle: _searchController.text,
                                  chosenSubject: _dropDownMenuController,
                                ),
                                "Closed Questions"),
                          ],
                        ),
                      ),
                    ),
                    SmoothPageIndicator(
                      effect: WormEffect(
                          dotColor: kGreyish, activeDotColor: kColorScheme[2]),
                      controller: _pageController, // PageController
                      count: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  mainScreenPage(Widget StreamWidget, String title) {
    return Column(
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.sen(
                textStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.normal,
                    color: kGreyish)),
          ),
        ),
        StreamWidget,
        SizedBox(
          height: ScreenSize.height * 0.06,
        ),
      ],
    );
  }
}

void showAddQuestion() {
  List<Widget> searchResults = [];
  String searchBox = '';

  TextEditingController titleController = TextEditingController();
  TextEditingController problemController = TextEditingController();
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.vertical(top: Radius.circular(2.0))
          ),
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
      context: ScreenSize.context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
              height: ScreenSize.height * 0.9,
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: Scaffold(
                  body: Container(
                    //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    height: ScreenSize.height * 0.70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50)
                        //   topRight: Radius.circular(100),
                        //   topLeft: Radius.circular(100),
                        // )
                        ,
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                                Text(
                                  "Add New Question",
                                  style: TextStyle(fontSize: 20),
                                ),
                                IconButton(
                                  icon: Icon(Icons.check),
                                  onPressed: () {
                                    // ADD NEW QUESTION
                                    if (titleController.text.isNotEmpty &&
                                        problemController.text.isNotEmpty &&
                                        getChosenSubject() != -1) {
                                      DatabaseAPI.addQuestionToStudent(
                                          titleController.text,
                                          problemController.text,
                                          SessionManager.loggedInStudent,
                                          getChosenSubject());
                                      Fluttertoast.showToast(
                                          msg: 'Question Added!');
                                      print("POP...");
                                      Navigator.pop(context);
                                    } else {
                                      print("empty parameters");
                                      Fluttertoast.showToast(
                                          msg: 'Missing/Invalid Information');
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Question Title",
                                      style: GoogleFonts.secularOne(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                    ),
                                  ),
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Type something...',
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Question Description",
                                      style: GoogleFonts.secularOne(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                    ),
                                  ),
                                  TextField(
                                    controller: problemController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: 'Type something...',
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Subject",
                                      style: GoogleFonts.secularOne(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          setModalState(() {
                                            searchBox = value;
                                            getSubjects(searchBox);
                                            // getSelectedSubjects(selectedInterests);
                                          });
                                        },
                                        style: TextStyle(
                                          color: kBlackish,
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          filled: true,
                                          hintText: 'Search',
                                          prefixIcon: Icon(Icons.search,
                                              color: kColorScheme[2]),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        height: 50,
                                        child: GestureDetector(
                                          onTap: () {
                                            setModalState(() {
                                              print("Entered Set State new");
                                            });
                                          },
                                          child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: getSubjects(searchBox)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ));
        });
      });
}

int getChosenSubject() {
  int chosenSubject = -1;
  for (int i = 0; i < subjects.length; i++) {
    if (subjects[i].chosen) {
      chosenSubject = i;
    }
  }

  return chosenSubject;
}

List<Widget> getSubjects(String searchBox) {
  List<Widget> searchResults = [];
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

  return searchResults;
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
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 15,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            unchooseRemainingInterests(widget.subject.id);
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

void unchooseRemainingInterests(int id) {
  for (int i = 0; i < subjects.length; i++) {
    if (i != id) {
      subjects[i].chosen = false;
    }
  }
}
