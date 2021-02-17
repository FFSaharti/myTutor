import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/classes/session.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/session_manager.dart';

class messagesScreen extends StatefulWidget {
  final Session currentsession;

  const messagesScreen({this.currentsession});
  @override
  _messagesScreenState createState() => _messagesScreenState();
}

class _messagesScreenState extends State<messagesScreen> {
  final messageTextController = TextEditingController();
  String newMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        elevation: 0,
        backgroundColor: Color(0x44000000),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              sessionid: widget.currentsession.session_id,
            ),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      readOnly: widget.currentsession.status == "expired" ? true : false,
                      controller: messageTextController,
                      onChanged: (value) {
                        newMessage = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        hintText: widget.currentsession.status == "expired" ? 'the session is ended. its in view Mode only':'Type....',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  FlatButton(

                    onPressed: widget.currentsession.status == "expired" ? null : () {
                      messageTextController.clear();
                      DatabaseAPI.saveNewMessage(
                          widget.currentsession.session_id,
                          newMessage,
                          SessionManager.loggedInUser.name);
                    },

                    child: Row(
                      children: [
                        Text("send"),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_forward_rounded ,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  final String sessionid;

  const MessagesStream({this.sessionid});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseAPI.fetchSessionMessages(sessionid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("");
        }
        final messages = snapshot.data.docs;

        // messages list has all the messageshape widget.
        List<MessageShape> Messages = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
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

class MessageShape extends StatelessWidget {
  MessageShape({this.sender, this.text, this.SameUser, this.time});
  final String sender;
  final String time;
  final String text;
  final bool SameUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            SameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment:
                SameUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Material(
                //TODO: Fix messages shape.
                borderRadius: SameUser
                    ? BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(0.0))
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                elevation: 3.0,
                color: SameUser ? kColorScheme[1] : Colors.white,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: SameUser ? Colors.white : Colors.black54,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            time,
            style: TextStyle(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
