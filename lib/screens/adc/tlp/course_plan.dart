import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/misc.dart';
import 'package:project_welingkar/misc/models/banner_ad.dart';
import 'package:project_welingkar/misc/models/course_plan_modal.dart';

class CoursePlan extends StatefulWidget {
  @override
  _CoursePlanState createState() => _CoursePlanState();
}

class _CoursePlanState extends State<CoursePlan> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<CoursePlanModal> _list;
  bool loading = false;
  String data = "";

  // If the user leaves the screen when the data was still loading
  // & then if `setState()` is called after the data is loaded,
  // an error is thrown `Unhandled Exception: setState() called after dispose():`.
  // This can prevent that.
  // kinda hackish though.
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCoursePlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Course Plan',
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
                      CoursePlanModal modal = _list[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              if (modal.link.isEmpty) {
                                errorSnack('Course Plan not available.');
                                return;
                              }

                              try {
                                await launch(
                                  modal.link,
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
                                    data: modal.subject,
                                    style: {'body': kCoursePlanBodyStyle},
                                  ),
                                  Html(
                                    data: handleFacultyData(modal),
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
      bottomNavigationBar: BottomBannerAd(),
    );
  }

  void fetchCoursePlan() async {
    setState(() => loading = true);

    List<CoursePlanModal> list = List();
    var html = await Misc.getContent(kCoursePlanUrl);
    var coursePlan = html.getElementsByClassName('box box-primary')[0];
    var coursePlanTrList = coursePlan.getElementsByTagName('tr').asMap();
    coursePlanTrList.forEach((index, element) {

      // Considering that at max there can be
      // `2` faculties to `1` subject.
      if (index != 0) {
        if (element.children.length == 3) {
          String subject = coursePlanTrList[index - 1].children[0].outerHtml;
          String faculty = element.children[0].outerHtml;
          String dean = handleDean(element.children[1]);
          String url = handleUrl(element, true);
          list.add(CoursePlanModal(subject, faculty, dean, getCorrectUrl(url)));
        } else {
          // Elements with 3 columns don't have a serial column.
          element.children.removeAt(0);
          String subject = element.children[0].outerHtml;
          String faculty = element.children[1].outerHtml;
          String dean = handleDean(element.children[2]);
          String url = handleUrl(element, false);
          list.add(CoursePlanModal(subject, faculty, dean, getCorrectUrl(url)));
        }
      }
    });

    Future.delayed(Duration(milliseconds: 1400), () {
      setState(() {
        loading = false;
        _list = list;
      });
    });
  }

  // This is ugly but them, meh 🤷‍
  String handleFacultyData(CoursePlanModal modal) {
    String facultyAndDean = 'Dean:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
        modal.dean +
        '<br>Faculty:&nbsp;&nbsp;&nbsp;' +
        modal.faculty +
        '<br><br>Course Plan: ${modal.link.isEmpty ? "N/A" : "Available"}';

    return facultyAndDean;
  }

  String handleDean(dom.Element element) {
    String dean = element.outerHtml;
    if (!dean.contains('Prof.')) {
      var deanElement = dom.Element.html(dean);
      deanElement.text = 'Prof. ' + deanElement.text;
      dean = deanElement.outerHtml;
    } else
      dean = element.children[2].outerHtml;

    return dean;
  }

  String handleUrl(dom.Element element, bool previous) {
    String url;
    int columnCount = previous ? 2 : 3;

    if (element.children[columnCount].children.length != 0 &&
        element.children[columnCount].children[0].attributes
            .containsKey('href'))
      url = element.children[columnCount].children[0].attributes['href'];
    else
      url = '';

    return url;
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
    if (raw.isEmpty) return '';

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
}
