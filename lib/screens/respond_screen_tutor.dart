import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/utilities/constants.dart';

class RespondScreenTutor extends StatelessWidget {
  static String id = 'respond_screen_tutor';
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
  width = mediaQueryData.size.width;
    height = mediaQueryData.size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white70,
        title: Center(
          child: Text(
            "Respond",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: height*0.010,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           messagesScreen(
                  //             currentsession: widget.session,
                  //           ),
                  //     ));
                },
                child: Container(
                  height: height * 0.17,
                  decoration: new BoxDecoration(
                    color: Color(0xFFefefef),
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.circular(11.0),
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
                                "Array problem",
                                style: GoogleFonts.sarabun(
                                  textStyle: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                color: kColorScheme[2],
                                borderRadius: new BorderRadius.circular(50.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                                child: Text(
                                  "2021-1-15 at 4 pm",
                                  style: GoogleFonts.sarabun(
                                    textStyle: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                              child: Text(
                                //TODO: adjuest the over flow problem with long names
                                "abdulrhman masoud ",
                                overflow: TextOverflow.ellipsis,
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
              ),
            ),

          ],
        ),
      ),
    );
  }
}
