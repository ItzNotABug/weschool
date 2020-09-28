import 'package:flutter/material.dart';
import 'package:project_welingkar/components/about_info.dart';
import 'package:project_welingkar/components/dashboard_menu_item.dart';
import 'package:project_welingkar/components/footer.dart';
import 'package:project_welingkar/components/logout_info.dart';
import 'package:project_welingkar/components/text_divider.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/screens/attendance/attendance.dart';
import 'package:project_welingkar/screens/attendance/review.dart';
import 'package:project_welingkar/screens/feed/feed_list.dart';
import 'package:project_welingkar/screens/notices/notices.dart';
import 'package:project_welingkar/screens/schedule/schedule.dart';
import 'package:project_welingkar/screens/tlp/course_plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connectivity/simple_connectivity.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  SharedPreferences _sharedPreferences;
  String userInfo = '';

  void initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    String saved = _sharedPreferences.getString('user_data') ?? '';
    if (saved.isNotEmpty)
      setState(() {
        userInfo = saved;
      });
  }

  Future<bool> isConnected() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          'WeSchool',
          style: TextStyle(color: kWeSchoolThemeColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            onPressed: () {
              showDialog(context: context, child: AboutInfo());
            },
            icon: Icon(
              Icons.info_outline,
              color: kWeSchoolThemeColor,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  child: LogoutInfo(),
                  barrierDismissible: false,
                );
              },
              icon: Icon(
                Icons.exit_to_app,
                color: kWeSchoolThemeColor,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DashboardMenuItem(
                name: userInfo,
                isInfo: true,
                onTap: () {},
              ),
              TextDivider(
                title: 'A D C',
              ),
              DashboardMenuItem(
                name: 'Schedule',
                isInfo: false,
                onTap: () async {
                  bool isScheduleEmpty =
                      (_sharedPreferences.getString('schedule') ?? '').isEmpty;
                  if (!(await isConnected()) && isScheduleEmpty)
                    showSnack('Offline');
                  else
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Schedule()));
                },
              ),
              DashboardMenuItem(
                name: 'Attendance',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Attendance()));
                },
              ),
              DashboardMenuItem(
                name: 'Attendance Review',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AttendanceReview()));
                },
              ),
              DashboardMenuItem(
                name: 'Course Plan',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => CoursePlan()));
                },
              ),
              DashboardMenuItem(
                name: 'Notices',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Notices()));
                },
              ),

              TextDivider(
                title: "Welingkar Blogs",
              ),

              DashboardMenuItem(
                name: 'Beyond the Walls',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => FeedList()));
                },
              ),
              // Case Central data (html) is not available yet.
              // TextDivider(
              //   title: 'Case Central',
              // ),
              // DashboardMenuItem(
              //   name: 'Case Studies',
              //   isInfo: false,
              // ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  void showSnack(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        child: Text(
          message,
          style: TextStyle(fontFamily: kSerif, fontSize: 16),
        ),
      ),
      duration: Duration(milliseconds: 800),
    ));
  }
}
