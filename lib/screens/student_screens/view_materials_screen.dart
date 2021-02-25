import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/classes/document.dart';
import 'package:mytutor/classes/material.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/database_api.dart';
import 'package:mytutor/utilities/screen_size.dart';
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

  void initState() {
    getFetchDocumentsFromApi().then((data) {
      if (data.docs.isNotEmpty) {
        for (var material in data.docs) {
          if (material.data()['type'] == 1) {
            // DOCUMENT TYPE
            Document tempDoc = Document(
                material.data()["title"],
                material.data()["type"],
                material.data()["url"],
                subjects.elementAt(material.data()["subject"]),
                material.data()["issuerId"],
                null,
                material.data()["description"],
                material.data()["fileType"]);
            tempDoc.docid = material.id;
            print("tempDoc id is --> " +
                tempDoc.docid +
                " material id is --> " +
                material.id);
            materials.add(tempDoc);
          } else {
            //TODO: HANDLE QUIZ FETCHES
            // QUIZ TYPE
            // materials.add(Quiz(
            //     material.data()["issuerId"],
            //     material.data()['type'],
            //     material.data()['subject'],
            //     material.data()['quizTitle'],
            //     material.data()['quizDesc']));
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

  void applyFilter() {
    print(_dropDownMenuController);
    print("Docuemnts length is --> " + materials.length.toString());
    setState(() {
      searchedMaterials = materials
          .where(
              (mat) => (mat as Document).subject.id == _dropDownMenuController)
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
                          "choose the subjects",
                          style: kTitleStyle.copyWith(
                              color: Colors.black, fontSize: 17),
                        ),
                        IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              applyFilter();
                              Navigator.pop(context);
                            }),
                      ],
                    ),
                    DropdownButton(
                      value: _dropDownMenuController,
                      items: fetchSubjects(),
                      onChanged: (value) {
                        setState(() {
                          setModalState(() {
                            _dropDownMenuController = value;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void downloadFile(int index) async {
    if (await canLaunch((searchedMaterials.elementAt(index) as Document).url)) {
      await launch((searchedMaterials.elementAt(index) as Document).url);
    } else {
      //TODO: handle error while lunch
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

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < materials.length; i++) {
      print((materials.elementAt(i) as Document).subject.path);
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
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
              SizedBox(
                height: 25,
              ),
              Text(
                "Or",
                style: TextStyle(fontSize: 17),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  viewFilters();
                },
                child: Container(
                    height: ScreenSize.height * 0.055,
                    width: ScreenSize.width * 0.50,
                    decoration: BoxDecoration(
                        color: kColorScheme[1],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: new Center(
                      child: new Text(
                        "Filter options",
                        style: TextStyle(color: Colors.white, fontSize: 23),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ),
              SizedBox(
                height: ScreenSize.height * 0.030,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchedMaterials.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.asset(
                              (searchedMaterials.elementAt(index) as Document)
                                  .subject
                                  .path),
                          title: Text(searchedMaterials.elementAt(index).title),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: GestureDetector(
                                  child: Icon(Icons.visibility),
                                  onTap: () {
                                    // open the file reader if the file is pdf, else let the user download the file
                                    (searchedMaterials.elementAt(index)
                                                    as Document)
                                                .fileType ==
                                            "pdf"
                                        ? PDFDocument.fromURL((searchedMaterials
                                                        .elementAt(index)
                                                    as Document)
                                                .url)
                                            .then((value) => {
                                                  doc = value,
                                                  readPdf(index),
                                                })
                                        : downloadFile(index);
                                  },
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  child: Icon(Icons.favorite),
                                  onTap: () {
                                    // open the file reader if the file is pdf, else let the user download the file
                                    DatabaseAPI.addMaterialToFavorites(
                                            (searchedMaterials.elementAt(index)
                                                as Document))
                                        .then((value) => {
                                              value == "done"
                                                  ? AwesomeDialog(
                                                      context: context,
                                                      animType: AnimType.SCALE,
                                                      dialogType:
                                                          DialogType.SUCCES,
                                                      body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            'doc added to favorites',
                                                            style: kTitleStyle.copyWith(
                                                                color:
                                                                    kBlackish,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                      ),
                                                      btnOkOnPress: () {
                                                        int count = 0;
                                                        Navigator.popUntil(
                                                            context, (route) {
                                                          return count++ == 1;
                                                        });
                                                      },
                                                    ).show()
                                                  : AwesomeDialog(
                                                      context: context,
                                                      animType: AnimType.SCALE,
                                                      dialogType:
                                                          DialogType.ERROR,
                                                      body: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Text(
                                                            'ERROR ',
                                                            style: kTitleStyle.copyWith(
                                                                color:
                                                                    kBlackish,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                      ),
                                                      btnOkOnPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ).show()
                                            });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
