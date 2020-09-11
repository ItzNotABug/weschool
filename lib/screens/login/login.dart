import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:project_welingkar/components/border_rounded_button.dart';
import 'package:project_welingkar/components/rounded_button.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/screens/dashboard/dashboard.dart';
import 'package:project_welingkar/screens/webview/common_webview.dart';
import 'package:requests/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  bool _loading = false;
  bool _passwordVisible = false;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _loading,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.deepPurpleAccent),
      ),
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(color: kWeSchoolThemeColor),
          ),
          elevation: 0,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        email = value;
                      },
                      decoration:
                          kTextFieldDecoration.copyWith(hintText: 'Email'),
                    ),
                  ),
                  SizedBox(height: 14),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      cursorColor: Colors.deepPurpleAccent,
                      autocorrect: false,
                      obscureText: !_passwordVisible,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.deepPurpleAccent,
                            ),
                            onPressed: () => setState(
                                () => _passwordVisible = !_passwordVisible),
                          )),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  RoundedButton(
                    title: 'Log In',
                    colour: Colors.deepPurpleAccent,
                    onPressed: () {
                      if (email.trim().isEmpty) {
                        errorSnack('Enter email address');
                        return;
                      }

                      if (!email.trim().contains('@')) {
                        errorSnack('Email address not valid');
                        return;
                      }

                      if (password.trim().isEmpty) {
                        errorSnack('Enter Password');
                        return;
                      }

                      postLoginDetails();
                    },
                  ),
                  BorderRoundedButton(
                    title: 'Forgot Password',
                    colour: Colors.deepPurpleAccent,
                    onPressed: () {
                      showForgotPassThing();
                    },
                  ),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void postLoginDetails() async {
    setState(() {
      _loading = true;
    });

    String base64Email = base64.encode(utf8.encode(email));
    String base64Password = base64.encode(utf8.encode(password));
    String campus = base64.encode(utf8.encode('mumbai'));

    // FIXME: Have no idea as to why the first auth is always rejected
    Response response = await Requests.get(kAuthorizeLoginUrl,
        queryParameters: {
          'username1': base64Email,
          'password1': base64Password,
          'campus1': campus
        });

    if (response.content().toString().contains('Student Dashboard')) {
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setBool('isLoggedIn', true);
      saveUserInfo(response.content());

      setState(() {
        _loading = false;
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Dashboard()));
      });
    } else {
      setState(() {
        _loading = false;
      });
      errorSnack('Wrong Credentials');
    }
  }

  void errorSnack(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          message,
          style: TextStyle(fontFamily: kSerif, fontSize: 15),
        ),
      ),
      duration: Duration(milliseconds: 800),
      backgroundColor: Colors.redAccent,
    ));
  }

  void saveUserInfo(String raw) async {
    String data = "";
    var element = parser.parse(raw);
    var userHeader = element.getElementsByClassName('user-header')[0];
    userHeader.children[0].children[0].remove();
    userHeader.children[0].children[0].remove();
    userHeader.children[0].children[0].remove();

    userHeader.children[0].children.forEach((element) {
      data += element.text + '\n';
    });

    //data = userHeader.children[0].children[0].text;

    if (data.contains('Specialisation'))
      data = data.replaceAll('Specialisation', '\nSpecialisation');

    data = data
        .split(new RegExp(r'(?:\r?\n|\r)'))
        .where((s) => s.trim().length != 0)
        .join('\n');

    data = data.replaceAll(' : ', ': ');

    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('user_data', data);
  }

  void showForgotPassThing() {
    showDialog(
        context: context,
        child: AlertDialog(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Container(
              margin: const EdgeInsets.only(left: 4),
              child: Text(
                "Security Alert",
                style: TextStyle(
                    color: Colors.red,
                    fontFamily: kSerif,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
          content: Text(
            "The password reset logic applied by college's IT department does not adhere to Security Standards."
            "\nTherefore anyone with your email address can change your password and login via those new credentials."
            "\n\nDo not share your login Email with anyone!",
            style: TextStyle(fontFamily: kSerif),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                splashColor: Colors.deepPurpleAccent.withAlpha(50),
                padding: const EdgeInsets.all(12),
                onPressed: () {
                  Future.delayed(
                    Duration(milliseconds: 200),
                    () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PassResetWebView(
                            title: 'Password Reset',
                            url: kPasswordResetUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  "Reset Password!",
                  style: TextStyle(
                      fontFamily: kSerif,
                      color: Colors.deepPurpleAccent,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
