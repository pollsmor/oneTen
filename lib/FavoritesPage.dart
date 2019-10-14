import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'LeaderboardPage.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> favorites = List<String>();

  @override
  void initState() {
    _readFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(8.0),
      children: List.generate(favorites.length, (index) {
        print(favorites[index].split(',')[1]);

        return GestureDetector(
          child: Container(
            child: CachedNetworkImage(
              imageUrl: favorites[index].split(',')[1],
            ),
            margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 16.0),
            color: Colors.blueAccent,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LeaderboardPage(
                  '${favorites[index].split(',')[0]}?embed='
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

  void _readFavorites() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/favorites.txt');
    Stream<List> stream = file.openRead();
    List<String> tempList = List();

    stream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(LineSplitter()) // Convert stream to individual lines.
        .listen(
      (String line) {
        print(line);
        tempList.add(line);
      },
    );

    setState(() {
      favorites = tempList;
    });
  }
}
