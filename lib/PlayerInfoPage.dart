import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gradient_text/gradient_text.dart';

import 'API.dart';

class PlayerInfoPage extends StatelessWidget {
  final Player player;

  PlayerInfoPage(this.player);

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
      body: Center(
        child: Text(player.name),
      ),
    );
  }
}
