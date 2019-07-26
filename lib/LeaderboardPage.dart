import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'API.dart';

class LeaderboardPage extends StatelessWidget {
  final String gameName;
  final String leaderboardURL;
  final bool isLevel;
  final Future<Leaderboard> leaderboard;

  LeaderboardPage(this.gameName, this.leaderboardURL, this.isLevel)
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
        title: Text(
          gameName,
          overflow: TextOverflow.ellipsis,
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
          future: leaderboard,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  SizedBox(
                    height: 300.0,
                    child: Container(
                      child: _GameInfo(
                        snapshot.data.game.name,
                        snapshot.data.game.releaseDate,
                        snapshot.data.game.ruleset,
                        snapshot.data.game.moderators,
                        snapshot.data.game.assets,
                        snapshot.data.regions,
                        snapshot.data.platforms,
                        snapshot.data.yearPlatforms,
                      ),
                    ),
                  ),
                  /*
                  ListView.builder(
                    itemCount: snapshot.data.runs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.5),
                      );
                    },
                  ),
                  */
                ],
              );
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

class _GameInfo extends StatelessWidget {
  final String name;
  final String releaseDate;
  final Ruleset ruleset;
  final List<Player> moderators;
  final Assets assets;
  final List<String> regions;
  final List<String> platforms;
  final List<String> yearPlatforms;

  _GameInfo(this.name, this.releaseDate, this.ruleset, this.moderators,
      this.assets, this.regions, this.platforms, this.yearPlatforms);

  Widget build(BuildContext context) {
    return Text('lol');
  }
}
