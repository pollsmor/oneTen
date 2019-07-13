import "package:flutter/material.dart";
import "API.dart";
import "main.dart";

class LatestRunsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<LatestRun>>(
        future: MyApp.latestRuns,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  //leading: Image.network(snapshot.data[index].game.coverURL),
                  leading: Text(snapshot.data[index].game.abbreviation),
                  subtitle: Text(snapshot.data[index].category.rules ?? ""),
                  title: Text(snapshot.data[index].date),
                );
              }
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        }
      ),
    );
  }
}
