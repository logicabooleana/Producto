import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.widgets, size: 24),
            title: Padding(padding: EdgeInsets.all(0)),),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search, size: 24),
            title: Padding(padding: EdgeInsets.all(0)),),
        BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userCircle, size: 24),
            title: Padding(padding: EdgeInsets.all(0)),
            ),
      ].toList(),
      fixedColor:Theme.of(context).accentColor,
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // do nuttin
            break;
          case 1:
            Navigator.pushNamed(context, '/about');
            break;
          case 2:
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
    );
  }
}