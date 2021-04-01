// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytutor/classes/tutor.dart';
import 'package:mytutor/main.dart';
import 'package:mytutor/utilities/regEx.dart';

void main() {
  testWidgets('filter tutor test', (WidgetTester tester) async {

List<Tutor> tutors = [];
tutors.add(Tutor("faisal saharty", "faisal.saharty@gmail.com", "pass", "im a tutor", "1001", [], ""));
tutors.add(Tutor("abdulrhman alahmadi", "abdulrhman@gmail.com", "pass", "im abdulrhman and im a tutor", "1002", [], ""));
tutors.add(Tutor("omar", "omar@gmail.com", "pass", "im omar", "1003", [], ""));
tutors.add(Tutor("faisal ahmad", "ahmad@gmail.com", "pass", "im faisal i love java", "1004", [], ""));
tutors.add(Tutor("ali", "ali12@gmail.com", "pass", "i love html", "1005", [], ""));
    // expect the new list length
    expect(searchForTutorByName(tutors,"faisal").length, 2);
  });
}

List<Tutor> searchForTutorByName(List<Tutor> tutors, String name){
  List<Tutor> tempTutors = [];
  tempTutors = tutors
      .where(
          (Tutor) => Tutor.name.toLowerCase().contains(name.toLowerCase()))
      .toList();

  return tempTutors;

}


