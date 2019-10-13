import 'package:flutter/material.dart';

import 'FavoritesPage.dart';
import 'LatestRunsPage.dart';
import 'API.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Search stuff
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('oneTen');
  List<LiteGame> filteredGames = List<LiteGame>();
  String _searchText = '';
  Stopwatch stopwatch = Stopwatch();

  int _selectedIndex = 0;
  bool searching = false;

  final List<Widget> _pages = [
    FavoritesPage(),
    LatestRunsPage(),
  ];

  _HomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = '';
        });
      } else {
        setState(() {
          searching = true;
          stopwatch.start();
          _searchText = _filter.text;
          if (_searchText.length >= 3 &&
              stopwatch.elapsedMilliseconds >= 1000) {
            stopwatch.reset();
            _search();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        leading: IconButton(
          icon: _searchIcon,
          onPressed: () {
            setState(
              () {
                if (this._searchIcon.icon == Icons.search) {
                  this._searchIcon = Icon(Icons.close);
                  this._appBarTitle = TextField(
                    controller: _filter,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  );
                } else {
                  stopwatch.stop();
                  searching = false;
                  filteredGames.clear();
                  this._searchIcon = Icon(Icons.search);
                  this._appBarTitle = Text('oneTen');
                  _filter.clear();
                }
              },
            );
          },
        ),
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: searching
          ? ListView.builder(
              itemCount: filteredGames.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredGames[index].name),
                );
              },
            )
          : IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Color(0xff098bdd),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _search() async {
    List<LiteGame> tempList = List<LiteGame>();

    List<LiteGame> gamesList = await searchGames(_searchText);
    for (LiteGame game in gamesList) {
      tempList.add(game);
    }

    setState(() {
      filteredGames = tempList;
    });
  }
}
