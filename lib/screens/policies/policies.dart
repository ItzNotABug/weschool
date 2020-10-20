import 'package:flutter/material.dart';
import 'package:project_welingkar/components/dashboard_menu_item.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/models/banner_ad.dart';
import 'package:project_welingkar/misc/models/policy_modal.dart';
import 'package:project_welingkar/misc/navigator_compat.dart';
import 'package:project_welingkar/screens/policies/policy_data.dart';
import 'package:project_welingkar/screens/webview/password_reset_webview.dart';

class Policies extends StatelessWidget {
  final List<PolicyModal> _policyList = PolicyData().policyList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Policies',
          style: TextStyle(color: kWeSchoolThemeColor),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView.builder(
          itemCount: _policyList.length,
          itemBuilder: (_, index) {
            PolicyModal _modal = _policyList[index];
            return DashboardMenuItem(
              name: _modal.title,
              isInfo: false,
              onTap: () {
                NavigatorCompat.push(
                    context,
                    PassResetWebView(
                      title: _modal.title,
                      url: _modal.url,
                    ));
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomBannerAd(),
    );
  }
}
