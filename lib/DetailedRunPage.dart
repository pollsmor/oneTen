import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'API.dart';

class HexToColor extends Color {
  static _hexToColor(String code) {
    return int.parse(code.substring(1), radix: 16) + 0xFF000000;
  }

  HexToColor(final String code) : super(_hexToColor(code));
}

String ordinal(int num) {
  if (num % 100 == 11)
    return num.toString() + 'th';
  else if (num % 100 == 12)
    return num.toString() + 'th';
  else if (num % 100 == 13)
    return num.toString() + 'th';
  else if (num % 10 == 1)
    return num.toString() + 'st';
  else if (num % 10 == 2)
    return num.toString() + 'nd';
  else if (num % 10 == 3) return num.toString() + 'rd';

  return num.toString() + 'th';
}

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
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: DetailedRunInfo(
                    snapshot.data.players[runIndex],
                    snapshot.data.runs[runIndex].placing,
                    snapshot.data.runs[runIndex].realtime,
                    snapshot.data.runs[runIndex].igt,
                    snapshot.data.runs[runIndex].comment,
                    snapshot.data.runs[runIndex].date,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1,
                  child: WebView(
                    initialUrl: snapshot.data.runs[runIndex].videoLinks[0],
                    javascriptMode: JavascriptMode.unrestricted,
                  ),
                ),
              ],
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

class DetailedRunInfo extends StatelessWidget {
  final Player player;
  final int placing;
  final String realtime;
  final String igt;
  final String comment;
  final String date;

  DetailedRunInfo(this.player, this.placing, this.realtime, this.igt,
      this.comment, this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.0,
              child: Image.asset('icons/flags/png/us.png',
                  package: 'country_icons'),
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              player.name,
              style: TextStyle(
                color: Color(HexToColor._hexToColor(player.color)),
                fontSize: 16.0,
              ),
            ),
            Text(
              ' (' + ordinal(placing) + ' place)',
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(4.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              realtime != '0s' ? 'RTA — $realtime' : 'No RTA',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            Padding(
                child: Text(
                  '/',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                padding: EdgeInsets.all(4.0)),
            Text(
              igt != '0s' ? 'IGT — $igt' : 'No IGT',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        Padding(padding: EdgeInsets.all(4.0)),
        Text(
          'Played on $date',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
        Padding(child: Divider(height: 4.0,), padding: EdgeInsets.all(4.0)),
        Text(
          comment,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
