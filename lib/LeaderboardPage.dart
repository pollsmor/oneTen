import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';
import 'DetailedRunPage.dart';
import 'FavoritesPage.dart';

class LeaderboardPage extends StatefulWidget {
  final String leaderboardURL;

  LeaderboardPage(this.leaderboardURL);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String leaderboardURL;
  Future<Leaderboard> leaderboard;
  bool alreadySaved;
  String gameID;
  String currCategoryID;
  String currCategory;
  List<Category> categories;
  List<String> categoryNames = List<String>();

  @override
  void initState() {
    leaderboardURL = widget.leaderboardURL;
    print(leaderboardURL);
    leaderboard = fetchLeaderboard(leaderboardURL);
    gameID = leaderboardURL.substring(
        leaderboardURL.indexOf('leaderboards') + 13,
        leaderboardURL.indexOf('leaderboards') + 21);
    currCategoryID = leaderboardURL.substring(
        leaderboardURL.indexOf('leaderboards') + 31,
        leaderboardURL.indexOf('leaderboards') + 39);

    List<String> favGames = List<String>();
    for (String url in favorites) {
      favGames.add(url.substring(
          url.indexOf('leaderboards') + 13, url.indexOf('leaderboards') + 21));
    }

    alreadySaved = favGames.contains(gameID);

    fetchLeaderboard(leaderboardURL).then((data) {
      setState(() {
        categories = data.game.categories;
        for (int i = 0; i < categories.length; i++) {
          categoryNames.add(categories[i].name);
          if (categories[i].id == currCategoryID) {
            currCategory = categories[i].name;
          }
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Leaderboard>(
      future: leaderboard,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
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
                    '${snapshot.data.game.name}',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    snapshot.data.level != null
                        ? '${snapshot.data.category.name} (${snapshot.data.level.name})'
                        : '${snapshot.data.category.name}',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      if (alreadySaved == false) {
                        alreadySaved = true;
                        addFavorite('${widget.leaderboardURL}',
                            '${snapshot.data.game.assets.coverURL}');
                      } else {
                        alreadySaved = false;
                        removeFavorite(gameID);
                      }
                    });
                  },
                ),
              ],
            ),
            body: Column(
              children: [
                _GameInfo(
                  snapshot.data.game,
                  snapshot.data.category,
                  snapshot.data.level,
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(4.0)),
                      Text('Category'),
                      Padding(padding: EdgeInsets.all(4.0)),
                      DropdownButton<String>(
                          value: currCategory,
                          elevation: 16,
                          iconSize: 32,
                          style: TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          items: categoryNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String newCategory) {
                            setState(() {
                              currCategory = newCategory;
                              for (int i = 0; i < categories.length; i++) {
                                if (categories[i].name == currCategory) {
                                  currCategoryID = categories[i].id;
                                }
                              }

                              String newLeaderboardURL =
                                  "$baseurl/leaderboards/";
                              newLeaderboardURL +=
                                  (snapshot.data.game.id + "/");
                              newLeaderboardURL +=
                                  ("category/" + currCategoryID);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LeaderboardPage(newLeaderboardURL)));
                            });
                          })
                    ],
                  ),
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
                        color: Theme.of(context).primaryColorLight,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Material(
                          child: InkWell(
                            child: _LBRunInfo(
                              ordinal(snapshot.data.runs[index].place),
                              snapshot.data.players[index],
                              '${snapshot.data.runs[index].realtime}',
                              '${snapshot.data.runs[index].igt}',
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedRunPage(
                                      '${snapshot.data.runs[index].id}'),
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
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Center(
                child: !(snapshot.hasError)
                    ? CircularProgressIndicator()
                    : Container(
                        child: Text('${snapshot.error}'),
                        padding: EdgeInsets.all(8.0),
                      )),
          );
        }
      },
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
                    imageUrl: '${game.assets.coverURL}',
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Released: ${game.releaseDate}',
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Text(
                      'Regions: ' +
                          ('${game.regions}' != '[]'
                              ? '${game.regions}'
                                  .substring(1, '${game.regions}'.length - 1)
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
                          ('${game.platforms}' != '[]'
                              ? '${game.platforms}'
                                  .substring(1, '${game.platforms}'.length - 1)
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
              child: RaisedButton(
                child: Text('View rules'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => SimpleDialog(
                      children: [
                        Container(
                          child: Text(category.rules),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 6.0),
              child: RaisedButton(
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
