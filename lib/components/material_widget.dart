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
      padding: const EdgeInsets.all(7.0),
      child: Container(
        height: ScreenSize.height * 0.14,
        decoration: BoxDecoration(
          color: kWhiteish,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.18),
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
                width: ScreenSize.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: ScreenSize.height * 0.005,
                  ),
                  Container(
                    height: ScreenSize.height * 0.03,
                    child: Container(
                      width: ScreenSize.width * 0.50,
                      child: Text(
                        widget.material.title,
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
                    height: ScreenSize.height * 0.03,
                    child: Text(
                      widget.material.desc,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style:
                          GoogleFonts.sarala(fontSize: 14, color: kGreyerish),
                    ),
                  ),
                  Container(
                    decoration: new BoxDecoration(
                      color: kColorScheme[1],
                      borderRadius: new BorderRadius.circular(50.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 11.0, right: 11.0),
                      child: Text(
                        (widget.material.type == 1)
                            ? (widget.material as Document).fileType
                            : "Quiz",
                        style: GoogleFonts.sarabun(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
