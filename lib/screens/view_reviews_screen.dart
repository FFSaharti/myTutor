import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

class ViewReviewsScreen extends StatefulWidget {
  final List<Rate> tutorRates;

  ViewReviewsScreen({Key key, this.tutorRates}) : super(key: key);

  @override
  _ViewReviewsScreenState createState() => _ViewReviewsScreenState();
}

class _ViewReviewsScreenState extends State<ViewReviewsScreen> {
  bool hasReview = false;
@override
  void initState() {
    checkReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(hasReview);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: buildAppBar(context, Theme.of(context).accentColor, "Reviews"),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: hasReview == false ? Center(child: Text("the tutor does not have reviews - Yet" , style: GoogleFonts.openSans(
                color: Theme.of(context).buttonColor,
                // Theme.of(context).primaryColor,
                fontSize: 21),),) : Column(
              children: [
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView.builder(
                      itemCount: widget.tutorRates.length,
                      itemBuilder: (context, index) {
                        return widget.tutorRates.elementAt(index).review == null
                            ? Text("")
                            : Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Card(
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context).cardColor.withOpacity(0.6), width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.rate_review,
                                              size: 21,
                                            ),
                                            SizedBox(
                                              width: ScreenSize.width * 0.02,
                                            ),
                                            Text(
                                              widget.tutorRates
                                                  .elementAt(index)
                                                  .sessionTitle,
                                              style: GoogleFonts.sen(
                                                  color: Theme.of(context).buttonColor,
                                                  fontSize: 20),
                                            ),
                                            Spacer(),
                                            Text(getRating(
                                                widget.tutorRates.elementAt(index)) , style: TextStyle(color: Theme.of(context).buttonColor),),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.tutorRates.elementAt(index).review,
                                            style: GoogleFonts.sen(
                                                color: Theme.of(context).buttonColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  void checkReviews(){
    for (var tutorRate in widget.tutorRates){
      if (tutorRate.review != null){
        setState(() {
          hasReview =true;
        });
        return;
      }
    }
  }

  String getRating(Rate rating) {
    double ratingOutOfFive = (rating.communicationSkills +
            rating.creativity +
            rating.friendliness +
            rating.teachingSkills) /
        4;

    return ratingOutOfFive.toString() + " / 5";
  }
}
