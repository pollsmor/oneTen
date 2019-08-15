import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';

class DetailedRunPage extends StatelessWidget {
  final String gameName;
  final String categoryName;
  final Level level;
  final String runID;

  DetailedRunPage(
    this.gameName,
    this.categoryName,
    this.level,
    this.runID,
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
              style: TextStyle(fontSize: 18.0),
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
      body: FutureBuilder<Run>(
        future: fetchRun(runID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
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
                              child: snapshot.data.player.countrycode != ''
                                  ? Image.asset(
                                      'icons/flags/png/' +
                                          snapshot.data.player.countrycode +
                                          '.png',
                                      package: 'country_icons')
                                  : Text(''),
                            ),
                            Padding(padding: EdgeInsets.all(4.0)),
                            !snapshot.data.player.isGradient
                                ? Text(
                                    snapshot.data.player.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Color(hexToColor(
                                          snapshot.data.player.color)),
                                      fontSize: 16.0,
                                    ),
                                  )
                                : GradientText(
                                    snapshot.data.player.name,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(hexToColor(
                                            snapshot.data.player.colorFrom)),
                                        Color(hexToColor(
                                            snapshot.data.player.colorTo)),
                                      ],
                                    ),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data.realtime != '0s'
                                  ? 'RTA — ' + snapshot.data.realtime
                                  : 'No RTA',
                              overflow: TextOverflow.ellipsis,
                            ),
                            Padding(
                                child: Text(
                                  '/',
                                  style: TextStyle(),
                                ),
                                padding: EdgeInsets.all(4.0)),
                            Text(
                              snapshot.data.igt != '0s'
                                  ? 'IGT — ' + snapshot.data.igt
                                  : 'No IGT',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        Text(
                          'Platform: ' +
                              (snapshot.data.platform != ''
                                  ? snapshot.data.platform
                                  : 'N/A') +
                              (snapshot.data.emulated ? ' (emulated)' : ''),
                        ),
                        Padding(padding: EdgeInsets.all(4.0)),
                        Text(
                          'Region: ' +
                              (snapshot.data.region != ''
                                  ? snapshot.data.region
                                  : 'N/A'),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 4.0),
                  Padding(
                    child: Text(
                      'Evidence',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    padding: EdgeInsets.only(top: 8.0),
                  ),
                  snapshot.data.videoLinks != null
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(8.0),
                              child: MaterialButton(
                                height: 45.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Text(snapshot.data.videoLinks[0]),
                                color: Theme.of(context).primaryColorLight,
                                onPressed: () {
                                  _launchURL(snapshot.data.videoLinks[0]);
                                },
                              ),
                            ),
                            1 < snapshot.data.videoLinks.length
                                ? Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      height: 45.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Text(snapshot.data.videoLinks[1]),
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      onPressed: () {
                                        _launchURL(snapshot.data.videoLinks[1]);
                                      },
                                    ),
                                  )
                                : Container(),
                            2 < snapshot.data.videoLinks.length
                                ? Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: MaterialButton(
                                      height: 45.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Text(snapshot.data.videoLinks[2]),
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      onPressed: () {
                                        _launchURL(snapshot.data.videoLinks[2]);
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                  Divider(height: 4.0),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Container(
                    child: Text(
                      snapshot.data.comment != ''
                          ? snapshot.data.comment
                          : 'No comment',
                      textAlign: TextAlign.left,
                    ),
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text(
                    'Played on ' + snapshot.data.date,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text(
                    'Submitted on ' +
                        snapshot.data.submitted.toString().substring(0, 10),
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Padding(padding: EdgeInsets.all(4.0)),
                  Text(
                    'Verified on ' + snapshot.data.verifyDate.substring(0, 10),
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return Center(child: CircularProgressIndicator());
        },
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
