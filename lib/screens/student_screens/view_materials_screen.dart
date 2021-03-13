import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_villains/villains/villains.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/material.dart';
import 'package:mytutor/classes/quiz.dart';
import 'package:mytutor/screens/take_quiz_screen.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:mytutor/utilities/session_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMaterialsScreen extends StatefulWidget {
  static String id = "view_materials_screen";

  @override
  _ViewMaterialsScreenState createState() => _ViewMaterialsScreenState();
}

class _ViewMaterialsScreenState extends State<ViewMaterialsScreen> {
  TextEditingController _searchController = TextEditingController();
  List<MyMaterial> materials = [];
  List<MyMaterial> searchedMaterials = [];
  PDFDocument doc;
  int _dropDownMenuController = 1;
  int _typeDownMenuController = 0;

  void initState() {
    getFetchDocumentsFromApi().then((data) {
      if (data.docs.isNotEmpty) {
        for (var material in data.docs) {
          if (material.data()['type'] == 1) {
            // DOCUMENT TYPE
            Document tempDoc = Document(
                material.data()["documentTitle"],
                material.data()["type"],
                material.data()["documentUrl"],
                subjects.elementAt(material.data()["subject"]),
                material.data()["issuerId"],
                null,
                material.data()["documentDescription"],
                material.data()["fileType"],
                material.id);
            tempDoc.docid = material.id;
            print("tempDoc id is --> " +
                tempDoc.docid +
                " material id is --> " +
                material.id);
            materials.add(tempDoc);
          } else {
            // QUIZ TYPE
            materials.add(Quiz(
                material.data()["issuerId"],
                material.data()['type'],
                material.data()['subject'],
                material.data()['quizTitle'],
                material.data()['quizDesc'],
                material.id));
          }
        }
        print("length is --> " + materials.length.toString());
      }
    });

    super.initState();
  }

  Future<QuerySnapshot> getFetchDocumentsFromApi() async {
    var docs;
    await DatabaseAPI.fetchDocument().then((value) => {docs = value});
    return docs;
  }

  void applyFilters() {
    if (_typeDownMenuController == 0) {
      applySubjectFilter();
    } else {
      applySubjectFilter();
      applyTypeFilter();
    }
  }

  void applySubjectFilter() {
    print(_dropDownMenuController);
    print("Docuemnts length is --> " + materials.length.toString());
    setState(() {
      searchedMaterials = materials
          .where((mat) => mat.subjectID == _dropDownMenuController)
          .toList();
    });
  }

  void applyTypeFilter() {
    print(_dropDownMenuController);
    print("Docuemnts length is --> " + materials.length.toString());
    setState(() {
      searchedMaterials = searchedMaterials
          .where((mat) => mat.type == _typeDownMenuController)
          .toList();
    });
  }

  void searchFilter(String searchValue) {
    setState(() {
      searchedMaterials =
          materials.where((doc) => doc.title.contains(searchValue)).toList();
    });
  }

