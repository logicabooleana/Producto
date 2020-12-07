import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final double height;

  AnimatedProgressbar({Key key, @required this.value, this.height = 12})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: EdgeInsets.all(10),
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _colorGen(value),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Always round negative or NaNs to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  _colorGen(double value) {
    int rbg = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rbg).withRed(255 - rbg);
  }
}

PreferredSize linearProgressBarApp({Color color = Colors.purple}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(0.0),
      child: LinearProgressIndicator(
          minHeight: 6.0,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: new AlwaysStoppedAnimation<Color>(color)));
}

class WidgetsLoad extends StatelessWidget {
  const WidgetsLoad({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.grey;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, radius: 24.0),
        dense: true,
        title: Text("        ",
            style: TextStyle(fontSize: 30.0, backgroundColor: Colors.grey)),
        trailing: Column(
          children: <Widget>[
            Text("              ", style: TextStyle(backgroundColor: color)),
            SizedBox(
              height: 5.0,
            ),
            Text("              ", style: TextStyle(backgroundColor: color)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

// ignore: must_be_immutable
class WidgetLoadingInit extends StatelessWidget {
  bool appbar;
  WidgetLoadingInit({this.appbar = false});

  @override
  Widget build(BuildContext buildContext) {
    Color color = Theme.of(buildContext).brightness == Brightness.dark
        ? Colors.white54
        : Colors.black38;
    Color color1 = Colors.black12;//Theme.of(buildContext).canvasColor.withOpacity(0.50);
    Color color2 = Colors.grey;
    return Scaffold(
      appBar: appbar
          ? AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(buildContext).canvasColor,
              iconTheme: Theme.of(buildContext).iconTheme.copyWith(
                  color: Theme.of(buildContext).textTheme.bodyText1.color),
              title: InkWell(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Shimmer.fromColors(
                    baseColor: color1,
                    highlightColor: color2,
                    child: Row(
                      children: <Widget>[
                        Text("Mi catálogo",
                            style: TextStyle(
                                color: Theme.of(buildContext)
                                    .textTheme
                                    .bodyText1
                                    .color),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                      baseColor: color1,
                      highlightColor: color2,
                      child: Icon(Icons.brightness_4)),
                )
              ],
            )
          : null,
      body: Shimmer.fromColors(
        baseColor: color1,
        highlightColor: color2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                splashColor: Theme.of(buildContext).primaryColor,
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 0.2, color: color),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Image(
                      color: color,
                      height: 200.0,
                      width: 200.0,
                      image: AssetImage('assets/barcode.png'),
                      fit: BoxFit.contain),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: Text("Escanea un producto para conocer su precio",
                    style: TextStyle(
                        fontFamily: "POPPINS_FONT",
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 24.0),
                    textAlign: TextAlign.center),
              ),
              RaisedButton(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  color: Colors.deepPurple[200],
                  child: Text("Buscar",
                      style:
                          TextStyle(fontSize: 24.0, color: Colors.deepPurple)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.transparent)),
                  onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
