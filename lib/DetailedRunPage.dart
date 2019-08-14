import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';

class DetailedRunPage extends StatelessWidget {
  final String gameName;
  final String categoryName;
  final Level level;
  final List<String> videoLinks;
  final String comment;
  final String verifyDate;
  final Player player;
  final String date;
  final DateTime submitted;
  final String realtime;
  final String igt;
  final bool emulated;
  final String region;
  final String platform;

  DetailedRunPage(
    this.gameName,
    this.categoryName,
    this.level,
    this.videoLinks,
    this.comment,
    this.verifyDate,
    this.player,
    this.date,
    this.submitted,
    this.realtime,
    this.igt,
    this.emulated,
    this.region,
    this.platform,
  );

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
              level != null
                  ? categoryName + ' (' + level.name + ')'
                  : categoryName,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
      body: Column(
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
                      child: player.countrycode != ''
                          ? Image.asset(
                              'icons/flags/png/' + player.countrycode + '.png',
                              package: 'country_icons')
                          : Text(''),
                    ),
                    Padding(padding: EdgeInsets.all(4.0)),
                    !player.isGradient
                        ? Text(
                            player.name,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(hexToColor(player.color)),
                              fontSize: 16.0,
                            ),
                          )
                        : GradientText(
                            player.name,
                            gradient: LinearGradient(
                              colors: [
                                Color(hexToColor(player.colorFrom)),
                                Color(hexToColor(player.colorTo)),
                              ],
                            ),
                            style: TextStyle(
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
                      style: TextStyle(),
                    ),
                    Padding(
                        child: Text(
                          '/',
                          style: TextStyle(),
                        ),
                        padding: EdgeInsets.all(4.0)),
                    Text(
                      igt != '0s' ? 'IGT — $igt' : 'No IGT',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  'Platform: ' +
                      (platform != '' ? platform : 'N/A') +
                      (emulated ? '(emulated)' : ''),
                  textAlign: TextAlign.left,
                ),
                Padding(padding: EdgeInsets.all(4.0)),
                Text(
                  'Region: ' + (region != '' ? region : 'N/A'),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Divider(
            height: 4.0,
          ),
          Padding(
            child: Text(
              'Evidence',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            padding: EdgeInsets.only(top: 8.0),
          ),
          videoLinks != null
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: MaterialButton(
                        height: 45.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(videoLinks[0]),
                        color: Theme.of(context).primaryColorLight,
                        onPressed: () {
                          _launchURL(videoLinks[0]);
                        },
                      ),
                    ),
                    1 < videoLinks.length
                        ? Container(
                            margin: EdgeInsets.all(8.0),
                            child: MaterialButton(
                              height: 45.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(videoLinks[1]),
                              color: Theme.of(context).primaryColorLight,
                              onPressed: () {
                                _launchURL(videoLinks[1]);
                              },
                            ),
                          )
                        : Container(),
                    2 < videoLinks.length
                        ? Container(
                            margin: EdgeInsets.all(8.0),
                            child: MaterialButton(
                              height: 45.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Text(videoLinks[2]),
                              color: Theme.of(context).primaryColorLight,
                              onPressed: () {
                                _launchURL(videoLinks[2]);
                              },
                            ),
                          )
                        : Container(),
                  ],
                )
              : Container(),
          Divider(
            height: 4.0,
          ),
          Padding(padding: EdgeInsets.all(4.0)),
          Container(
            child: Text(
              comment != '' ? '$comment' : 'No comment',
              textAlign: TextAlign.left,
            ),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
          ),
          Padding(padding: EdgeInsets.all(4.0)),
          Text(
            'Played on $date',
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          Padding(padding: EdgeInsets.all(4.0)),
          Text(
            'Submitted on ' + submitted.toString().substring(0, 10),
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
          Padding(padding: EdgeInsets.all(4.0)),
          Text(
            'Verified on ' + verifyDate.substring(0, 10),
            style: TextStyle(
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
