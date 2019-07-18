import "package:flutter/material.dart";
import "FavoritesPage.dart";
import "LatestRunsPage.dart";
import "Settings.dart";

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    FavoritesPage(),
    LatestRunsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: bottomNavBar(),
      backgroundColor: Color.fromRGBO(237, 240, 242, 1),
    );
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          title: Text("Favorites"),
          icon: Icon(Icons.favorite_border),
        ),
        BottomNavigationBarItem(
          title: Text("Latest Runs"),
          icon: Icon(Icons.videogame_asset),
        ),
        BottomNavigationBarItem(
          title: Text("Settings"),
          icon: Icon(Icons.settings),
        ),
      ],
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}