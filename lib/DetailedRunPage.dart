import 'package:flutter/material.dart';

import 'API.dart';

class DetailedRunPage extends StatelessWidget {
  final String gameName;
  final Category category;
  final String leaderboardURL;

  DetailedRunPage(this.gameName, this.category, this.leaderboardURL);

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
    );
  }
}
