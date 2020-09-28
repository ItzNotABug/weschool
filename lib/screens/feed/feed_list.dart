import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_welingkar/constants/constants.dart';
import 'package:project_welingkar/screens/feed/feed_detail.dart';
import 'package:requests/requests.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/domain/rss_item.dart';

class FeedList extends StatefulWidget {
  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  GlobalKey<ScaffoldState> _key = GlobalKey();
  List<RssItem> _list;
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
    fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welingkar Blog',
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
                      RssItem modal = _list[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => FeedDetail(
                                            title: "Blog Post",
                                            html: modal.content.value,
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(modal.title,
                                        style: TextStyle(
                                          fontFamily: kSerif,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kWeSchoolThemeColor,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Text(
                                      "Dated: ${DateFormat('dd-MM-yyyy').format(modal.pubDate)}",
                                      style: TextStyle(
                                          fontFamily: kSerif, fontSize: 14),
                                    ),
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

  void fetchFeed() async {
    setState(() => loading = true);

    var response = await Requests.get("http://blogs.welingkar.org/feed");
    var channel = RssFeed.parse(response.content());
    setState(() {
      loading = false;
      _list = channel.items;
    });
  }
}
