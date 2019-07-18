import "package:flutter/material.dart";
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

import "HomePage.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarManager.setColor(Color.fromRGBO(210, 219, 224, 1), animated: false);
    FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);

    return MaterialApp(
      title: 'oneTen',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}