import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';

class AboutInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 12,
      scrollable: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Container(
        margin: const EdgeInsets.only(left: 4),
        child: Text(
          kAboutInfoTitle,
          style: TextStyle(
              color: Colors.deepPurple,
              fontFamily: kSerif,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              kAboutInfoMessage,
              style: TextStyle(fontFamily: kSerif),
            ),
            SizedBox(height: 32),
            Text(
              kAboutInfoFooter,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.deepPurple,
                fontFamily: kSerif,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
