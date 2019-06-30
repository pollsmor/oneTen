import "package:flutter/material.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'oneTen',
      home: FavoritesPage(),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
      ),
      backgroundColor: Colors.white,
      body: GridView.extent(
        maxCrossAxisExtent: width / 2,
        padding: EdgeInsets.all(12.0),
        crossAxisSpacing: 12.0,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/fusion_box_art.jpg"),
                  ),
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.blue,
                ),
              ),
              Positioned(
                bottom: 16,
                left: 48,
                child: Text(
                  "Metroid Fusion",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
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
    );
  }
}
