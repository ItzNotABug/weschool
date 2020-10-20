import 'package:flutter/material.dart';

class NavigatorCompat {
  final BuildContext context;
  final Widget destination;

  NavigatorCompat.push(this.context, this.destination) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }
}
