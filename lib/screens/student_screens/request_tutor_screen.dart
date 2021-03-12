import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/screens/student_screens/view_tutor_profile_screen.dart';
import 'package:mytutor/screens/view_receiver_profile.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

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
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          appBar: buildAppBar(context, kColorScheme[3], "Request Tutor"),
          //resizeToAvoidBottomInset : false,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      VillainController.playAllVillains(context);
                      setState(() {
                        _filterTutors(value);
                        if (searchController.text.isEmpty) {
                          searchedTutors = [];
                        }
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
                    height: 25,
                  ),
                  Text(
                    "Or",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showFilterOptions();
                    },
                    child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            color: kColorScheme[1],
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: new Center(
                          child: new Text(
                            "Filter options",
                            style: TextStyle(color: Colors.white, fontSize: 23),
                            textAlign: TextAlign.center,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  searchedTutors.length > 0
                      ? Text(
                          "Showing " +
                              searchedTutors.length.toString() +
                              " Results",
                          style: TextStyle(fontSize: 18))
                      : Text(""),
                  Expanded(
                    child: NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.80,
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
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
                  // SizedBox(height: 150,),
                  //Temp solution
                ],
              ),
            ),
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
                            "Filters Options",
                            style: kTitleStyle.copyWith(
                                color: Theme.of(context).primaryColor,
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
                        "filter based on",
                        style: GoogleFonts.openSans(
                            fontSize: 17,
                            color: Theme.of(context).primaryColor,
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
                            " on experience ",
                            style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: ScreenSize.width * 0.040,
                          ),
                          Expanded(
                            child: DropdownButton(
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
                            "average rating above ",
                            style: GoogleFonts.openSans(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            width: ScreenSize.width * 0.040,
                          ),
                          Expanded(
                            child: DropdownButton(
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
                                  child: Center(child: Text(value.toString())),
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
            style: GoogleFonts.openSans(color: Colors.black),
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
        Rate.getAverageRate(tutor.rates) > _dropDownMenuControllerForRating
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white12,
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewReceiverProfile(
                            userId: widget.tutor.userId,
                            role: 'tutor',
                          )),
                );
              },
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
            style: GoogleFonts.sarabun(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueGrey)),
          ),
          GestureDetector(
            onTap: () {
              showbutton(widget.tutor);
            },
            child: Container(
                height: 30,
                width: 120,
                decoration: BoxDecoration(
                    color: kColorScheme[1],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: new Center(
                  child: new Text(
                    "Request",
                    style: TextStyle(color: Colors.white, fontSize: 23),
                    textAlign: TextAlign.center,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void showbutton(MyUser tutor) {
    String _preffredDate;
    String _date;

    TextEditingController timeController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    TextEditingController problemController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double width = mediaQueryData.size.width;
    double height = mediaQueryData.size.height;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: height * 0.85,
            child: Container(

              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: height * 0.60,
              decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(10), color: Theme.of(context).scaffoldBackgroundColor),
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
                            "Session details",
                            style: TextStyle(fontSize: 20),
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
                                      1).then((value) => {
                                        if(value == "success"){
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.SCALE,
                                            dialogType: DialogType.SUCCES,
                                            body: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  'the session has been created. you should wait now till you hear back from the tutor 🕜',
                                                  style: kTitleStyle.copyWith(
                                                      color: kBlackish,
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            btnOkOnPress: () {
                                              Navigator.pop(context);
                                            },
                                          ).show(),
                                        } else{
                                          AwesomeDialog(
                                            context: context,
                                            animType: AnimType.SCALE,
                                            dialogType: DialogType.ERROR,
                                            body: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  value+' Please try again Later',
                                                  style: kTitleStyle.copyWith(
                                                      color: kBlackish,
                                                      fontSize: 14,
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            btnOkOnPress: () {
                                              Navigator.pop(context);
                                            },
                                          ).show(),
                                        }
                                  });
                                  //Navigator.of(context).pop();
                                } else{
                                  Fluttertoast.showToast(msg: "Please fill up all the fields");
                                }
                              }),
                        ],
                      ),
                      Text("Requesting",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.normal,
                              color: Colors.black)),
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
                                    image:
                                        NetworkImage(widget.tutor.profileImag),
                                    fit: BoxFit.fill),
                              ),
                            ),
                      Text(
                        widget.tutor.name,
                        style: GoogleFonts.sarabun(
                            textStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey)),
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
                                "Session Title",
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
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
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
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
                              readOnly: true,
                              controller: dateController,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  child: Icon(Icons.date_range),
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: _preffredDate == null
                                                ? DateTime.now()
                                                : _preffredDate,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2022))
                                        .then((value) => dateController.text =
                                            value.year.toString() +
                                                "-" +
                                                value.month.toString() +
                                                "-" +
                                                value.day.toString());
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
                                "Preferred Time, am/pm",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
                              controller: timeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      TimeOfDay _PreferredTime = TimeOfDay.now();
                                      TimeOfDay _selectedTimeConvFormat;
                                      String dayOrNight= "";
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
                                                _selectedTimeConvFormat = _PreferredTime.replacing(hour: _PreferredTime.hourOfPeriod),
                                                dayOrNight = _PreferredTime.period == DayPeriod.am ? "AM" : "PM",
                                                print(_selectedTimeConvFormat.hour == 0 && _PreferredTime.period == DayPeriod.pm),
                                                if(_selectedTimeConvFormat.hour == 0 && _PreferredTime.period == DayPeriod.pm){
                                                  // unique case where the system view 12pm as 0 so we will set it manually
                                                  timeController.text = "12"+ ":" + _selectedTimeConvFormat.minute.toString()+" "+dayOrNight,
                                                } else{
                                                  timeController.text = _selectedTimeConvFormat.hour.toString() + ":" + _selectedTimeConvFormat.minute.toString()+" "+dayOrNight,

                                                }

                                              }
                                          });
                                    },
                                    child: Icon(Icons.access_time)),
                                hintText: '12:01 pm...',
                                hintStyle: TextStyle(
                                    fontSize: 17.0, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
