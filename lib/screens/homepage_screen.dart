import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomepageScreen extends StatefulWidget {
  static String id = 'homepage_screen';

  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
   List<Widget> widgets = <Widget>[
     HomePage(),
    Text("2"),
  ];
  double width;
  double height;
  int _navindex = 0;

  void changeindex(int index){
    setState(() {
      _navindex = index;
      print(_navindex);
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.chalkboardTeacher), label: "student"),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: "messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "profile"),
        ],
        currentIndex: _navindex,
        onTap: changeindex,
        selectedItemColor: kColorScheme[3],
      ),
      body: widgets.elementAt(_navindex),
    );
  }
}

class HomePage extends StatelessWidget {

  double height;
  double width;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "welcome,\nTutor ",
                    style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.normal,
                            color: Colors.black)),
                  ),
                  TextSpan(
                    text: "Faisal",
                    style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "    Upcoming Sessions",
              style: GoogleFonts.sarabun(
                  textStyle: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.normal,
                      color: kGreyish)),
            ),
          ),
          SizedBox(
            height: height * 0.003,
          ),
          SessionWidget(height: height),
        ],
      ),
    );
  }
}

class SessionWidget extends StatelessWidget {
  const SessionWidget({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: height * 0.17,
        decoration: new BoxDecoration(
          color: Color(0xFFefefef),
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(11.0),
          // boxShadow: <BoxShadow>[
          //   new BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 10.0,
          //     offset: new Offset(0.0, 10.0),
          //   ),
          // ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/Sub-Icons/Java.png",
              height: 60,
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                    child: Text(
                      "Array in java",
                      style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: kColorScheme[2],
                      borderRadius: new BorderRadius.circular(50.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                      child: Text(
                        "Tomorrow at 4:50pm",
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                    child: Text(
                      "abdulrhman alahmadi",
                      style: GoogleFonts.sarabun(
                        textStyle: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
