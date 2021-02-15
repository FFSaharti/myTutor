import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/user.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';

class RequestTutorScreen extends StatefulWidget {
  static String id = 'request_tutor_screen';

  @override
  _RequestTutorScreenState createState() => _RequestTutorScreenState();
}

class _RequestTutorScreenState extends State<RequestTutorScreen> {
  List<MyUser> Tutors = [];
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

  void initState() {
    getTutorsFromApi().then((data) {
      setState(() {
        for (var tutor in data.docs) {
          Tutors.add(MyUser(tutor.data()["name"], tutor.data()["email"],
              tutor.data()["pass"], "_aboutMe", tutor.id));
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                Container(
                    height: 40,
                    width: 200,
                    decoration: BoxDecoration(
                        color: kColorScheme[1],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Center(
                      child: new Text(
                        "Filter options",
                        style: TextStyle(color: Colors.white, fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                    )),
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
                        return TutorWidget(
                            Tutor: searchedTutors.elementAt(index));
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
  final MyUser Tutor;

  const TutorWidget({Key key, this.Tutor}) : super(key: key);

  @override
  _TutorWidgetState createState() => _TutorWidgetState();
}

class _TutorWidgetState extends State<TutorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white12,
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.Tutor.name,
            style: GoogleFonts.sarabun(
                textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueGrey)),
          ),
          GestureDetector(
            onTap: () {
              showbutton(widget.Tutor);
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
            // borderRadius: BorderRadius.vertical(top: Radius.circular(2.0))
            ),
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: height * 0.60,
            child: Scaffold(
              body: Container(
                //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                height: height * 0.60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(80),
                      topLeft: Radius.circular(45),
                    ),
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
                                        timeController.text);
                                  }
                                }),
                          ],
                        ),
                        Text("Requesting",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.normal,
                                color: Colors.black)),
                        Text(
                          widget.Tutor.name,
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
            ),
          );
        });
  }
}
