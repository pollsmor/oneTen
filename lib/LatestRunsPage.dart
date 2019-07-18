import "dart:convert";

import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import "package:cached_network_image/cached_network_image.dart";

import "API.dart";

Future<List<LatestRun>> getLatestRuns() async {
  final response = await http.get(baseurl +
      "/runs?status=verified&orderby=verify-date&direction=desc&embed=game,category,players");

  if (response.statusCode == 200) {
    return compute(parseLatestRuns, response.body);
  }

  throw Exception("Failed to load the latest runs.");
}

List<LatestRun> parseLatestRuns(String responseBody) {
  var parsed = json.decode(responseBody)["data"] as List;

  return parsed.map((i) => LatestRun.fromJson(i)).toList();
}

class _RunInfo extends StatelessWidget {
  String gameName;
  String coverURL;
  String category;
  String runner;
  String date;
  String realtime;
  String igt;

  _RunInfo(this.gameName, this.coverURL, this.category, this.runner, this.date,
      this.realtime, this.igt);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
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
                        runner + " ― " + date,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Text(
                        gameName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 4.0)),
                      Text(
                        category,
                        style: TextStyle(
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
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Real time ― $realtime",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
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
                  return Column(
                    children: [
                      SizedBox(
                        height: 250.0,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(6.0, 6.0, 6.0, 0.0),
                          color: Colors.white,
                          child: _RunInfo(
                            snapshot.data[index].game.name,
                            snapshot.data[index].game.coverURL,
                            snapshot.data[index].category.name,
                            snapshot.data[index].player.name,
                            snapshot.data[index].date,
                            snapshot.data[index].realtime,
                            snapshot.data[index].igt,
                          ),
                        ),
                      ),
                    ],
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
    await Future.delayed(new Duration(seconds: 3));

    setState(() {
      latestRuns = getLatestRuns();
    });

    return null;
  }
}
