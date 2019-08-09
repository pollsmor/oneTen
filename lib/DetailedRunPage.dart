import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'API.dart';

class DetailedRunPage extends StatelessWidget {
  final String gameName;
  final Category category;
  final String leaderboardURL;
  final int runIndex;

  DetailedRunPage(
      this.gameName, this.category, this.leaderboardURL, this.runIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              gameName,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Leaderboard>(
        future: fetchLeaderboard(leaderboardURL),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data.runs[runIndex].videoLinks);
            //Twitch: 8 / 7 aspect ratio
            return AspectRatio(
              aspectRatio: 1,
              child: WebView(
                initialUrl: snapshot.data.runs[runIndex].videoLinks[0],
                javascriptMode: JavascriptMode.unrestricted,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
