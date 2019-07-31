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
        primaryColorDark: Colors.black,
        accentColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
