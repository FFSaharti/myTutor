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

    // student(request)option
    final requestButton = find.byValueKey("request_button");
    final requestScreenSearchBar = find.byValueKey("request_search_bar");
    final tutorWidget = find.byValueKey("tutor_widget");
    final requestTutorButton = find.byValueKey("request_tutor_button");

    // session creation fields

    final sessionTitle = find.byValueKey("session_title");
    final sessionDesc = find.byValueKey("session_description");
    final sessionDatePicker = find.byValueKey("date_picker");
    final sessionTimePicker = find.byValueKey("time_picker");
    final pressOk = find.text('OK');
    final sessionSubject = find.byValueKey("session_subject_field");
    final sessionInterestedSubject = find.byValueKey("interest_widget");
    final createSession = find.byValueKey("insert_session");

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
      //enter new message
      await driver.tap(bottomNavyBar);
      await driver.tap(studentBottomBar);
      await driver.tap(requestButton);
      await driver.tap(requestScreenSearchBar);
      await driver.enterText("FaisalTutor");
      await driver.tap(requestTutorButton);
      await driver.tap(sessionTitle);
      await driver.enterText("cpit-405");
      await driver.tap(sessionDesc);
      await driver.enterText("i need help with html");
      await driver.waitFor(sessionDatePicker);
      await driver.tap(sessionDatePicker);
      await driver.tap(find.text('OK'));
      await driver.waitFor(sessionDatePicker);
      await driver.tap(sessionTimePicker);
       await driver.tap(find.text('OK'));
      await driver.tap(sessionSubject);
      await driver.enterText("html");
      // wait for subjcet to load.
      sleep(Duration(seconds: 3));
      await driver.tap(sessionInterestedSubject);
      await driver.tap(createSession);
      sleep(Duration(seconds: 10));
    },
        timeout: Timeout(
        Duration(minutes: 2),
    ),
    );
  });
}
