import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';

class BorderRoundedButton extends StatelessWidget {
  BorderRoundedButton({this.title, this.colour, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: MaterialButton(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: colour)),
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontFamily: kSerif
            ),
          ),
        ),
      ),
    );
  }
}
