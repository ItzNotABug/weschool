import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';

class TextDivider extends StatelessWidget {
  final String title;

  const TextDivider({this.title});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 22.0, right: 22.0),
            child: Divider(
              color: kWeSchoolThemeColor,
              height: 50,
            )),
      ),
      Text(
        title,
        style: TextStyle(
            fontFamily: kSerif,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: kWeSchoolThemeColor),
      ),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 22.0, right: 22.0),
            child: Divider(
              color: kWeSchoolThemeColor,
              height: 50,
            )),
      ),
    ]);
  }
}
