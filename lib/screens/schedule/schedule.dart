import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/misc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connectivity/simple_connectivity.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  SharedPreferences sharedPreferences;
  WebViewController _controller;
  bool loading = true;
  bool fireOffline = false;
  String data = "";

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // If the user leaves the screen when the data was still loading
  // & then if `setState()` is called after the data is loaded,
  // an error is thrown `Unhandled Exception: setState() called after dispose():`.
  // This can prevent that.
  // kinda hackish though.
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'Schedule',
          style: TextStyle(color: kWeSchoolThemeColor),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final datePicker = await showRoundedDatePicker(
                  context: context,
                  height: 320,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  theme: ThemeData(primarySwatch: Colors.deepPurple),
                  fontFamily: kSerif);
              if (datePicker != null) {
                String format = DateFormat("MM/dd/yyyy").format(datePicker);
                fetchSchedule(date: format);
              }
            },
            icon: Icon(
              Icons.date_range,
              color: kWeSchoolThemeColor,
              size: 26,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SafeArea(
                top: true,
                bottom: false,
                child: Opacity(
                  opacity: loading ? 0 : 1,
                  child: WebView(
                    initialUrl: '',
                    onWebViewCreated: (controller) {
                      _controller = controller;

                      if (fireOffline) handleOffline(controller);
                    },
                  ),
                ),
              ),
              Opacity(
                opacity: loading ? 1 : 0,
                child: SafeArea(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kWeSchoolThemeColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Date format is `MM:DD:YYYY`
  void fetchSchedule({String date = ""}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        fireOffline = true;
      });
      return;
    }

    String url = kScheduleUrl;
    if (date.trim().isNotEmpty) url = url + '?date=$date';

    var html = await Misc.getContent(url);
    var timetable = html.getElementsByClassName('col-xs-12')[0];
    timetable.children[0].children.removeAt(0);
    timetable.children[0].children.removeAt(0);
    timetable.getElementsByTagName('tr').forEach((element) {
      // Removes the Feedback column,
      // it breaks the Table Column UI.
      if (element.children.length == 7) element.children.removeLast();

      // Removing Serial Number Column (#)
      // Below check is necessary else it'll remove the
      // `Lecture Not Scheduled` or `Self Study` text because
      // it is added inside a `<td>` which is a child of `<tr>`.
      if (!element.outerHtml.contains('colspan="6" align="center"'))
        element.children.removeAt(0);
    });

    String cssified = cssifyHtml(timetable.outerHtml);
    _controller.loadUrl(Uri.dataFromString(cssified,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
    Future.delayed(Duration(milliseconds: 1400), () {
      setState(() => loading = false);
    });

    sharedPreferences.setString('schedule', cssified);
  }

  String cssifyHtml(String raw) {
    String cssified = """
    <html>
      $kHtmlHead       
      <body bgcolor="#ffffff">$raw</body>
      </html>
    """;

    return Misc.replaceScheduleFields(cssified);
  }

  void handleOffline(WebViewController controller) async {
    _key.currentState.showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          'Offline',
          style: TextStyle(fontFamily: kSerif, fontSize: 15),
        ),
      ),
      duration: Duration(milliseconds: 800),
    ));

    String offlineSchedule = sharedPreferences.getString('schedule');
    controller.loadUrl(Uri.dataFromString(offlineSchedule,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());

    Future.delayed(Duration(milliseconds: 800), () {
      setState(() => loading = false);
    });
  }
}
