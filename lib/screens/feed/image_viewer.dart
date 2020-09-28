import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String src;

  const ImageViewer({this.src});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Back"),
        centerTitle: false,
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: PhotoView(
              imageProvider: NetworkImage(src),
            ),
          )),
    );
  }
}
