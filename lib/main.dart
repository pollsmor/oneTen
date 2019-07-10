import "package:flutter/material.dart";
import "HomePage.dart";
import "API.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final Future<Leaderboard> leaderboard = getLeaderboard();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'oneTen',
      home: HomePage(),
    );
  }
}