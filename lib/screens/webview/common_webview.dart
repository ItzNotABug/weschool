import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

/*
TODO:
 Change current implementation of Password Reset to a Native One,
 for example: showing a Password Reset Widget Screen or an Alert Dialog.
 Then for the auth/reset logic, we can either use a `HeadlessWebView` or `Requests`.
*/

class PassResetWebView extends StatefulWidget {
  final String url, title;

  const PassResetWebView({this.url, this.title});

  @override
  _PassResetWebViewState createState() => _PassResetWebViewState();
}

class _PassResetWebViewState extends State<PassResetWebView> {
  bool loading = true;
  WebViewController _controller;
  GlobalKey<ScaffoldState> _key = GlobalKey();

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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: kWeSchoolThemeColor)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: kWeSchoolThemeColor,
            ),
            onPressed: () => _controller.reload(),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SafeArea(
            top: true,
            bottom: false,
            child: Opacity(
              opacity: loading ? 0 : 1,
              child: WebView(
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onPageStarted: (_) => setState(() => loading = true),
                onPageFinished: (currentUrl) async {
                  if (currentUrl == kPasswordResetUrl)
                    await _controller.evaluateJavascript(kPasswordResetJS);
                  if (currentUrl.contains(kPasswordResetInvalidUrlPart))
                    await _controller
                        .evaluateJavascript(kPasswordResetInvalidJS);

                  if (currentUrl.contains(kPasswordResetUrl) &&
                      currentUrl.contains(kPasswordResetSuccessUrlPart)) {
                    await _controller
                        .evaluateJavascript(kRemoveBodyJS)
                        .then((value) => {
                              showDialog(
                                context: context,
                                child: AlertDialog(
                                  content: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      kPasswordResetSuccessMessage,
                                      style: TextStyle(fontFamily: kSerif),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ).then((value) => {
                                    Future.delayed(Duration(seconds: 3), () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    })
                                  })
                            });
                  }
                  setState(() => loading = false);
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
    );
  }
}
