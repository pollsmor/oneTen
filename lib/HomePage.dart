import 'package:flutter/material.dart';
import 'FavoritesPage.dart';
import 'LatestRunsPage.dart';

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
      appBar: AppBar(
        title: Text(
          'oneTen',
          style: TextStyle(fontSize: 18.0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          title: Text(
            'Favorites',
          ),
          icon: Icon(Icons.favorite_border),
        ),
        BottomNavigationBarItem(
          title: Text('Latest Runs'),
          icon: Icon(Icons.videogame_asset),
        ),
      ],
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColorDark,
      selectedItemColor: Theme.of(context).accentColor,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
