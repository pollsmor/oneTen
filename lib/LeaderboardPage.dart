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

class HexToColor extends Color {
  static _hexToColor(String code) {
    return int.parse(code.substring(1), radix: 16) + 0xFF000000;
  }

  HexToColor(final String code) : super(_hexToColor(code));
}

class LeaderboardPage extends StatelessWidget {
  final String abbreviation;
  final String leaderboardURL;

  LeaderboardPage(this.abbreviation, this.leaderboardURL);

  @override
  Widget build(BuildContext context) {
    print(leaderboardURL);

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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder<Game>(
              future: fetchGame(abbreviation),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return _GameInfo(
                    snapshot.data.name,
                    snapshot.data.releaseDate,
                    snapshot.data.ruleset,
                    snapshot.data.moderators,
                    snapshot.data.assets,
                    snapshot.data.regions,
                    snapshot.data.platforms,
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return Text('');
              },
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          Expanded(
            child: FutureBuilder<Leaderboard>(
              future: getLeaderboard(leaderboardURL),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.runs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: _LBRunInfo(
                          ordinal(snapshot.data.runs[index].placing),
                          snapshot.data.players[index],
                          snapshot.data.runs[index].realtime,
                          snapshot.data.runs[index].igt,
                          snapshot.data.runs[index].date,
                          snapshot.data.runs[index].videoLinks,
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return Text('');
              },
            ),
          ),
        ],
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
    String modNames = '';
    for (int i = 0; i < moderators.length; ++i)
      modNames += (moderators[i].name + ', ');
    modNames = modNames.substring(0, modNames.length - 2);

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
              Padding(padding: EdgeInsets.all(4.0)),
              Text(
                'Moderators: $modNames',
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

class _LBRunInfo extends StatelessWidget {
  final String placing;
  final Player player;
  final String realtime;
  final String igt;
  final String date;
  final List<String> videoLinks;

  _LBRunInfo(this.placing, this.player, this.realtime, this.igt, this.date,
      this.videoLinks);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Text(placing),
            padding: EdgeInsets.all(8.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Text(
              player.name,
              style: TextStyle(
                color: Color(HexToColor._hexToColor(player.color)),
              ),
            ),
            padding: EdgeInsets.all(8.0),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            child: Text(realtime),
            padding: EdgeInsets.all(8.0),
          ),
        ),
        igt != '0s'
            ? Expanded(
                flex: 3,
                child: Container(
                  child: Text(igt),
                  padding: EdgeInsets.all(8.0),
                ),
              )
            : Text(''),
        Expanded(
          flex: 3,
          child: Container(
            child: Text(date),
            padding: EdgeInsets.all(8.0),
          ),
        ),
      ],
    );
  }
}
