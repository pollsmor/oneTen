import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';

class DetailedRunPage extends StatelessWidget {
  final String runID;
  final Future<Run> run;

  DetailedRunPage(this.runID) : run = fetchRun(runID);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Run>(
      future: fetchRun(runID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
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
                    snapshot.data.game.name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    snapshot.data.level != null
                        ? snapshot.data.category.name +
                            ' (' +
                            snapshot.data.level.name +
                            ')'
                        : snapshot.data.category.name,
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
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
                                  : Container(),
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
                              child: RaisedButton(
                                child: Text(snapshot.data.videoLinks[0]),
                                onPressed: () {
                                  _launchURL(snapshot.data.videoLinks[0]);
                                },
                              ),
                            ),
                            1 < snapshot.data.videoLinks.length
                                ? Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text(snapshot.data.videoLinks[1]),
                                      onPressed: () {
                                        _launchURL(snapshot.data.videoLinks[1]);
                                      },
                                    ),
                                  )
                                : Container(),
                            2 < snapshot.data.videoLinks.length
                                ? Container(
                                    margin: EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text(snapshot.data.videoLinks[2]),
                                      onPressed: () {
                                        _launchURL(snapshot.data.videoLinks[2]);
                                      },
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : Padding(
                          child: Text('This run has no video evidence.'),
                          padding: EdgeInsets.all(8.0)),
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
                  snapshot.data.date != '' ? Text(
                    'Played on ' + snapshot.data.date,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ) : Container(),
                  Padding(padding: EdgeInsets.all(4.0)),
                  snapshot.data.submitted != null ? Text(
                    'Submitted on ' +
                        snapshot.data.submitted.toString().substring(0, 10),
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ) : Container(),
                  Padding(padding: EdgeInsets.all(4.0)),
                  snapshot.data.verifyDate != '' ? Text(
                    'Verified on ' + snapshot.data.verifyDate.substring(0, 10),
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ) : Container(),
                  Padding(padding: EdgeInsets.all(4.0)),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Center(
                child: !(snapshot.hasError)
                    ? CircularProgressIndicator()
                    : Container(
                        child: Text('${snapshot.error}'),
                        padding: EdgeInsets.all(8.0),
                      )),
          );
        }
      },
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
