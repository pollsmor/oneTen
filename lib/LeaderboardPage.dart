import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'API.dart';

class LeaderboardPage extends StatelessWidget {
  final String abbreviation;
  final String leaderboardURL;

  final Future<Leaderboard> leaderboard;
  final Future<Game> game;

  LeaderboardPage(this.abbreviation, this.leaderboardURL)
      : leaderboard = getLeaderboard(leaderboardURL),
        game = getGame(abbreviation);

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
          abbreviation,
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
          future: getLeaderboard(leaderboardURL),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    /*
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                        width: 1.0,
                      )),
                    ),
                    */
                    child: FutureBuilder<Game>(
                      future: getGame(snapshot.data.game.abbreviation),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          return _GameInfo(
                            snapshot2.data.name,
                            snapshot2.data.releaseDate,
                            snapshot2.data.ruleset,
                            snapshot2.data.moderators,
                            snapshot2.data.assets,
                            snapshot2.data.regions,
                            snapshot2.data.platforms,
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }

                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.runs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(0.0, 0.5, 0.0, 0.5),
                        );
                      },
                    ),
                  ),
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

  _GameInfo(this.name, this.releaseDate, this.ruleset, this.moderators,
      this.assets, this.regions, this.platforms);

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                child: SizedBox(
                  height: 100.0,
                  child: CachedNetworkImage(
                    imageUrl: assets.coverURL,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Text(
                      releaseDate,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Regions: ' +
                    ('$regions' != '[]'
                        ? '$regions'.substring(1, '$regions'.length - 1)
                        : 'N/A'),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(padding: EdgeInsets.all(4.0)),
              Text(
                'Platforms: ' +
                    ('$platforms'.substring(1, '$platforms'.length - 1)),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Mods: ' + ('$platforms'.substring(1, '$platforms'.length - 1)),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
