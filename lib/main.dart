import 'package:flutter/material.dart';

import 'HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'oneTen',
      home: HomePage(),
      theme: ThemeData(
        fontFamily: 'Rubik',
        primaryColor: Color(0xfff2f2f2),
        primaryColorLight: Colors.white,
        scaffoldBackgroundColor: Color(0xfff2f2f2),
        dialogBackgroundColor: Color(0xfff2f2f2),
        dividerColor: Color(0xfff2f2f2),
        buttonTheme: ButtonThemeData(
          height: 40.0,
          minWidth: 30.0,
          buttonColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
