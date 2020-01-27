import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'LeaderboardPage.dart';

List<String> favorites = List<String>();

void readFavorites() async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/favorites.txt');
  favorites = file.readAsLinesSync();
}

void addFavorite(String leaderboardURL, String coverURL) async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/favorites.txt');
  var sink = file.openWrite(mode: FileMode.append);
  sink.write('$leaderboardURL,$coverURL\n');

  sink.close();

  readFavorites();
}

void removeFavorite(String gameID) async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/favorites.txt');

  favorites.removeWhere((item) =>
      item.substring(item.indexOf('leaderboards') + 13,
          item.indexOf('leaderboards') + 21) ==
      gameID);

  file.writeAsStringSync('');
  for (String favorite in favorites) {
    file.writeAsStringSync('$favorite\n', mode: FileMode.append);
  }

  readFavorites();
}

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    readFavorites();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GridView.count(
        crossAxisCount: 3,
        padding: EdgeInsets.all(8.0),
        children: List.generate(
          favorites.length,
          (index) {
            return GestureDetector(
              child: Container(
                child: CachedNetworkImage(
                  imageUrl: favorites[index].split(',')[1],
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                margin: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 16.0),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LeaderboardPage('${favorites[index].split(',')[0]}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
