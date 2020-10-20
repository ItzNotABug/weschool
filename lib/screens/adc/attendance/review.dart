import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/misc.dart';
import 'package:project_welingkar/misc/models/att_review_modal.dart';
import 'package:project_welingkar/misc/models/banner_ad.dart';
import 'package:project_welingkar/misc/navigator_compat.dart';
import 'package:project_welingkar/screens/adc/attendance/review_details.dart';

class AttendanceReview extends StatefulWidget {
  @override
  _AttendanceReviewState createState() => _AttendanceReviewState();
}

class _AttendanceReviewState extends State<AttendanceReview> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<AttReviewModal> _list;
  bool loading = false;

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
    fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'Attendance Review',
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
                        AttReviewModal modal = _list[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () async {
                                NavigatorCompat.push(
                                    context,
                                    ReviewDetails(
                                      url:
                                          'https://elearn.welingkar.org/adc_new/${modal.link}',
                                      title: 'Review',
                                    ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Html(
                                      data: 'Type: ' + modal.type,
                                      style: {'body': kCoursePlanBodyStyle},
                                    ),
                                    Html(
                                      data: 'Start Date:&nbsp;&nbsp;&nbsp;' +
                                          modal.startDate +
                                          '<br>End Date:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
                                          modal.endDate,
                                      //modal.date,
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
      bottomNavigationBar: BottomBannerAd(),
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

  void fetchAttendance() async {
    setState(() => loading = true);

    var html = await Misc.getContent(kAttendanceReviewUrl);
    var attReview = html.getElementsByClassName('table table-hover')[0];

    if (attReview != null &&
        attReview.outerHtml.isNotEmpty &&
        attReview.children.length != 0) {
      attReview.children[0].children[0].remove();
      List<AttReviewModal> list = List();

      attReview.getElementsByTagName('tr').asMap().forEach((index, element) {
        element.children[0].remove();
        String type = element.children[0].outerHtml;
        String startDate = element.children[1].outerHtml;
        String endDate = element.children[2].outerHtml;
        String link = element.children[4].children[0].attributes['href'];
        list.add(AttReviewModal(type, startDate, endDate, link));
      });

      Future.delayed(Duration(milliseconds: 1400), () {
        setState(() {
          loading = false;
          _list = list;
        });
      });
    } else {
      setState(() => loading = false);
      errorSnack('No data found');
      Future.delayed(Duration(milliseconds: 600), () {
        Navigator.pop(context);
      });
    }
  }
}
