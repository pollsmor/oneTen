import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Icon(
              Icons.search,
            ),
            Padding(padding: EdgeInsets.all(4.0)),
            Text(
              'Search...',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Text('lol'),
      ),
    );
  }
}
