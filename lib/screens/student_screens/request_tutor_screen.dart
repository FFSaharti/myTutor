import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/screens/student_screens/view_tutor_profile_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';

class RequestTutorScreen extends StatefulWidget {
  static String id = 'request_tutor_screen';

  @override
  _RequestTutorScreenState createState() => _RequestTutorScreenState();
}

class _RequestTutorScreenState extends State<RequestTutorScreen> {
  List<Tutor> Tutors = [];
  List<Rate> rates = [];
  List<MyUser> searchedTutors = [];
  TextEditingController searchController = TextEditingController();

  _filterTutors(String name) {
    setState(() {
      searchedTutors = Tutors.where(
              (Tutor) => Tutor.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    });
  }

  getTutorsFromApi() async {
    var response = await DatabaseAPI.getTutors();
    return response;
  }

  fetchRates() {}

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
              List.from(tutor.data()['experiences']),
              // List.from(tutor.data()["experiences"]),
              tutor.data()["profileImg"]);
          Tutors.add(temp);
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int fromDurationAnimationConter = 0;
    int toDurationAnimationConter = 400;
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset : false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //TODO: Implement filter options for searching for tutor
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
                  onTap: () {},
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
                            from: Duration(milliseconds: fromDurationAnimationConter),
                            to: Duration(milliseconds: toDurationAnimationConter),
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
    );
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
                      builder: (context) => ViewTutorProfileScreen(
                            tutor: widget.tutor,
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
              print("SHOW BUTTON");
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
            height: height * 0.60,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              height: height * 0.60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
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
                                      1);
                                  Navigator.of(context).pop();
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
                                "SessionTitle",
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
                                "Preferred Date",
                                style: GoogleFonts.secularOne(
                                    textStyle: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                            ),
                            TextField(
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
                              decoration: InputDecoration(
                                hintText: 'Type something...',
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
