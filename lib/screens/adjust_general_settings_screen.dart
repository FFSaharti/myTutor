import 'package:flutter/material.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/theme_provider.dart';
import 'package:provider/provider.dart';

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
            )
          ],
        ),
      ),
    ));
  }
}



