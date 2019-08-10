import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'API.dart';

WebViewController _controller;

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
  final Game game;
  final Category category;
  final List<String> videoLinks;
  final String comment;
  final String verifyDate;
  final Player player;
  final String date;
  final String realtime;
  final String igt;
  final String region;
  final String platform;
  final String yearPlatform;

  DetailedRunPage(
      this.game,
      this.category,
      this.videoLinks,
      this.comment,
      this.verifyDate,
      this.player,
      this.date,
      this.realtime,
      this.igt,
      this.region,
      this.platform,
      this.yearPlatform);

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
              game.name,
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
      //Twitch: 8 / 7 aspect ratio
      body:
          //Twitch: 8 / 7 aspect ratio
          Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
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
                Padding(
                    child: Divider(
                      height: 4.0,
                    ),
                    padding: EdgeInsets.all(4.0)),
                Text(
                  comment,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            /*
                  child: WebView(
                    initialUrl: snapshot.data.runs[runIndex].videoLinks[0],
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (controller) {
                      _controller = controller;
                    },
                  ),
                  */
          ),
        ],
      ),
    );
  }
}
