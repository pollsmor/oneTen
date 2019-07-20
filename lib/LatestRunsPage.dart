import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";
import "API.dart";

class _RunInfo extends StatelessWidget {
  final String gameName;
  final String coverURL;
  final String category;
  final String runner;
  final Color color;
  final String country;
  final String date;
  final String realtime;
  final String igt;

  _RunInfo(this.gameName, this.coverURL, this.category, this.runner, this.color,
      this.country, this.date, this.realtime, this.igt);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Text(
                        gameName,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(237, 240, 242, 1),
                          width: 4.0,
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: coverURL,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      child: Text("United States"),
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 4.0,
                          color: Color.fromRGBO(237, 240, 242, 1),
                        ),
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    Text(
                      runner,
                      style: TextStyle(
                        color: color,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(bottom: 4.0)),
                Text(
                  "Real time ― $realtime",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(padding: EdgeInsets.only(bottom: 4.0)),
                Text(
                  "In-game time ― $igt",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
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

class HexToColor extends Color {
  static _hexToColor(String code) {
    return int.parse(code.substring(1), radix: 16) + 0xFF000000;
  }

  HexToColor(final String code) : super(_hexToColor(code));
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
                  return InkWell(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width > 350
                              ? 250
                              : 350,
                          child: Container(
                            color: Colors.white,
                            margin: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
                            child: _RunInfo(
                              snapshot.data[index].game.name,
                              snapshot.data[index].game.coverURL,
                              snapshot.data[index].category.name,
                              snapshot.data[index].player.name,
                              HexToColor(snapshot.data[index].player.color),
                              snapshot.data[index].player.country,
                              snapshot.data[index].date,
                              snapshot.data[index].realtime,
                              snapshot.data[index].igt,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: _showRun()
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
