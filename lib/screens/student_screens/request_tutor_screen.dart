import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/components/circular_button.dart';
import 'package:mytutor/components/disable_default_pop.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

import '../view_receiver_profile.dart';

class RequestTutorScreen extends StatefulWidget {
  static String id = 'request_tutor_screen';

  @override
  _RequestTutorScreenState createState() => _RequestTutorScreenState();
}

class _RequestTutorScreenState extends State<RequestTutorScreen> {
  List<Tutor> tutors = [];
  List<Rate> tutorRates = [];
  List<MyUser> searchedTutors = [];
  TextEditingController searchController = TextEditingController();
  int _dropDownMenuController = 1;
  int _dropDownMenuControllerForRating = 1;
  bool checkedExperineceFilter = false;
  bool checkedRateFilter = false;
  List<dynamic> tutorsSubjects = [];

  _filterTutors(String name) {
    setState(() {
      searchedTutors = tutors
          .where(
              (Tutor) => Tutor.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  getTutorsFromApi() async {
    var response = await DatabaseAPI.getTutors();
    return response;
  }

  fetchRates(Tutor tutor) {
    Timestamp stamptemp;
    DatabaseAPI.getTutorRates(tutor.userId).then((value) => {
          for (var rate in value.docs)
            {
              stamptemp = rate.data()["rateDate"],
              tutorRates.add(Rate(
                rate.data()["review"],
                rate.data()["teachingSkills"],
                rate.data()["friendliness"],
                rate.data()["communication"],
                rate.data()["creativity"],
                stamptemp.toDate(),
                rate.data()["sessionTitle"],
              )),
              tutor.rates = tutorRates,
            }
        });
  }

  void initState() {
    getTutorsFromApi().then((data) {
      setState(() {
        Tutor temp;
        for (var tutor in data.docs) {
          temp = Tutor(
              tutor.data()["name"],
              tutor.data()["email"],
              tutor.data()["pass"],
              tutor.data()["aboutMe"],
              tutor.id,
              [],
              tutor.data()["profileImg"]);
          List.from(tutor.data()['experiences']).forEach((element) {
            temp.addExperience(element);
          });

          tutors.add(temp);
        }
      });
    }).whenComplete(() => {
          for (var tutor in tutors)
            {
              fetchRates(tutor),
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int fromDurationAnimationConter = 0;
    int toDurationAnimationConter = 400;
    return DisableDefaultPop(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: buildAppBar(
            context, Theme.of(context).accentColor, "Request Tutor"),
        //resizeToAvoidBottomInset : false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    VillainController.playAllVillains(context);
                    setState(() {
                      _filterTutors(value);
                      if (searchController.text.isEmpty) {
                        searchedTutors = [];
                      }
                    });
                  },
                  style: TextStyle(color: Theme.of(context).accentColor),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor:
                        Theme.of(context).primaryColorLight.withOpacity(0.6),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Theme.of(context).accentColor),
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
                trailing: GestureDetector(
                  onTap: () {
                    showFilterOptions();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context)
                            .primaryColorLight
                            .withOpacity(0.6)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.sort,
                        size: 28,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: ScreenSize.width * 0.9,
                child: Divider(),
              ),
              SizedBox(
                height: ScreenSize.height * 0.01,
              ),
              searchedTutors.length > 0
                  ? Text(
                      "Showing " +
                          searchedTutors.length.toString() +
                          " Results",
                      style: GoogleFonts.sen(
                          fontSize: 18, color: Theme.of(context).accentColor))
                  : Text(""),
              Expanded(
                child: disableBlueOverflow(
                  context,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.9,
                        crossAxisCount: 2,
                        crossAxisSpacing: .0,
                        mainAxisSpacing: 5.0,
                      ),
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
                      // scrollDirection: Axis.horizontal,
                      itemCount: searchedTutors.length,
                      itemBuilder: (context, index) {
                        fromDurationAnimationConter += 100;
                        toDurationAnimationConter += 100;
                        return Villain(
                          villainAnimation: VillainAnimation.fromBottom(
                            from: Duration(
                                milliseconds: fromDurationAnimationConter),
                            to: Duration(
                                milliseconds: toDurationAnimationConter),
                          ),
                          child: TutorWidget(
                              tutor: searchedTutors.elementAt(index)),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 150,),
              //Temp solution
            ],
          ),
        ),
      ),
    );
  }

  void showFilterOptions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                height: ScreenSize.height * 0.40,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          Text(
                            "Filter Options",
                            style: GoogleFonts.sen(
                                color: Theme.of(context).buttonColor,
                                fontSize: 17),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onPressed: () {
                                setState(() {
                                  searchedTutors = [];
                                });
                                applyFilter();
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                      SizedBox(
                        height: ScreenSize.height * 0.030,
                      ),
                      Text(
                        "Filter based on",
                        style: GoogleFonts.sen(
                            fontSize: 17,
                            color: Theme.of(context).buttonColor,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: ScreenSize.height * 0.010,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: kColorScheme[2],
                              value: checkedExperineceFilter,
                              onChanged: (bool value) {
                                setModalState(() {
                                  checkedExperineceFilter = value;
                                });
                              }),
                          Text(
                            " On experience ",
                            style: GoogleFonts.sen(
                                fontSize: 18,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: ScreenSize.width * 0.040,
                          ),
                          Expanded(
                            child: DropdownButton(
                              dropdownColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              isExpanded: true,
                              value: _dropDownMenuController,
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              items: fetchSubjects(),
                              onChanged: (value) {
                                setState(() {
                                  setModalState(() {
                                    _dropDownMenuController = value;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ScreenSize.height * 0.010,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: kColorScheme[2],
                              value: checkedRateFilter,
                              onChanged: (bool value) {
                                setModalState(() {
                                  checkedRateFilter = value;
                                });
                              }),
                          Text(
                            " Rating above ",
                            style: GoogleFonts.sen(
                                fontSize: 18,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: ScreenSize.width * 0.040,
                          ),
                          Expanded(
                            child: DropdownButton(
                              dropdownColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              isExpanded: true,
                              value: _dropDownMenuControllerForRating,
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  setModalState(() {
                                    _dropDownMenuControllerForRating = value;
                                  });
                                });
                              },
                              items: <int>[1, 2, 3, 4, 5]
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Center(
                                      child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                  )),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  List<DropdownMenuItem> fetchSubjects() {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < subjects.length; i++) {
      items.add(DropdownMenuItem(
        child: Center(
          child: Text(
            subjects.elementAt(i).title,
            style: GoogleFonts.sen(color: Theme.of(context).buttonColor),
          ),
        ),
        value: i,
      ));
    }
    return items;
  }

  void applyFilter() {
    if (checkedExperineceFilter == true && checkedRateFilter == true) {
      for (int i = 0; i < tutors.length; i++) {
        for (int j = 0; j < tutors.elementAt(i).experiences.length; j++) {
          if (tutors.elementAt(i).experiences.elementAt(j) ==
              _dropDownMenuController) {
            if (Rate.getAverageRate(tutors.elementAt(i).rates) >
                _dropDownMenuControllerForRating) {
              searchedTutors.add(tutors.elementAt(i));
              break;
            }
          }
        }
      }
    } else if (checkedExperineceFilter == true) {
      setState(() {
        for (int i = 0; i < tutors.length; i++) {
          for (int j = 0; j < tutors.elementAt(i).experiences.length; j++) {
            if (tutors.elementAt(i).experiences.elementAt(j) ==
                _dropDownMenuController) {
              searchedTutors.add(tutors.elementAt(i));
              break;
            }
          }
        }
      });
    } else if (checkedRateFilter == true) {
      for (var tutor in tutors) {
        Rate.getAverageRate(tutor.rates) >= _dropDownMenuControllerForRating
            ? searchedTutors.add(tutor)
            : Text("");
      }
    }
  }
}

class TutorWidget extends StatefulWidget {
  final MyUser tutor;

  const TutorWidget({Key key, this.tutor}) : super(key: key);

  @override
  _TutorWidgetState createState() => _TutorWidgetState();
}

class _TutorWidgetState extends State<TutorWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).scaffoldBackgroundColor, width: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewReceiverProfile(
                                userId: widget.tutor.userId,
                                role: 'tutor',
                              )),
                    ).then((value) => {
                          WidgetsBinding.instance.focusManager.primaryFocus
                              ?.unfocus(),
                        });
                  },
                  child: Icon(Icons.info_outline, color: Colors.white),
                ),
              ),
            ),
            widget.tutor.profileImag == ""
                ? Container(
                    width: ScreenSize.width * 0.20,
                    height: ScreenSize.height * 0.10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.account_circle_sharp,
                        size: ScreenSize.height * 0.10,
                      ),
                    ),
                  )
                : Container(
                    width: ScreenSize.width * 0.20,
                    height: ScreenSize.height * 0.09,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(widget.tutor.profileImag),
                          fit: BoxFit.fill),
                    ),
                  ),
            Text(
              widget.tutor.name,
              style: GoogleFonts.sen(
                  textStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).buttonColor)),
            ),
            SizedBox(
              height: ScreenSize.height * 0.01,
            ),
            CircularButton(
              width: ScreenSize.width * 0.4,
              height: ScreenSize.height * 0.04,
              fontSize: 18,
              buttonColor: kColorScheme[1],
              textColor: Colors.white,
              isGradient: false,
              colors: null,
              buttonText: "Request",
              hasBorder: false,
              borderColor: null,
              onPressed: () {
                DatabaseAPI.resetInterests();
                showbutton(widget.tutor);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showbutton(MyUser tutor) {
    String _preffredDate;
    String _date;
    String searchBox = '';

    List<Widget> getSubjects(String searchBox) {
      List<Widget> searchResults = [];
      for (int i = 0; i < subjects.length; i++) {
        if (subjects[i].searchKeyword(searchBox)) {
          searchResults.add(
            InterestWidget(subjects[i]),
          );
          searchResults.add(SizedBox(
            width: ScreenSize.width * 0.01,
          ));
        }
      }

      return searchResults;
    }

    TextEditingController timeController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController problemController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return disableBlueOverflow(
                context,
                Container(
                  height: ScreenSize.height * 0.95,
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    height: ScreenSize.height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).scaffoldBackgroundColor),
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
                                  "Session Details",
                                  style: GoogleFonts.sen(
                                      fontSize: 20,
                                      color: Theme.of(context).buttonColor),
                                ),
                                IconButton(
                                    icon: Icon(Icons.check),
                                    onPressed: () {
                                      if (titleController.text.isNotEmpty &&
                                          dateController.text.isNotEmpty &&
                                          problemController.text.isNotEmpty &&
                                          timeController.text.isNotEmpty) {
                                        DatabaseAPI.createNewSession(
                                                titleController.text,
                                                problemController.text,
                                                dateController.text,
                                                tutor,
                                                timeController.text,
                                                getChosenSubject())
                                            .then((value) => {
                                                  if (value == "success")
                                                    {
                                                      AwesomeDialog(
                                                        context: context,
                                                        animType:
                                                            AnimType.SCALE,
                                                        dialogType:
                                                            DialogType.SUCCES,
                                                        body: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                            child: Text(
                                                              'Session Created, Wait for it to get accepted 🕜',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: GoogleFonts.sen(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .buttonColor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ),
                                                        btnOkOnPress: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ).show(),
                                                    }
                                                  else
                                                    {
                                                      AwesomeDialog(
                                                        context: context,
                                                        animType:
                                                            AnimType.SCALE,
                                                        dialogType:
                                                            DialogType.ERROR,
                                                        body: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Center(
                                                            child: Text(
                                                              value +
                                                                  ' Please try again Later',
                                                              style: GoogleFonts.sen(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .buttonColor,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          ),
                                                        ),
                                                        btnOkOnPress: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      ).show(),
                                                    }
                                                });
                                        //Navigator.of(context).pop();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Please fill up all the fields");
                                      }
                                    }),
                              ],
                            ),
                            Text("Requesting",
                                style: GoogleFonts.sen(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context).buttonColor)),
                            widget.tutor.profileImag == ""
                                ? Container(
                                    width: ScreenSize.width * 0.20,
                                    height: ScreenSize.height * 0.12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.account_circle_sharp,
                                        size: ScreenSize.height * 0.10,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: ScreenSize.width * 0.20,
                                    height: ScreenSize.height * 0.12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              widget.tutor.profileImag),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                            Text(
                              widget.tutor.name,
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).buttonColor)),
                            ),
                            SizedBox(
                              height: ScreenSize.height * 0.01,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Session Title",
                                      style: GoogleFonts.sen(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .buttonColor)),
                                    ),
                                  ),
                                  TextField(
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Help with... ',
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
                                      "Problem Description",
                                      style: GoogleFonts.sen(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .buttonColor)),
                                    ),
                                  ),
                                  TextField(
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                    controller: problemController,
                                    decoration: InputDecoration(
                                      hintText: 'i cant understand ...',
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
                                      "Preferred Date",
                                      style: GoogleFonts.sen(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .buttonColor)),
                                    ),
                                  ),
                                  TextField(
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                    readOnly: true,
                                    controller: dateController,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        child: Icon(
                                          Icons.date_range,
                                          color: Theme.of(context).buttonColor,
                                        ),
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                      _preffredDate == null
                                                          ? DateTime.now()
                                                          : _preffredDate,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2022))
                                              .then((value) => {
                                                    if (value == null)
                                                      {}
                                                    else
                                                      {
                                                        dateController
                                                            .text = value.year
                                                                .toString() +
                                                            "-" +
                                                            value.month
                                                                .toString() +
                                                            "-" +
                                                            value.day.toString()
                                                      }
                                                  });
                                        },
                                      ),
                                      hintText: '2021-12-12...',
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
                                      "Preferred Time",
                                      style: GoogleFonts.sen(
                                          textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .buttonColor)),
                                    ),
                                  ),
                                  TextField(
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                    controller: timeController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            TimeOfDay _PreferredTime =
                                                TimeOfDay.now();
                                            TimeOfDay _selectedTimeConvFormat;
                                            String dayOrNight = "";
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                              builder: (BuildContext context,
                                                  Widget child) {
                                                return Theme(
                                                  data: Theme.of(context),
                                                  child: child,
                                                );
                                              },
                                            ).then((value) => {
                                                  if (value != null)
                                                    {
                                                      _PreferredTime = value,
                                                      _selectedTimeConvFormat =
                                                          _PreferredTime.replacing(
                                                              hour: _PreferredTime
                                                                  .hourOfPeriod),
                                                      dayOrNight =
                                                          _PreferredTime
                                                                      .period ==
                                                                  DayPeriod.am
                                                              ? "AM"
                                                              : "PM",
                                                      print(
                                                          _selectedTimeConvFormat
                                                                      .hour ==
                                                                  0 &&
                                                              _PreferredTime
                                                                      .period ==
                                                                  DayPeriod.pm),
                                                      if (_selectedTimeConvFormat
                                                                  .hour ==
                                                              0 &&
                                                          _PreferredTime
                                                                  .period ==
                                                              DayPeriod.pm)
                                                        {
                                                          // unique case where the system view 12pm as 0 so we will set it manually
                                                          timeController.text = "12" +
                                                              ":" +
                                                              _selectedTimeConvFormat
                                                                  .minute
                                                                  .toString() +
                                                              " " +
                                                              dayOrNight,
                                                        }
                                                      else
                                                        {
                                                          timeController
                                                              .text = _selectedTimeConvFormat
                                                                  .hour
                                                                  .toString() +
                                                              ":" +
                                                              _selectedTimeConvFormat
                                                                  .minute
                                                                  .toString() +
                                                              " " +
                                                              dayOrNight,
                                                        }
                                                    }
                                                });
                                          },
                                          child: Icon(
                                            Icons.access_time,
                                            color:
                                                Theme.of(context).buttonColor,
                                          )),
                                      hintText: '12:01 pm...',
                                      hintStyle: TextStyle(
                                          fontSize: 17.0, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenSize.height * 0.02,
                                  ),
                                  Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Preferred Subject",
                                          style: GoogleFonts.sen(
                                              textStyle: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .buttonColor)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: ScreenSize.height * 0.01,
                                      ),
                                      TextField(
                                        onChanged: (value) {
                                          setModalState(() {
                                            searchBox = value;
                                            getSubjects(searchBox);
                                            // getSelectedSubjects(selectedInterests);
                                          });
                                        },
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.6),
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                          prefixIcon: Icon(Icons.search,
                                              color: Theme.of(context)
                                                  .accentColor),
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
                                        height: ScreenSize.height * 0.020,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                        ),
                                        height: ScreenSize.height * 0.065,
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
                ));
          });
        });
  }

  int getChosenSubject() {
    for (int i = 0; i < subjects.length; i++) {
      if (subjects[i].chosen) {
        return i;
      }
    }

    return -1;
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
