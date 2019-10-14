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
  final ScrollController _scrollController = ScrollController();
  String nextPage;
  bool isLoading;
  List<LatestRun> runs;

  @override
  void initState() {
    nextPage = latestRunsUrl;
    isLoading = false;
    runs = List<LatestRun>();

    _getMoreData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: runs.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == runs.length) {
          return _buildProgressIndicator();
        } else {
          return Container(
            margin: EdgeInsets.fromLTRB(0.0, 1.0, 0.0, 1.0),
            padding: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Material(
              child: InkWell(
                child: _RunInfo(
                  runs[index].gameName,
                  runs[index].categoryName,
                  runs[index].levelName,
                  runs[index].player,
                  runs[index].realtime,
                  runs[index].igt,
                  runs[index].leaderboardURL,
                  runs[index].coverURL,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedRunPage('${runs[index].runID}'),
                    ),
                  );
                },
              ),
              color: Colors.transparent,
            ),
            color: Theme.of(context).primaryColor,
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

      final response = await http.get('$nextPage');

      LatestRuns latestRuns = LatestRuns.fromJson(json.decode(response.body));
      List<LatestRun> runsList = latestRuns.runs;
      nextPage = latestRuns.pagination.next;

      setState(() {
        isLoading = false;
        runs.addAll(runsList);
      });
    }
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
  final String gameName;
  final String categoryName;
  final String levelName;
  final Player player;
  final String rta;
  final String igt;
  final String leaderboardURL;
  final String coverURL;

  _RunInfo(this.gameName, this.categoryName, this.levelName, this.player,
      this.rta, this.igt, this.leaderboardURL, this.coverURL);

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
                    imageUrl: '$coverURL',
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
                    builder: (context) => LeaderboardPage('$leaderboardURL')),
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
                  '$gameName',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  '$categoryName',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  '$levelName',
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
                        '${player.name}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(hexToColor(player.color)),
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.right,
                      )
                    : GradientText(
                        '${player.name}',
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
