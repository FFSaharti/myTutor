import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Create session test', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) driver.close();
    });
    //login screen
      final weclomeScreenButton = find.byValueKey('sign_in');
      final loginFeild = find.byValueKey('login_field');
      final passwordField = find.byValueKey('password_field');
      final signInButton = find.byValueKey('sign_in_button');
      //student bottom bar buttons
      final bottomNavyBar = find.byValueKey("tutor_bottom_bar");
      final tutorProfileBottomBar = find.byValueKey("tutor_profile_bottom_bar");
      final tutorSettingsBottomBar = find.byValueKey("tutor_settings_bottom_bar");
      // inside tutor profile
      final editIcon = find.byValueKey("edit_aboutMe_tutor");
      final insertNewAboutMe = find.byValueKey("insert_new_aboutMe");
      final aboutMeTextField = find.byValueKey("aboutMe_textField");
      final logOutButton = find.byValueKey("log_out");
    test('edit tutor about me test', () async {
      sleep(Duration(seconds: 3));
      // navigate to log  in screen from welcome screen and fill up the log in information.
      await driver.tap(weclomeScreenButton);
      await driver.tap(loginFeild);
      await driver.enterText("faisal.saharty@gmail.com");
      await driver.tap(passwordField);
      await driver.enterText("123456789");
      await driver.tap(signInButton);
      await driver.tap(bottomNavyBar);
      await driver.tap(tutorProfileBottomBar);
      await driver.tap(editIcon);
      await driver.tap(aboutMeTextField);
      await driver.enterText("hello my name is faisal saharty");
      await driver.tap(insertNewAboutMe);
      await driver.tap(tutorSettingsBottomBar);
      await driver.tap(logOutButton);

      sleep(Duration(seconds: 3));
      // wait for session data  to load.
      sleep(Duration(seconds: 3));
      // click on the first  session and navigate to chat screen.
      //enter new message
    },
        timeout: Timeout(
        Duration(minutes: 2),
    ),
    );
  });
}
