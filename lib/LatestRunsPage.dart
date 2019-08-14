import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'API.dart';
import 'LeaderboardPage.dart';
import 'DetailedRunPage.dart';

class LatestRunsPage extends StatefulWidget {
  @override
  _LatestRunsPageState createState() => _LatestRunsPageState();
}

class _LatestRunsPageState extends State<LatestRunsPage> {
  Future<List<Run>> runs = fetchLatestRuns();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Run>>(
      future: fetchLatestRuns(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: Theme.of(context).primaryColor,
                  margin: EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 2.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailedRunPage(
                              snapshot.data[index].game.name,
                              snapshot.data[index].category.name,
                              snapshot.data[index].level,
                              snapshot.data[index].player,
                              snapshot.data[index].realtime,
                              snapshot.data[index].igt,
                              snapshot.data[index].date,
                              snapshot.data[index].comment,
                              snapshot.data[index].videoLinks),
                        ),
                      );
                    },
                    child: Container(
                      color: Theme.of(context).primaryColorLight,
                      child: _RunInfo(
                        snapshot.data[index].game,
                        snapshot.data[index].category,
                        snapshot.data[index].level,
                        snapshot.data[index].player,
                        snapshot.data[index].date,
                        snapshot.data[index].realtime,
                        snapshot.data[index].igt,
                        snapshot.data[index].leaderboardURL,
                      ),
                    ),
                  ),
                );
              },
            ),
            onRefresh: _handleRefresh,
          );
        } else if (snapshot.hasError) {
          return Container(
            child: Text('${snapshot.error}'),
            padding: EdgeInsets.all(8.0),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(new Duration(seconds: 2));

    setState(() {
      runs = fetchLatestRuns();
    });

    return null;
  }
}

class _RunInfo extends StatelessWidget {
  final Game game;
  final Category category;
  final Level level;
  final Player player;
  final String date;
  final String rta;
  final String igt;
  final String leaderboardURL;

  _RunInfo(this.game, this.category, this.level, this.player, this.date,
      this.rta, this.igt, this.leaderboardURL);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: SizedBox(
                height: 100.0,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: CachedNetworkImage(
                    imageUrl: game.assets.coverURL,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LeaderboardPage(
                        game.name, category.name, level, leaderboardURL)),
              );
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  category.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  level != null ? level.name : '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  rta != '0s' ? 'RTA — $rta' : 'No RTA',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.right,
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  igt != '0s' ? 'IGT — $igt' : 'No IGT',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.right,
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  player.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(hexToColor(player.color)),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
