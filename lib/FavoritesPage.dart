import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'LeaderboardPage.dart';

List<String> favorites = List<String>();

void readFavorites() async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/favorites.txt');
  Stream<List> stream = file.openRead();
  List<String> tempList = List();

  stream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen(
    (String line) {
      tempList.add(line);
    },
  );

  favorites = tempList;
}

void addFavorite(String leaderboardURL, String coverURL) async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/favorites.txt');
  var sink = file.openWrite(mode: FileMode.append);
  sink.write('$leaderboardURL,$coverURL\n');

  sink.close();
}

void removeFavorite(String gameID) async {
  final directory = await getApplicationDocumentsDirectory();
  File file = File('${directory.path}/favorites.txt');
  favorites.removeWhere((item) =>
      item.substring(item.indexOf('leaderboards') + 13,
          item.indexOf('leaderboards') + 21) ==
      gameID);
  print(favorites);

  var sink = file.openWrite();
  sink.write('');
  sink = file.openWrite(mode: FileMode.append);
  for (String favorite in favorites) {
    sink.write('$favorite');
  }

  sink.close();
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
    return GridView.count(
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
    );
  }
}
