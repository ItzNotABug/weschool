import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 32),
        GestureDetector(
          onTap: () async {
            await launch('https://justanotherdeveloper.in',
                forceWebView: false, forceSafariVC: false);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'DarShan Pandya',
                style: TextStyle(
                    fontFamily: kSerif, fontSize: 18, color: Colors.grey[800]),
              ),
              Text(
                '#JustAnotherDeveloper',
                style: TextStyle(
                    fontFamily: kSerif, fontSize: 18, color: Colors.deepPurple),
              )
            ],
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}
