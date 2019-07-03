import "package:flutter/material.dart";

class FavoritesPage extends StatefulWidget {
  State createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: searchBar(),
      backgroundColor: Colors.white,
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
        crossAxisSpacing: 0,
        children: [
          Column(
            children: [
              SizedBox(
                width: 140.0,
                height: 140.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/fusion_box_art.jpg"),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  "Metroid Fusion",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: 140.0,
                height: 140.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/zm_box_art.jpeg"),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
                child: Text(
                  "Metroid: Zero Mission",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget searchBar() {
    return AppBar(
      elevation: 0.0,
      leading: Icon(
        Icons.search,
      ),
      title: Text(
        "Search for a game",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.white70,
        ),
      ),
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
