import 'package:flutter/material.dart';

import 'API.dart';
import 'LeaderboardPage.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('oneTen'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8.0),
        children: List.generate(100, (index) {
          return GestureDetector(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaderboardPage(
                    'Metroid: Zero Mission',
                    '100% Normal',
                    null,
                    'https://www.speedrun.com/api/v1/leaderboards/m1zjpm60/category/7kjp9xk3?embed='
                        'game.levels,game.categories,game.moderators,'
                        'game.platforms,game.regions,category,level,variables,players',
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
