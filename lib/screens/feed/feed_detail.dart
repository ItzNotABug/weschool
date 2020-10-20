import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/misc/models/banner_ad.dart';
import 'package:project_welingkar/screens/feed/image_viewer.dart';

class FeedDetail extends StatefulWidget {
  final String html, title;

  const FeedDetail({this.html, this.title});

  @override
  _FeedDetailState createState() => _FeedDetailState();
}

class _FeedDetailState extends State<FeedDetail> {
  bool loading = true;
  String rssContent = "";

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
    rssContent = widget.html + "<br><br>";
    Future.delayed(Duration(seconds: 2), () => setState(() => loading = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blog Post",
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 10),
                          child: Text(widget.title,
                              style: TextStyle(
                                fontFamily: kSerif,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: kWeSchoolThemeColor,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            thickness: 1.8,
                            color: kWeSchoolThemeColor.withAlpha(150),
                          ),
                        ),
                        Html(
                          data: rssContent,
                          style: {'body': kBodyStyle16},
                          onImageTap: (src) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ImageViewer(
                                          src: src,
                                        )));
                          },
                        ),
                      ],
                    ),
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
}
