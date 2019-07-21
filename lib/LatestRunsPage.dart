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
  final String playerColor;
  final String country;
  final String date;
  final String rta;
  final String igt;
  final String coverURL;

  _RunInfo(this.gameName, this.category, this.player, this.playerColor,
      this.country, this.date, this.rta, this.igt, this.coverURL);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: SizedBox(
              height: 150.0,
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
          flex: 7,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gameName,
                  maxLines: 2,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  category,
                  maxLines: 1,
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  "RTA — $rta",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  igt != "0 secs" ? "IGT — $igt" : "No IGT",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$date",
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Container(
                  child: Text(
                    country,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: Color.fromRGBO(210, 219, 224, 1),
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: EdgeInsets.all(4.0),
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  "$player",
                  maxLines: 2,
                  style: TextStyle(
                    color: Color(HexToColor._hexToColor(playerColor)),
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
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
                  return Container(
                    margin: EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Color.fromRGBO(210, 219, 224, 1),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: _RunInfo(
                      snapshot.data[index].game.name,
                      snapshot.data[index].category.name,
                      snapshot.data[index].player.name,
                      snapshot.data[index].player.color,
                      snapshot.data[index].player.country,
                      snapshot.data[index].date,
                      snapshot.data[index].realtime,
                      snapshot.data[index].igt,
                      snapshot.data[index].game.assets.coverURL,
                    ),
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
