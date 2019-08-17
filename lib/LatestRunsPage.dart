import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';
import 'LeaderboardPage.dart';
import 'DetailedRunPage.dart';

class LatestRunsPage extends StatefulWidget {
  @override
  _LatestRunsPageState createState() => _LatestRunsPageState();
}

class _LatestRunsPageState extends State<LatestRunsPage> {
  String nextPage;
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  List<Run> runs = List<Run>();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: runs.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == runs.length) {
          return _buildProgressIndicator();
        } else {
          return InkWell(
            child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0),
              padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
              child: _RunInfo(
                runs[index].game,
                runs[index].category,
                runs[index].level,
                runs[index].player,
                runs[index].date,
                runs[index].realtime,
                runs[index].igt,
                runs[index].leaderboardURL,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedRunPage(
                    runs[index].game.name,
                    runs[index].category.name,
                    runs[index].level,
                    runs[index].id,
                  ),
                ),
              );
            },
          );
        }
      },
      controller: _scrollController,
    );
  }

  void _getMoreData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(nextPage);

      LatestRuns latestRuns = LatestRuns.fromJson(json.decode(response.body));
      List<Run> runsList = latestRuns.runs;
      nextPage = latestRuns.pagination.next;

      setState(() {
        isLoading = false;
        runs.addAll(runsList);
      });
    }
  }

  @override
  void initState() {
    nextPage = latestRunsUrl;
    this._getMoreData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
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
          flex: 4,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
              child: Container(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: CachedNetworkImage(
                    imageUrl: game.assets.coverURL,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                padding: EdgeInsets.all(4.0),
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
                  maxLines: 3,
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
                !player.isGradient
                    ? Text(
                        player.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(hexToColor(player.color)),
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.right,
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
                        textAlign: TextAlign.right,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
