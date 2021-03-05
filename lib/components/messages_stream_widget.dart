import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:intl/intl.dart';

import 'message_Shape_widget.dart';

class MessagesStream extends StatelessWidget {
  final String sessionid;
  final bool imageOnly;

  const MessagesStream({this.sessionid,this.imageOnly});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: imageOnly ?  DatabaseAPI.fetchSessionImagesOnly(sessionid): DatabaseAPI.fetchSessionMessages(sessionid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("");
        }
        final messages = snapshot.data.docs;

        // messages list has all the messageshape widget.
        List<MessageShape> Messages = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          String imageurl = "";
          messageText == "image"
              ? imageurl = message.data()['imageUrl']
              : imageurl = null;
          final messageSender = message.data()['sender'];
          final Timestamp timestamp = message.data()['time'] as Timestamp;
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
          // time
          final currentUser = SessionManager.loggedInUser.name;
          final messageShape = MessageShape(
            time: time,
            sender: messageSender,
            text: messageText,
            SameUser: currentUser == messageSender,
            imageUrl: imageurl,
          );

          Messages.add(messageShape);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: Messages,
          ),
        );
      },
    );
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}