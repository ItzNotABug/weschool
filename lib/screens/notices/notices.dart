import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/misc.dart';
import 'package:project_welingkar/misc/pojos/notices_modal.dart';

/*
TODO:
 Make it a Card List rather than a WebView,
 WebView ain't currently working properly on Android!
*/

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<NoticesModal> _list;
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
      key: _key,
      appBar: AppBar(
        title: Text(
          'Notices',
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
                    child: ListView.builder(
                      itemCount: _list == null ? 0 : _list.length,
                      itemBuilder: (_, index) {
                        NoticesModal modal = _list[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                try {
                                  await launch(
                                    modal.url,
                                    option: new CustomTabsOption(
                                      toolbarColor: kWeSchoolThemeColor,
                                      enableDefaultShare: true,
                                      enableUrlBarHiding: true,
                                      showPageTitle: true,
                                    ),
                                  );
                                } catch (_) {
                                  if (Platform.isAndroid)
                                    errorSnack('Google Chrome not found');
                                  else
                                    errorSnack('Error opening notice');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Html(
                                      data: modal.title,
                                      style: {
                                        'font': Style(
                                          fontFamily: 'Serif',
                                          fontSize: FontSize(18),
                                          color: kWeSchoolThemeColor,
                                          verticalAlign: VerticalAlign.SUPER,
                                        ),
                                        'body': kBodyStyle16,
                                      },
                                    ),
                                    Html(
                                      data: 'Dated:&nbsp;&nbsp;&nbsp;' +
                                          modal.date,
                                      style: {
                                        'body': kBodyStyle15,
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
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
    ));
  }

  String getCorrectUrl(String raw) {
    String url;
    if (raw.contains('pdf')) {
      // Chrome Tab straightaway downloads the PDF
      if (Platform.isAndroid)
        url =
            'https://docs.google.com/viewerng/viewer?url=https://elearn.welingkar.org/adc_new/$raw';
      else
        url = 'https://elearn.welingkar.org/adc_new/$raw';
    } else
      url =
          'https://view.officeapps.live.com/op/embed.aspx?src=https://elearn.welingkar.org/adc_new/$raw';
    return url;
  }

  void fetchAttendance() async {
    setState(() => loading = true);

    var html = await Misc.getContent(kNoticesUrl);
    var notices = html.getElementsByClassName('table table-striped')[0];
    List<NoticesModal> list = List();
    notices.getElementsByTagName('tr').asMap().forEach((index, element) {
      element.children.removeAt(0);
      if (index != 0) {
        String title = element.children[0].outerHtml;
        String link =
            element.children[1].children[0].attributes.values.elementAt(0);
        String date = element.children[2].outerHtml;

        list.add(NoticesModal(title, getCorrectUrl(link), date));
      }
    });

    Future.delayed(Duration(milliseconds: 1400), () {
      setState(() {
        loading = false;
        _list = list;
      });
    });
  }
}
