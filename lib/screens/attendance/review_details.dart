import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/misc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReviewDetails extends StatefulWidget {
  final String url, title;

  const ReviewDetails({this.url, this.title});

  @override
  _ReviewDetailsState createState() => _ReviewDetailsState();
}

class _ReviewDetailsState extends State<ReviewDetails> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  WebViewController _controller;
  bool loading = true;
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
    fetchAttReview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          widget.title,
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

  void fetchAttReview() async {
    String url = widget.url;
    var html = await Misc.getContent(url);
    var reviewDetails = html.getElementsByClassName('table table-hover')[0];
    reviewDetails.getElementsByTagName('tr').asMap().forEach((index, element) {
      element.children[0].remove();
      element.children.last.attributes.addAll({'width': "25%"});
    });

    String cssified = cssifyHtml(reviewDetails.outerHtml);
    _controller.loadUrl(Uri.dataFromString(cssified,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
    Future.delayed(Duration(milliseconds: 1400), () {
      setState(() => loading = false);
    });
  }

  String cssifyHtml(String raw) {
    String abbreviationInfo = """
      <b>
        <font size="1.5px" color="red">
          <br>T.S = Total Sessions.
          <br>M.R = Minimum Required.
          <br>A = Attended.
        </font>
      </b>
    <br>
    """;

    String cssified = """
    <html>
      $kHtmlHead       
      <body bgcolor="#ffffff">
      <center>
        $raw
      </center>
        $abbreviationInfo
        <br><br>
        
      </body>
      </html>
    """;

    cssified = cssified.replaceAll('Subject Name', 'Subject');
    cssified = cssified.replaceAll('Lectures Taken', 'T.S');
    cssified = cssified.replaceAll('Min Req', 'M.R');
    cssified = cssified.replaceAll('Attended By Me', 'A');
    cssified = cssified.replaceAll('Leaves Approved/Applied', 'Status');
    cssified = cssified.replaceAll('<td width="25%"></td>', '<td width="25%">N/A</td>');
    return cssified;
  }
}
