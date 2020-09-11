import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({this.title, this.colour, @required this.onPressed});

  final Color colour;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: MaterialButton(
        elevation: 5.0,
        color: colour,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        onPressed: onPressed,
        minWidth: 200.0,
        height: 42.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontFamily: kSerif),
          ),
        ),
      ),
    );
  }
}
