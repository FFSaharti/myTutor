import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/components/circular_button.dart';
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
                // SizedBox(
                //   height: ScreenSize.height * 0.05,
                // ),
                Villain(
                  villainAnimation: VillainAnimation.fromBottom(
                    from: Duration(milliseconds: 0),
                    to: Duration(milliseconds: 500),
                  ),
                  child: Card(
                    elevation: 2.5,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text("Dark mode",
                              style: GoogleFonts.sen(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20)
                              // TextStyle(
                              //     color: Theme.of(context).primaryColor,
                              //     fontSize: 30),
                              ),
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
                SizedBox(
                  height: ScreenSize.height * 0.59,
                ),
                CircularButton(
                    width: ScreenSize.width * 0.40,
                    buttonColor: kColorScheme[1],
                    textColor: Theme.of(context).primaryColor,
                    isGradient: false,
                    colors: null,
                    buttonText: "Log out",
                    hasBorder: false,
                    borderColor: null,
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
        ));
  }
}
