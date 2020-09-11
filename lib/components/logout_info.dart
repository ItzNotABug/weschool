import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/screens/login/login.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Container(
          margin: const EdgeInsets.only(left: 4),
          child: Text(
            kLogoutTitle,
            style: TextStyle(
                color: Colors.red,
                fontFamily: kSerif,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          )),
      content: Text(
        kLogoutConfirmation,
        style: TextStyle(fontFamily: kSerif),
      ),
      actions: <Widget>[
        FlatButton(
          splashColor: Colors.deepPurpleAccent.withAlpha(50),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          onPressed: () {
            Future.delayed(
              Duration(milliseconds: 200),
              () async {
                Navigator.pop(context);
              },
            );
          },
          child: Text(
            kLogoutCancel,
            style: TextStyle(
                fontFamily: kSerif,
                color: Colors.deepPurpleAccent,
                fontSize: 16),
          ),
        ),
        FlatButton(
          splashColor: Colors.deepPurpleAccent.withAlpha(50),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          onPressed: () {
            Future.delayed(
              Duration(milliseconds: 200),
              () async {
                clearSharedPreferences();
                clearCookies();
                popBack(context);
              },
            );
          },
          child: Text(
            kLogoutTitle,
            style: TextStyle(
                fontFamily: kSerif,
                color: Colors.deepPurpleAccent,
                fontSize: 16),
          ),
        ),
      ],
    );
  }

  void clearSharedPreferences() async {
    await SharedPreferences.getInstance().then((value) => value.clear());
  }

  void clearCookies() async {
    String hostname = Requests.getHostname(kPrimaryDomain);
    await Requests.clearStoredCookies(hostname);
  }

  void popBack(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => Login()));
  }
}
