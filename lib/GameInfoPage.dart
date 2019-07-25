import 'package:flutter/material.dart';

import 'API.dart';

class GameInfoPage extends StatelessWidget {
  final String leaderboardURL;
  final Future<Leaderboard> leaderboard;

  GameInfoPage(this.leaderboardURL) :
    leaderboard = getLeaderboard(leaderboardURL);

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
      ),
      body: Center(
        child: FutureBuilder<Leaderboard>(
          future: getLeaderboard(leaderboardURL),//leaderboard,
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
