import 'dart:core';

import 'package:dolovery_app/screens/myhomepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black45);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ResponsiveSizer(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dolovery',
        theme: ThemeData(
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
          fontFamily: "Axiforma",
          primarySwatch: Colors.red,
        ),
        home: MyHomePage(title: 'Homepage'),
      ),
    );
  }
}
