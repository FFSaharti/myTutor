import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

class MessageShape extends StatefulWidget {
  MessageShape({
    this.sender,
    this.text,
    this.SameUser,
    this.time,
    this.imageUrl,
  });

  final String sender;
  final String time;
  final String text;
  final bool SameUser;
  final String imageUrl;

  @override
  _MessageShapeState createState() => _MessageShapeState();
}

class _MessageShapeState extends State<MessageShape> {
  void _showBiggerImage(String url) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return new Container(
            height: ScreenSize.height * 0.90,
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: FadeInImage(
              placeholder: AssetImage("images/loading.png"),
              image: NetworkImage(
                widget.imageUrl,
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.SameUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // check if the test called image then display the image.
          widget.text == "image"
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _showBiggerImage(widget.imageUrl);
                    },
                    child: FadeInImage(
                      placeholder: AssetImage("images/loading.png"),
                      image: NetworkImage(
                        widget.imageUrl,
                      ),
                      height: 150,
                      width: 150,
                    ),
                  ))
              : Row(
                  mainAxisAlignment: widget.SameUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Material(
                      borderRadius: widget.SameUser
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
                      color: widget.SameUser ? kColorScheme[1] : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          widget.text,
                          style: GoogleFonts.sen(
                            color:
                                widget.SameUser ? Colors.white : Colors.black54,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

          SizedBox(
            height: ScreenSize.height * 0.005,
          ),
          Text(
            widget.time,
            style: GoogleFonts.sen(color: Colors.grey, fontSize: 12),
          )
        ],
      ),
    );
  }
}
