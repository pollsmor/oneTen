import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'LeaderboardPage.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      children: List.generate(100, (index) {
        return GestureDetector(
          child: Container(
            child: CachedNetworkImage(
              imageUrl:
                  'https://www.speedrun.com/themes/mzm/cover-256.png?version=',
            ),
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            color: Colors.blueAccent,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeaderboardPage(
                  'https://www.speedrun.com/api/v1/leaderboards/m1zjpm60/category/7kjp9xk3?embed='
                  'game.levels,game.categories,game.moderators,'
                  'game.platforms,game.regions,category,level,variables,players',
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
