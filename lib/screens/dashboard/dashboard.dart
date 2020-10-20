import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_welingkar/components/about_info.dart';
import 'package:project_welingkar/components/dashboard_menu_item.dart';
import 'package:project_welingkar/components/footer.dart';
import 'package:project_welingkar/components/logout_info.dart';
import 'package:project_welingkar/components/text_divider.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/models/banner_ad.dart';
import 'package:project_welingkar/misc/navigator_compat.dart';
import 'package:project_welingkar/screens/adc/attendance/attendance.dart';
import 'package:project_welingkar/screens/adc/attendance/review.dart';
import 'package:project_welingkar/screens/adc/notices/notices.dart';
import 'package:project_welingkar/screens/adc/schedule/schedule.dart';
import 'package:project_welingkar/screens/adc/tlp/course_plan.dart';
import 'package:project_welingkar/screens/feed/feed_list.dart';
import 'package:project_welingkar/screens/policies/policies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connectivity/simple_connectivity.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isServerDown = false;
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

  void adMobTrackingPermission() async {
    /// for iOS 14
    await Admob.requestTrackingAuthorization();
  }

  Future<bool> isConnected() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  /// Elearn is down sometimes
  void checkIfServerIsDown() async {
    if (await isConnected()) {
      /// Unable to use `Requests` because
      /// previous attempts showed that saved cookies are removed
      /// Also 3 seconds is fine...
      http
          .get(kPrimaryDomain)
          .timeout(Duration(seconds: 3))
          .then((result) => {
                if (result.statusCode != 200)
                  {isServerDown = true, showConnectivitySnack(true)}
                else
                  {isServerDown = false, showConnectivitySnack(false)}
              })
          .catchError((Object error) {
        isServerDown = true;
        showConnectivitySnack(true);
      });
    }
  }

  @override
  void initState() {
    checkIfServerIsDown();
    super.initState();
    initSharedPreferences();
    adMobTrackingPermission();
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
            children: [
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
                    NavigatorCompat.push(context, Schedule());
                },
              ),
              DashboardMenuItem(
                name: 'Attendance',
                isInfo: false,
                onTap: () async {
                  showOfflineSnack(
                      () => NavigatorCompat.push(context, Attendance()));
                },
              ),
              DashboardMenuItem(
                name: 'Attendance Review',
                isInfo: false,
                onTap: () async {
                  showOfflineSnack(
                      () => NavigatorCompat.push(context, AttendanceReview()));
                },
              ),
              DashboardMenuItem(
                name: 'Course Plan',
                isInfo: false,
                onTap: () async {
                  showOfflineSnack(
                      () => NavigatorCompat.push(context, CoursePlan()));
                },
              ),
              DashboardMenuItem(
                name: 'Notices',
                isInfo: false,
                onTap: () async {
                  showOfflineSnack(
                      () => NavigatorCompat.push(context, Notices()));
                },
              ),

              TextDivider(
                title: "Miscellaneous",
              ),
              DashboardMenuItem(
                name: 'Policies',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    NavigatorCompat.push(context, Policies());
                },
              ),
              DashboardMenuItem(
                name: 'Blog - Beyond the Walls',
                isInfo: false,
                onTap: () async {
                  if (!(await isConnected()))
                    showSnack('Offline');
                  else
                    NavigatorCompat.push(context, FeedList());
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
      bottomNavigationBar: BottomBannerAd(),
    );
  }

  void showSnack(String message) {
    _key.currentState.showSnackBar(SnackBar(
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        child: Text(
          message,
          style: TextStyle(fontFamily: kSerif, fontSize: 16),
        ),
      ),
      duration: Duration(milliseconds: 800),
    ));
  }

  void showOfflineSnack(Function listener) async {
    if (!(await isConnected())) {
      showSnack('Offline');
      return;
    } else if (await isConnected() && isServerDown)
      showConnectivitySnack(true);
    else
      listener.call();
  }

  void showConnectivitySnack(bool isError) {
    String message =
        isError ? "Elearn Portal is Down!" : "Connected to Portal!";
    _key.currentState.showSnackBar(SnackBar(
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
        child: Text(
          message,
          style: TextStyle(fontFamily: kSerif, fontSize: 16),
        ),
      ),
      duration: Duration(milliseconds: 2500),
    ));
  }
}
