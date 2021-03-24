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

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(13.0),
        child: ListTile(
          trailing: Padding(
            padding: const EdgeInsets.fromLTRB(30, 8, 0, 8),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ),
          leading: Image.asset(
            subjects[widget.material.subjectID].path,
            height: 50,
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: ScreenSize.height * 0.03,
                child: Container(
                  // width: ScreenSize.width * 0.45,
                  child: Text(
                    widget.material.title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: GoogleFonts.sen(
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).buttonColor),
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
                  style: GoogleFonts.sen(
                      fontSize: 14,
                      color: Theme.of(context).buttonColor.withOpacity(0.6)),
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
                    style: GoogleFonts.sen(
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
        ),
      ),
    );
  }
}
