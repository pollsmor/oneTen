import 'package:flutter/material.dart';

import 'API.dart';

class GameInfoPage extends StatelessWidget {
  final String leaderboardURL;
  final bool isLevel;
  final Future<Leaderboard> leaderboard;

  GameInfoPage(this.leaderboardURL, this.isLevel)
      : leaderboard = getLeaderboard(leaderboardURL, isLevel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<Leaderboard>(
          future: getLeaderboard(leaderboardURL, isLevel),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('lmao');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
