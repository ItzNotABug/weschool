import 'package:flutter/material.dart';
import 'package:project_welingkar/screens/dashboard/dashboard.dart';
import 'package:project_welingkar/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  SharedPreferences sharedPreferences;

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    Future.delayed(Duration(milliseconds: 800), () {
      if (!isLoggedIn)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Login()));
      else
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Dashboard()));
    });
  }

  @override
  void initState() {
    super.initState();

    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/weschool-logo.png',
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
              )),
              SizedBox(
                height: 75,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
              )
            ],
          ),
        ),
      ),
    );
  }
}
