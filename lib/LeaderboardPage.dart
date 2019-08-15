import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';
import 'DetailedRunPage.dart';

class LeaderboardPage extends StatelessWidget {
  final String gameName;
  final String categoryName;
  final Level level;
  final String leaderboardURL;
  final Future<Leaderboard> leaderboard;

  LeaderboardPage(
      this.gameName, this.categoryName, this.level, this.leaderboardURL)
      : leaderboard = fetchLeaderboard(leaderboardURL);

  @override
  Widget build(BuildContext context) {
    print(leaderboardURL);

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              gameName,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              level != null
                  ? categoryName + ' (' + level.name + ')'
                  : categoryName,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Leaderboard>(
        future: leaderboard,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                _GameInfo(
                  snapshot.data.game,
                  snapshot.data.category,
                  snapshot.data.level,
                ),
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
                        flex: 4,
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
                        child: Material(
                          child: InkWell(
                            child: _LBRunInfo(
                              ordinal(snapshot.data.runs[index].place),
                              snapshot.data.players[index],
                              snapshot.data.runs[index].realtime,
                              snapshot.data.runs[index].igt,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedRunPage(
                                    snapshot.data.game.name,
                                    snapshot.data.category.name,
                                    snapshot.data.level,
                                    snapshot.data.runs[index].id,
                                  ),
                                ),
                              );
                            },
                          ),
                          color: Colors.transparent,
                        ),
                        color: Theme.of(context).primaryColorLight,
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Container(
              child: Text('${snapshot.error}'),
              padding: EdgeInsets.all(8.0),
            );
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
  final Level level;

  _GameInfo(this.game, this.category, this.level);

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
                  height: 75.0,
                  child: CachedNetworkImage(
                    imageUrl: game.assets.coverURL,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Released: ' + game.releaseDate,
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Text(
                      'Regions: ' +
                          (game.regions.toString() != '[]'
                              ? game.regions.toString().substring(
                                  1, game.regions.toString().length - 1)
                              : 'N/A'),
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Text(
                      'Platforms: ' +
                          (game.platforms.toString() != '[]'
                              ? game.platforms.toString().substring(
                                  1, game.platforms.toString().length - 1)
                              : 'N/A'),
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 6.0),
              child: MaterialButton(
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
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 6.0),
              child: MaterialButton(
                child: Text('View ruleset'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => SimpleDialog(
                      backgroundColor: Theme.of(context).primaryColor,
                      children: [
                        Text('  Verification required: ' +
                            (game.ruleset.reqVerification == false
                                ? 'Yes'
                                : 'No')),
                        Text('  Video required: ' +
                            (game.ruleset.reqVideo == false ? 'Yes' : 'No')),
                        Text('  Default timing method: ' +
                            game.ruleset.defaultTime),
                        Text('  Emulators allowed: ' +
                            (game.ruleset.emusAllowed == false ? 'Yes' : 'No')),
                      ],
                    ),
                  );
                },
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ],
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
          flex: 4,
          child: Container(
            child: !player.isGradient
                ? Text(
                    player.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(hexToColor(player.color)),
                      fontSize: 16.0,
                    ),
                  )
                : GradientText(
                    player.name,
                    gradient: LinearGradient(
                      colors: [
                        Color(hexToColor(player.colorFrom)),
                        Color(hexToColor(player.colorTo)),
                      ],
                    ),
                    style: TextStyle(
                      fontSize: 16.0,
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
