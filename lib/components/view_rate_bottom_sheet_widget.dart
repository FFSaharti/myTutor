import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/utilities/constants.dart';
import 'package:mytutor/utilities/screen_size.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ViewRateBottomSheet {
  static void show(List<Rate> rates, BuildContext c) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: c,
        builder: (context) {
          return Container(
            height: ScreenSize.height * 0.40,
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                )),
            child: rates.length == 0
                ? Center(
                    child: Text(
                      "tutor does not have any rate yet :(",
                      style: GoogleFonts.openSans(
                          color: Theme.of(context).buttonColor, fontSize: 21),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Text(
                          "Tutor rates",
                          style: kTitleStyle.copyWith(
                              color: Theme.of(context).buttonColor,
                              fontSize: 25),
                        ),
                        Divider(
                          color: kGreyish,
                        ),
                        // Text("We have 4 criteria for rating in our system. "),
                        // Text("and the tutor has a rating as : "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Teaching Skills :",
                              style: GoogleFonts.openSans(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 17),
                            ),
                            Spacer(),
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  print(v);
                                },
                                starCount: 5,
                                rating:
                                    Rate.getAverageRateForTeachingSkills(rates),
                                size: 40.0,
                                isReadOnly: true,
                                color: kColorScheme[2],
                                borderColor: kColorScheme[1],
                                spacing: 0.0),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.010,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Communication :",
                              style: GoogleFonts.openSans(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 17),
                            ),
                            Spacer(),
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  print(v);
                                },
                                starCount: 5,
                                rating:
                                    Rate.getAverageRateForCommunication(rates),
                                size: 40.0,
                                isReadOnly: true,
                                color: kColorScheme[2],
                                borderColor: kColorScheme[1],
                                spacing: 0.0),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.010,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Creativity : ",
                              style: GoogleFonts.openSans(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 17),
                            ),
                            Spacer(),
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  print(v);
                                },
                                starCount: 5,
                                rating: Rate.getAverageRateForCreativity(rates),
                                size: 40.0,
                                isReadOnly: true,
                                color: kColorScheme[2],
                                borderColor: kColorScheme[1],
                                spacing: 0.0),
                          ],
                        ),
                        SizedBox(
                          height: ScreenSize.height * 0.010,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Friendliness : ",
                              style: GoogleFonts.openSans(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 17),
                            ),
                            Spacer(),
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRated: (v) {
                                  print(v);
                                },
                                starCount: 5,
                                rating:
                                    Rate.getAverageRateForFriendliness(rates),
                                size: 40.0,
                                isReadOnly: true,
                                color: kColorScheme[2],
                                borderColor: kColorScheme[1],
                                spacing: 0.0),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
