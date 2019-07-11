import "package:flutter/material.dart";

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Dark theme"),
          trailing: Switch(
            activeColor: Colors.blue,
            value: false,
          ),
        ),
      ],
    );
  }
}