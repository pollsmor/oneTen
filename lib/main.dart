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
        primaryColor: Color(0xFF2962ff),
        primaryColorLight: Color(0xFF768fff),
        primaryColorDark: Color(0xFF0039cb),

        fontFamily: 'Rubik',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}