import "package:flutter/material.dart";
import "API.dart";
import "main.dart";

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<Leaderboard>(
        future: MyApp.leaderboard,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.runs.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data.runs[index].comment),
                  //subtitle: Text(snapshot.data.runs[index].date),
                );
              }
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