  readPdf(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return Container(
            height: ScreenSize.height * 0.90,
            child: PDFViewer(
              document: doc,
            ),
          );
        });
  }

  viewFilters() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setModalState /*You can rename this!*/) {
            return Container(
              height: ScreenSize.height * 0.40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Text(
                          "Filter Options",
                          style: kTitleStyle.copyWith(
                              color: Colors.black, fontSize: 17),
                        ),
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              applyFilters();
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(
                            "Subject",
                            style: GoogleFonts.sen(fontSize: 17),
                          ),
                          Spacer(),
                          DropdownButton(
                            value: _dropDownMenuController,
                            items: fetchSubjects(),
                            onChanged: (value) {
                              setState(() {
                                setModalState(() {
                                  _dropDownMenuController = value;
                                  print("subject chosen is --> " +
                                      _dropDownMenuController.toString());
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Text(
                            "Type",
                            style: GoogleFonts.sen(fontSize: 17),
                          ),
                          Spacer(),
                          DropdownButton(
                            value: _typeDownMenuController,
                            items: fetchTypes(),
                            onChanged: (value) {
                              setState(() {
                                setModalState(() {
                                  _typeDownMenuController = value;
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void downloadFile(int index) async {
    try {
      if (await canLaunch(
          (searchedMaterials.elementAt(index) as Document).url)) {
        await launch((searchedMaterials.elementAt(index) as Document).url);
      } else {
        throw 'Could not launch' +
            searchedMaterials.elementAt(index).toString();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            e.toString(),
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
    }
  }

  List<DropdownMenuItem> fetchSubjects() {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < subjects.length; i++) {
      items.add(DropdownMenuItem(
        child: Text(subjects.elementAt(i).title),
        value: i,
      ));
    }
    return items;
  }

  List<DropdownMenuItem> fetchTypes() {
    List<DropdownMenuItem> items = [];
    items.add(
      DropdownMenuItem(
        child: Text("All Types"),
        value: 0,
      ),
    );
    items.add(
      DropdownMenuItem(
        child: Text("File"),
        value: 1,
      ),
    );
    items.add(
      DropdownMenuItem(
        child: Text("Quiz"),
        value: 2,
      ),
    );
    return items;
  }

  @override
  Widget build(BuildContext context) {
    int fromDurationAnimationConter = 0;
    int toDurationAnimationConter = 400;
    for (int i = 0; i < materials.length; i++) {
      print(subjects[materials.elementAt(i).subjectID].path);
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(context, kColorScheme[3], "View Materials"),
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    searchFilter(value);
                    if (_searchController.text.isEmpty) searchedMaterials = [];
                  },
                  style: TextStyle(
                    color: kBlackish,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search, color: kColorScheme[2]),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    viewFilters();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kWhiteish),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.sort,
                        size: 28,
                        color: kColorScheme[2],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenSize.height * 0.015,
              ),
              searchedMaterials.length > 0
                  ? NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                      },
                      child: Column(
                        children: [
                          Text(
                            "Showing " +
                                searchedMaterials.length.toString() +
                                " Results",
                            style: GoogleFonts.sen(fontSize: 15),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.015,
                          ),
                          Container(
                            height: ScreenSize.height * 0.72,
                            child: ListView.builder(
                              itemCount: searchedMaterials.length,
                              itemBuilder: (context, index) {
                                fromDurationAnimationConter += 100;
                                toDurationAnimationConter += 100;
                                return Villain(
                                  villainAnimation: VillainAnimation.fromBottom(
                                    from: Duration(
                                        milliseconds:
                                            fromDurationAnimationConter),
                                    to: Duration(
                                        milliseconds:
                                            toDurationAnimationConter),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(30, 3, 30, 3),
                                    child: Card(
                                      elevation: 0.4,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.white70, width: 1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            3, 18.0, 3, 18),
                                        child: ListTile(
                                          leading: Image.asset(subjects[
                                                  searchedMaterials
                                                      .elementAt(index)
                                                      .subjectID]
                                              .path),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                searchedMaterials
                                                    .elementAt(index)
                                                    .title,
                                                style: GoogleFonts.sen(
                                                    fontSize: 18),
                                              ),
                                              searchedMaterials
                                                          .elementAt(index)
                                                          .type ==
                                                      1
                                                  ? Text(
                                                      (searchedMaterials
                                                                  .elementAt(
                                                                      index)
                                                              as Document)
                                                          .fileType
                                                          .toUpperCase(),
                                                      style: GoogleFonts.sen(
                                                          fontSize: 18,
                                                          color: Colors.grey),
                                                    )
                                                  : Text(
                                                      "QUIZ",
                                                      style: GoogleFonts.sen(
                                                          fontSize: 18,
                                                          color: Colors.grey),
                                                    )
                                            ],
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: GestureDetector(
                                                  child: Icon(
                                                      Icons.arrow_forward_ios),
                                                  onTap: () {
                                                    // open the file reader if the file is pdf, else let the user download the file
                                                    if (searchedMaterials
                                                            .elementAt(index)
                                                            .type ==
                                                        1) {
                                                      (searchedMaterials.elementAt(
                                                                          index)
                                                                      as Document)
                                                                  .fileType ==
                                                              "pdf"
                                                          ? PDFDocument.fromURL(
                                                                  (searchedMaterials
                                                                              .elementAt(index)
                                                                          as Document)
                                                                      .url)
                                                              .then((value) => {
                                                                    doc = value,
                                                                    readPdf(
                                                                        index),
                                                                  })
                                                          : downloadFile(index);
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => TakeQuizScreen(
                                                                searchedMaterials
                                                                    .elementAt(
                                                                        index),
                                                                searchedMaterials
                                                                    .elementAt(
                                                                        index)
                                                                    .docid)),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              Container(
                                                child: GestureDetector(
                                                  child: Icon(Icons.favorite),
                                                  onTap: () {
                                                    // open the file reader if the file is pdf, else let the user download the file
                                                    print("DOC ID IS --> " +
                                                        searchedMaterials
                                                            .elementAt(index)
                                                            .docid);
                                                    if (SessionManager
                                                        .loggedInStudent.favMats
                                                        .contains(
                                                            searchedMaterials
                                                                .elementAt(
                                                                    index)
                                                                .docid)) {
                                                      AwesomeDialog(
                                                        context: context,
                                                        animType:
                                                            AnimType.SCALE,
                                                        dialogType:
                                                            DialogType.ERROR,
                                                        title: "ERROR",
                                                        desc:
                                                            "Material already in favorites",
                                                        btnOkOnPress: () {},
                                                      ).show();
                                                    } else {
                                                      DatabaseAPI.addMaterialToFavorites(
                                                              searchedMaterials
                                                                  .elementAt(
                                                                      index))
                                                          .then((value) => {
                                                                SessionManager
                                                                    .loggedInStudent
                                                                    .favMats
                                                                    .add(searchedMaterials
                                                                        .elementAt(
                                                                            index)
                                                                        .docid),
                                                                value == "done"
                                                                    ? AwesomeDialog(
                                                                        context:
                                                                            context,
                                                                        animType:
                                                                            AnimType.SCALE,
                                                                        dialogType:
                                                                            DialogType.SUCCES,
                                                                        body:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              'material added to favorites',
                                                                              style: kTitleStyle.copyWith(color: kBlackish, fontSize: 14, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        btnOkOnPress:
                                                                            () {
                                                                          int count =
                                                                              0;
                                                                          Navigator.popUntil(
                                                                              context,
                                                                              (route) {
                                                                            return count++ ==
                                                                                1;
                                                                          });
                                                                        },
                                                                      ).show()
                                                                    : AwesomeDialog(
                                                                        context:
                                                                            context,
                                                                        animType:
                                                                            AnimType.SCALE,
                                                                        dialogType:
                                                                            DialogType.ERROR,
                                                                        body:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              'ERROR ',
                                                                              style: kTitleStyle.copyWith(color: kBlackish, fontSize: 14, fontWeight: FontWeight.normal),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        btnOkOnPress:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                      ).show()
                                                              });
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: ScreenSize.height * 0.2,
                        ),
                        Center(
                          child: Text(
                            "No Results :(",
                            style: GoogleFonts.sen(
                                fontSize: 35, color: Colors.grey),
                          ),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
