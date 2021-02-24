import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/material.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

class MaterialWidget extends StatefulWidget {
  final MyMaterial material;
  final String matID;

  const MaterialWidget({this.material, this.matID});

  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends State<MaterialWidget> {
  bool finish = false;

  @override
  Widget build(BuildContext context) {
    print(widget.material.subjectID);

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: ScreenSize.height * 0.165,
        decoration: BoxDecoration(
          color: kWhiteish,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 15,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                subjects[widget.material.subjectID].path,
                width: 50,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ScreenSize.height * 0.05,
                    child: Container(
                      width: ScreenSize.width * 0.56,
                      child: Text(
                        "hello",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: ScreenSize.height * 0.027,
                    child: Text(
                      widget.material.desc,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style:
                          GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (widget.material.type == 1)
                      ? Text((widget.material as Document).fileType)
                      : Text("Quiz"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
