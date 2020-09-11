import 'package:flutter/material.dart';
import 'package:project_welingkar/constants/constants.dart';

class DashboardMenuItem extends StatelessWidget {
  final String name;
  final Function onTap;
  final bool isInfo;

  const DashboardMenuItem({this.name, this.isInfo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () =>
              Future.delayed(Duration(milliseconds: 100), () => onTap.call()),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(isInfo ? 22.0 : 18.0),
            child: Text(
              name,
              style: TextStyle(
                  fontSize: isInfo ? 18 : 17,
                  color: Colors.blueGrey[800],
                  fontFamily: kSerif,
                  height: isInfo ? 2 : 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
