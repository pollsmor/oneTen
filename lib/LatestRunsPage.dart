import "dart:convert";

import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import "package:http/http.dart" as http;
import "package:cached_network_image/cached_network_image.dart";

import "API.dart";

Future<List<LatestRun>> latestRuns = getLatestRuns();

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

class LatestRunsPage extends StatelessWidget {
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
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: snapshot.data[index].game.coverURL,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(snapshot.data[index].game.name),
                  subtitle: Text(snapshot.data[index].category.name),
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
