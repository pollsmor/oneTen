import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

import 'FavoritesPage.dart';
import 'LatestRunsPage.dart';
import 'LeaderboardPage.dart';
import 'API.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    LatestRunsPage(),
    FavoritesPage(),
  ];

  //Search stuff
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon;
  Widget _appBarTitle;
  List _filteredStuff;
  String _searchText;
  Timer _debounceTimer;
  bool searching;

  @override
  void initState() {
    _selectedIndex = 0;

    _searchIcon = Icon(Icons.search);
    _appBarTitle = Text('oneTen');
    _filteredStuff = List();
    _searchText = '';
    searching = false;

    _filter.addListener(() {
      searching = true;
      if (_filter.text.isEmpty) {
        setState(() {
          searching = false;
          _searchText = '';
          _filteredStuff.clear();
        });
      } else {
        setState(() {
          _searchText = _filter.text;

          if (_debounceTimer != null) {
            _debounceTimer.cancel();
          }

          _debounceTimer = Timer(Duration(milliseconds: 500), () {
            if (_searchText.length >= 3) _search();
          });
        });
      }
    });

    super.initState();
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
                if (_searchIcon.icon == Icons.search) {
                  _searchIcon = Icon(Icons.close);
                  _appBarTitle = TextField(
                    controller: _filter,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                      border: InputBorder.none,
                    ),
                  );
                } else {
                  searching = false;
                  _filter.clear();
                  _searchIcon = Icon(Icons.search);
                  _appBarTitle = Text('oneTen');
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
              itemCount: _filteredStuff.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0),
                  padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                  child: ListTile(
                    leading: AspectRatio(
                      aspectRatio: 1.0,
                      child: CachedNetworkImage(
                        imageUrl: '${_filteredStuff[index].coverURL}',
                      ),
                    ),
                    title: Text('${_filteredStuff[index].name}'),
                    subtitle: Text(
                      'Game',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardPage(
                            '${_filteredStuff[index].leaderboardURL}',
                          ),
                        ),
                      );
                    },
                  ),
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
            title: Text('Latest Runs'),
            icon: Icon(Icons.videogame_asset),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Favorites',
            ),
            icon: Icon(Icons.favorite_border),
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

      //Get out of search if in it
      searching = false;
      _filter.clear();
      _searchIcon = Icon(Icons.search);
      _appBarTitle = Text('oneTen');
    });
  }

  void _search() async {
    List tempList = List();

    List gamesList = await searchGames(_searchText);
    for (LiteGame game in gamesList) {
      tempList.add(game);
    }

    setState(() {
      _filteredStuff = tempList;
    });
  }
}
