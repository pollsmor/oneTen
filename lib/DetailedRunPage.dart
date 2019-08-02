import 'package:flutter/material.dart';

class DetailedRunPage extends StatelessWidget {
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
              'Metroid: Zero Mission',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            Text(
              '100% Normal',
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
