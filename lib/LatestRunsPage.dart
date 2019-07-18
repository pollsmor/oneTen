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
  String category;
  String runner;
  String date;
  String time;

  _RunInfo(this.gameName, this.category, this.runner, this.date, this.time);

  @override
  Widget build(BuildContext context) {
    return Text("lol");
  }
}

class LatestRunsPage extends StatelessWidget {
  Future<List<LatestRun>> latestRuns = getLatestRuns();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<LatestRun>>(
        future: latestRuns,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
