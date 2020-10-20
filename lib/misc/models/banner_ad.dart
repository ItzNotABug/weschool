import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';

class BottomBannerAd extends StatefulWidget {
  @override
  _BottomBannerAdState createState() => _BottomBannerAdState();
}

class _BottomBannerAdState extends State<BottomBannerAd> {
  bool _adLoaded = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _adLoaded,
      child: AdmobBanner(
        adUnitId: kBannerAdUnitId,
        adSize: AdmobBannerSize.ADAPTIVE_BANNER(
            width: MediaQuery.of(context).size.width.toInt()),
        listener: (event, args) async {
          if (event == AdmobAdEvent.loaded) {
            setState(() {
              _adLoaded = true;
            });
          }
          if (event == AdmobAdEvent.failedToLoad) {
            setState(() {
              _adLoaded = false;
            });
          }
        },
      ),
    );
  }
}
