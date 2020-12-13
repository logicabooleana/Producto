import 'package:Producto/utils/dynamicTheme_lb.dart';
import 'package:flutter/material.dart';



class PageThemePreferences extends StatefulWidget {
  PageThemePreferences({Key key}) : super(key: key);

  @override
  _PageThemePreferencesState createState() => _PageThemePreferencesState();
}

class _PageThemePreferencesState extends State<PageThemePreferences> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preferencias"),),
      body: ListView(
        children: <Widget>[
          DynamicTheme.of(context).getViewSelectTheme(context),
        ],
      ),
    );
  }
}
