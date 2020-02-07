import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';

class PlayerInfoPage extends StatelessWidget {
  final Player player;
  final Future<List<ProfileRun>> pbs;

  PlayerInfoPage(this.player): pbs = fetchPbs(player.pbs);

  Widget build(BuildContext context) {
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
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Padding(padding: EdgeInsets.all(4.0)),
                SizedBox(
                  height: 15.0,
                  child: '${player.countrycode}' != ''
                      ? Image.asset(
                      'icons/flags/png/${player.countrycode}.png',
                      package: 'country_icons')
                      : Container(),
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
          ),
        ],
      ),
    );
  }
}
