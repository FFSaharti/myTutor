import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';

class ViewReviewsScreen extends StatelessWidget {
  final List<Rate> tutorRates;

  ViewReviewsScreen({Key key, this.tutorRates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: buildAppBar(context, Theme.of(context).accentColor, "Reviews"),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: ListView.builder(
                      itemCount: tutorRates.length,
                      itemBuilder: (context, index) {
                        return tutorRates.elementAt(index).review == null
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
                                              tutorRates
                                                  .elementAt(index)
                                                  .sessionTitle,
                                              style: GoogleFonts.sen(
                                                  color: Theme.of(context).buttonColor,
                                                  fontSize: 20),
                                            ),
                                            Spacer(),
                                            Text(getRating(
                                                tutorRates.elementAt(index)) , style: TextStyle(color: Theme.of(context).buttonColor),),
                                          ],
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            tutorRates.elementAt(index).review,
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

  String getRating(Rate rating) {
    double ratingOutOfFive = (rating.communicationSkills +
            rating.creativity +
            rating.friendliness +
            rating.teachingSkills) /
        4;

    return ratingOutOfFive.toString() + " / 5";
  }
}
