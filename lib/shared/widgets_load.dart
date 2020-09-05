import 'package:flutter/material.dart';

class WidgetsLoad extends StatelessWidget {
  const WidgetsLoad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color color =Colors.grey;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor:color,radius: 24.0),
        dense: true,
        title: Text("        ",style: TextStyle(fontSize: 30.0,backgroundColor: Colors.grey)),
        trailing: Column(
          children: <Widget>[
            Text("              ",style: TextStyle(backgroundColor:color)),
            SizedBox(height:5.0,),
            Text("              ",style: TextStyle(backgroundColor:color)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
