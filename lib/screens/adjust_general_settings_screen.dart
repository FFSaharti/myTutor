import 'package:flutter/material.dart';
import 'package:mytutor/components/ez_button.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/theme_provider.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class AdjustGeneralSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).bottomAppBarColor,
        title: Center(
          child: Text(
            "Adjust Settings",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
        body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: ScreenSize.height * 0.05,
            ),
            Row(
              children: [
                Text(
                  "Dark mode",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 30),
                ),
                Spacer(),
                Switch.adaptive(value: themeProvider.isDark, onChanged: (value){
                  themeProvider.changeMode(value);
                        }),
              ],
            ),
            SizedBox(
              height: ScreenSize.height * 0.05,
            ),
            EZButton(width: ScreenSize.width*0.40, buttonColor: kColorScheme[1], textColor: Theme.of(context).primaryColor, isGradient: false, colors: null, buttonText: "Log out", hasBorder: false, borderColor: null, onPressed: (){
              DatabaseAPI.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
            })
          ],
        ),
      ),
    ));
  }
}



