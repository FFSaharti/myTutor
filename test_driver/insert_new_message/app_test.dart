import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Todo App', () {
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
    final forgetPass = find.byValueKey('forget_password');
    final loginFeild = find.byValueKey('login_field');
    final passwordField = find.byValueKey('password_field');
    final signInButton = find.byValueKey('sign_in_button');
    final sessionButton = find.byValueKey("sessions");
    final sessionCard = find.byValueKey("first_session");
    final sessionSendButton = find.byValueKey("chat_send_button");
    final sessionChatTextField = find.byValueKey("chat_text_field");
    final navigateBackToHomePage = find.byValueKey("chat_screen_back");
    //student bottom bar buttons
    final bottomNavyBar = find.byValueKey("bottom_bar");
    final studentBottomBar = find.byValueKey("student_bottom_bar");
    final settingsBottomBar = find.byValueKey("settings_bottom_bar");

    final logOutButton = find.byValueKey("log_out");
    test('create account', () async {
      sleep(Duration(seconds: 3));
      // navigate to log  in screen from welcome screen and fill up the log in information.
      await driver.tap(weclomeScreenButton);
      await driver.tap(loginFeild);
      await driver.enterText("abdulrhman05@gmail.com");
      await driver.tap(passwordField);
      await driver.enterText("12345678");
      await driver.tap(signInButton);
      // wait for session data  to load.
      sleep(Duration(seconds: 3));
      // click on the first  session and navigate to chat screen.
      await driver.tap(sessionButton);
      await driver.tap(sessionCard);
      //enter new message
      await driver.tap(sessionChatTextField);
      await driver.enterText("hello this is a integration test");
      await driver.tap(sessionSendButton);
      await driver.tap(navigateBackToHomePage);
      await driver.tap(bottomNavyBar);
      await driver.tap(studentBottomBar);
      await driver.tap(settingsBottomBar);
      await driver.tap(logOutButton);
    });
  });
}
