import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/subject.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';

class CreateMaterialsScreen extends StatefulWidget {
  static String id = "create_materials_screen";

  @override
  _CreateMaterialsScreenState createState() => _CreateMaterialsScreenState();
}

class _CreateMaterialsScreenState extends State<CreateMaterialsScreen> {
  PageController _pageController = PageController();
  int type  = 1;
  File _file = null;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  int _dropDownMenuController = 1;
  bool _userChoose;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      type = 1;
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: Container(
                  width:ScreenSize.width *0.43,
                  height: 50.0,
                  child: Container(
                    child: Center(child: Text("Document/slides" , style: TextStyle(color: type == 1 ? Colors.white : kGreyish),)),
                    decoration: new BoxDecoration(
                      color: type == 1 ? kColorScheme[0] : Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        border: Border.all(color: kColorScheme[1])
                    ),
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(width: 5.0, color: Colors.white),
                  ),
          ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      type = 2;
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: Container(
                    width:ScreenSize.width *0.43,
                    height: 50.0,
                    child: Container(
                      child: Center(child: Text("Quiz" , style: TextStyle(color: type == 2 ? Colors.white : kGreyish),)),
                      decoration: new BoxDecoration(
                          color: type == 2 ? kColorScheme[0] : Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          border: Border.all(color: kColorScheme[1])
                      ),

                    ),
                    decoration: new BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(width: 5.0, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: ScreenSize.height * 0.020,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Title",
                              style: kTitleStyle.copyWith(
                                  color: Colors.black, fontSize: 20),
                            )),
                        SizedBox(
                          height: ScreenSize.height * 0.0090,
                        ),
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Type Something here....',
                          ),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.030,
                        ),
                        Text(
                          "Description",
                          style:
                          kTitleStyle.copyWith(color: Colors.black, fontSize: 20),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.019,
                        ),
                        Container(
                          height: ScreenSize.height * 0.30,
                          width: ScreenSize.width,
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _descController,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Type something here...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.035,
                        ),
                        Row(
                          children: [
                            Text(
                              "Subject",
                              style: kTitleStyle.copyWith(
                                  color: Colors.black, fontSize: 17),
                            ),
                            Spacer(),
                            DropdownButton(
                              value: _dropDownMenuController,
                              items: fetchSubjcets(),
                              onChanged: (value) {
                                setState(() {
                                  _userChoose = true;
                                  _dropDownMenuController = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              "File",
                              style: kTitleStyle.copyWith(
                                  color: Colors.black, fontSize: 17),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: (){
                                  getFilesFromLocalStorage();
                                },
                                child: Container(
                                  child: Icon(Icons.add_circle_outline),
                                ),
                              ),
                            ),

                          ],
                        ),
                        Spacer(),
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              createMaterials();
                            },
                            child: Text(
                              "Create",
                              style: GoogleFonts.sarabun(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                            ),
                            color: kColorScheme[2],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(child: Text("Quiz_uplode (faisel)_", style: TextStyle(fontSize: 30),)),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> fetchSubjcets() {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < subjects.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(subjects.elementAt(i).title),
        value: i,
      ));
    }

    return items;
  }
  getFilesFromLocalStorage() async {
    String filename = "hello";
    FilePickerResult file = await FilePicker.platform.pickFiles(type: FileType.any);
    file == null ? null : _file = File(file.files.single.path);
  //  String fileLastname = '$filename+.pdf';
  }

  void createMaterials(){
    if(_descController.text.isNotEmpty && _titleController.text.isNotEmpty && _file !=null){
      DatabaseAPI.uplodeFileToStorage(Document(_titleController.text, 1, null, subjects.elementAt(_dropDownMenuController), SessionManager.loggedInTutor.userId, _file, _descController.text)).then((value) => {
        value == "done" ? AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.SUCCES,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(
              'file uploaded',
              style: kTitleStyle.copyWith(color: kBlackish,fontSize: 14,fontWeight: FontWeight.normal),
            ),),
          ),
          btnOkOnPress: () {
            int count = 0;
            Navigator.popUntil(context, (route) {
              return count++ == 1;
            });
          },
        ).show() : AwesomeDialog(
          context: context,
          animType: AnimType.SCALE,
          dialogType: DialogType.ERROR,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('ERROR ',
              style: kTitleStyle.copyWith(color: kBlackish,fontSize: 14,fontWeight: FontWeight.normal),
            ),),
          ),
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        ).show(),


      });
    }
  }
}

