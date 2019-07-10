import "package:flutter/material.dart";
import "FavoritesPage.dart";
import "GamesPage.dart";

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    FavoritesPage(),
    GamesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Favorites"),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: bottomNavBar(),
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
          title: Text("Games"),
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