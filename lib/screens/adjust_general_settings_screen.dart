import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/screens/welcome_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/theme_provider.dart';
import 'package:provider/provider.dart';

class AdjustGeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: buildAppBar(context, kColorScheme[3], "Adjust Settings", true),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              children: [
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    from: Duration(milliseconds: 0),
                    to: Duration(milliseconds: 500),
                  ),
                  child: Card(
                    elevation: 0.5,
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text("Dark Mode",
                              style: GoogleFonts.sen(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 20)),
                          Spacer(),
                          Switch.adaptive(
                              value: themeProvider.isDark,
                              onChanged: (value) {
                                themeProvider.changeMode(value);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    from: Duration(milliseconds: 0),
                    to: Duration(milliseconds: 500),
                  ),
                  child: Card(
                    elevation: 0.5,
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text("About Us",
                              style: GoogleFonts.sen(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 20)),
                          Spacer(),
                          IconButton(
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Theme.of(context).buttonColor,
                              ),
                              onPressed: () {
                                showAboutUs(context);
                              })
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.42,
                ),
                Opacity(
                  opacity: 0.90,
                  child: GestureDetector(
                    onTap: () {
                      DatabaseAPI.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  WelcomeScreen()));
                    },
                    child: Card(
                      elevation: 2.5,
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            Text("Log Out",
                                style: GoogleFonts.sen(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 20)),
                            Spacer(),
                            IconButton(
                                icon: Icon(
                                  Icons.logout,
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                                onPressed: () {
                                  DatabaseAPI.signOut();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              WelcomeScreen()));
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void showAboutUs(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        enableDrag: true,
        isScrollControlled: true,
        context: ScreenSize.context,
        builder: (context) {
          return Container(
            height: ScreenSize.height * 0.5,
            child: Column(
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.01,
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 45,
                  color: Theme.of(context).accentColor,
                ),
                SizedBox(
                  height: ScreenSize.height * 0.04,
                ),
                Text(
                  "myTutor",
                  style: GoogleFonts.sen(
                      color: Theme.of(context).accentColor, fontSize: 35),
                ),
                Text(
                  "Developed By: ",
                  style: GoogleFonts.sen(
                      color: Theme.of(context).accentColor, fontSize: 20),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.05,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Text(
                      "Faisal Faiz Saharti",
                      style: GoogleFonts.sen(
                          color: Theme.of(context).accentColor, fontSize: 20),
                    )),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        child: Text(
                      "Abdulrhman Masoud Al-Ahmadi",
                      style: GoogleFonts.sen(
                          color: Theme.of(context).accentColor, fontSize: 20),
                    )),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
