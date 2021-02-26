import 'package:flutter/material.dart';
import 'package:mytutor/classes/rate.dart';
import 'package:mytutor/utilities/screen_size.dart';

class ViewReviewsScreen extends StatelessWidget {
  final List<Rate> tutorRates;

  const ViewReviewsScreen({Key key, this.tutorRates}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(height: ScreenSize.height*0.08,),
          Expanded(
            child: ListView.builder(
              itemCount: tutorRates.length,
              itemBuilder: (context, index) {
                return tutorRates.elementAt(index).review == null ? Text("") :Card(
                  child: ListTile(
                    leading: Icon(Icons.rate_review),
                    title: Text(tutorRates.elementAt(index).sessionTitle),
                    subtitle: Text(tutorRates.elementAt(index).review) ,
                    trailing: Text("4/5"),
                  ),
                );
              },
            ),
          )



        ],
      ),
    ));
  }
}
