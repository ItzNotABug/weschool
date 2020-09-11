import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/misc.dart';
import 'package:requests/requests.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  WebViewController _controller;
  bool loading = false;
  String data = "";

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
    fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance',
          style: TextStyle(color: kWeSchoolThemeColor),
        ),
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

  void fetchAttendance() async {
    setState(() => loading = true);

    var response = await Requests.get(kAttendanceUrl);
    var html = parse(response.content());
    var attendance = html.getElementsByClassName('table table-hover')[0];
    var leaveInfo = html.getElementsByClassName('table table-hover')[1];

    // Removes Serial Number Column (#)
    attendance.getElementsByTagName('tr').forEach((element) {
      // CASE 1:
      // If there is one subject with multiple faculty allotted,
      // there are only 5 columns i.e. No Serial & Subject Column.

      // CASE 2:
      // The other case leads when there is a subject listed with no Faculty
      // for example:
      // #              Subject                  Faculty
      // x          Summer Project         No faculty allotted

      // So, we make sure not to remove any other column except the serial number (#).
      if (element.children.length == 6 || element.children.length == 3) element.children.removeAt(0);
    });

    leaveInfo.getElementsByTagName('tr').forEach((element) {
      // Using `if` so that we don't remove the
      // inner `From` column from Leave Info. Table
      if (element.children[0].text != "From") element.children.removeAt(0);
    });

    String cssified = cssifyHtml(attendance.outerHtml, leaveInfo.outerHtml);
    _controller.loadUrl(Uri.dataFromString(cssified,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());

    Future.delayed(Duration(milliseconds: 1400), () {
      setState(() => loading = false);
    });
  }

  String cssifyHtml(String raw, String leaveInfo) {
    String abbreviationInfo = """
      <b>
        <font size="1.5px" color="red">
          <br>T.S = Total Sessions.
          <br>C = Conducted.
          <br>A = Attended By Me.
        </font>
      </b>
    <br>
    """;
    String leaveHolderText = """
    <center><p><b><font size="3px">Leave Approved/Applied</font></b></center>
    """;

    String cssified = """
    <html>
      $kHtmlHead       
      <body bgcolor="#ffffff">
      <center>
        $raw
      </center>
      
        $abbreviationInfo
        
      <center>
        $leaveHolderText
        $leaveInfo
        <br><br>
      </center>
      </body>
      </html>
    """;
    return Misc.replaceAttendanceFields(cssified);
  }

  // Removing or shortening some strings
  // so that they don't take too much width.

}
