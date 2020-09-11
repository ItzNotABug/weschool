import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_welingkar/screens/login/splash.dart';

import 'constants/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(WelingkarApp());
}

class WelingkarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welingkar App',
      theme: ThemeData.light().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: kWeSchoolThemeColor),
            color: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
          )),
      home: Splash(),
    );
  }
}
