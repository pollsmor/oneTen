import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'API.dart';

String ordinal(int num) {
  if (num % 100 == 11)
    return num.toString() + 'th';
  else if (num % 100 == 12)
    return num.toString() + 'th';
  else if (num % 100 == 13)
    return num.toString() + 'th';
  else if (num % 10 == 1)
    return num.toString() + 'st';
  else if (num % 10 == 2)
    return num.toString() + 'nd';
  else if (num % 10 == 3) return num.toString() + 'rd';

  return num.toString() + 'th';
}

hexToColor(String code) {
  return int.parse(code.substring(1), radix: 16) + 0xFF000000;
}

class LeaderboardPage extends StatelessWidget {
  final String leaderboardURL;

  LeaderboardPage(this.leaderboardURL);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
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
      body: FutureBuilder<Leaderboard>(
        future: fetchLeaderboard(leaderboardURL),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _GameInfo(snapshot.data.game, snapshot.data.category,
                    snapshot.data.regions, snapshot.data.platforms),
                Container(
                  color: Theme.of(context).primaryColorLight,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Text('Rank'),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          child: Text('Player'),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Text('Real time'),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Text('In-game time'),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.runs.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.0,
                        color: Colors.white,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Theme.of(context).primaryColorLight,
                        child: _LBRunInfo(
                          ordinal(snapshot.data.runs[index].place),
                          snapshot.data.players[index],
                          snapshot.data.runs[index].realtime,
                          snapshot.data.runs[index].igt,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _GameInfo extends StatelessWidget {
  final Game game;
  final Category category;
  final List<String> regions;
  final List<String> platforms;

  _GameInfo(this.game, this.category, this.regions, this.platforms);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    imageUrl: game.assets.coverURL,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      game.name,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Text(
                      game.releaseDate,
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
          margin: EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 0.0),
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
                    ('$platforms' != '[]'
                        ? '$platforms'.substring(1, '$platforms'.length - 1)
                        : 'N/A'),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              MaterialButton(
                child: Text('View rules'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => SimpleDialog(
                      backgroundColor: Theme.of(context).primaryColor,
                      children: [
                        Container(
                          child: Text(category.rules),
                          color: Theme.of(context).primaryColor,
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                  );
                },
                color: Theme.of(context).primaryColorLight,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LBRunInfo extends StatelessWidget {
  final String placing;
  final Player player;
  final String realtime;
  final String igt;

  _LBRunInfo(this.placing, this.player, this.realtime, this.igt);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            child: Text(placing),
            padding: EdgeInsets.all(8.0),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            child: Text(
              player.name,
              style: TextStyle(
                color: Color(hexToColor(player.color)),
              ),
            ),
            padding: EdgeInsets.all(8.0),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: realtime != '0s' ? Text(realtime) : Text('--'),
            padding: EdgeInsets.all(8.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: igt != '0s' ? Text(igt) : Text('--'),
            padding: EdgeInsets.all(8.0),
          ),
        ),
      ],
    );
  }
}
