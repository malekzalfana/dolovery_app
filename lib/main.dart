import 'dart:core';
import 'package:device_preview/device_preview.dart';
import 'package:dolovery_app/screens/myhomepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';


void main() {
  runApp(
    DevicePreview(enabled:false,builder:(context)=> MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black45);

    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

        return ResponsiveSizer(
          child: MaterialApp(
            builder: DevicePreview.appBuilder,
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
