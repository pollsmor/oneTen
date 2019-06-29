import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'oneTen',
      home: Scaffold(
        body: Center(
          child: Text("oneTen"),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              title: Text("Favorites"),
              icon: Icon(Icons.favorite_border),
            ),
            BottomNavigationBarItem(
              title: Text("Games"),
              icon: Icon(Icons.videogame_asset),
            ),
            BottomNavigationBarItem(
              title: Text("Settings"),
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}