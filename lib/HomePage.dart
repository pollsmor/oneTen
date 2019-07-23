import "package:flutter/material.dart";
import "FavoritesPage.dart";
import "LatestRunsPage.dart";

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [
    FavoritesPage(),
    LatestRunsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: bottomNavBar(),
      backgroundColor: Colors.white,
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
