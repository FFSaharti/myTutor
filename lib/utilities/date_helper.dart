import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class DateHelper{


  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  static String calTime(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    String time;
    int num = calculateDifference(dateTime);

    var dateUtc = dateTime.toUtc();
    var strToDateTime = DateTime.parse(dateUtc.toString());
    final convertLocal = strToDateTime.toLocal();
    if (num == 0) {
      var newFormat = DateFormat("hh:mm");
      time = newFormat.format(convertLocal);
    } else {
      var newFormat = DateFormat("yy-MM");
      time = newFormat.format(convertLocal);
    }
    return time;
  }

}