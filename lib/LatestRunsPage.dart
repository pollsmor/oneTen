import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

import "API.dart";

class HexToColor extends Color {
  static _hexToColor(String code) {
    return int.parse(code.substring(1), radix: 16) + 0xFF000000;
  }

  HexToColor(final String code) : super(_hexToColor(code));
}

class _RunInfo extends StatelessWidget {
  final String gameName;
  final String category;
  final String player;
  final String country;
  final String date;
  final String rta;
  final String igt;
  final String coverURL;

  _RunInfo(this.gameName, this.category, this.player, this.country, this.date,
      this.rta, this.igt, this.coverURL);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: SizedBox(
              height: 100.0,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: CachedNetworkImage(
                  imageUrl: coverURL,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameName,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$date",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  "$player",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LatestRunsPage extends StatefulWidget {
  @override
  _LatestRunsPageState createState() => _LatestRunsPageState();
}

class _LatestRunsPageState extends State<LatestRunsPage> {
  Future<List<LatestRun>> latestRuns = getLatestRuns();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<LatestRun>>(
        future: latestRuns,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return _RunInfo(
                    snapshot.data[index].game.name,
                    snapshot.data[index].category.name,
                    snapshot.data[index].player.name,
                    snapshot.data[index].player.country,
                    snapshot.data[index].date,
                    snapshot.data[index].realtime,
                    snapshot.data[index].igt,
                    snapshot.data[index].game.assets.coverURL,
                  );
                },
              ),
              onRefresh: _handleRefresh,
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(new Duration(seconds: 2));

    setState(() {
      latestRuns = getLatestRuns();
    });

    return null;
  }
}
