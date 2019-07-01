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
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        children: [
          Column(
            children: [
              SizedBox(
                width: 125.0,
                height: 125.0,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/fusion_box_art.jpg"),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.blue,
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
