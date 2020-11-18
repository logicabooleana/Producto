import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      child: CircularProgressIndicator(),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Loader(),
      ),
    );
  }
}
class LoadingInit extends StatelessWidget {
  bool appbar=true;
  LoadingInit({this.appbar=true});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.transparent,
          child: Scaffold(
            backgroundColor: Colors.transparent,
              appBar: this.appbar?AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                title: InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: <Widget>[
                        Text("Mi catálogo",
                            overflow: TextOverflow.ellipsis,
                            softWrap: false),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  Icon(Icons.brightness_4),
                ],
              ):PreferredSize(
                preferredSize: Size.fromHeight(5.0),
                child: Container(),

              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:BorderRadius.all(Radius.circular(30.0))),
                      child: Image(
                          height: 200.0,
                          width: 200.0,
                          image: AssetImage('assets/barcode.png'),
                          fit: BoxFit.contain),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text("Escanea un producto para conocer su precio",
                          style: TextStyle(
                              fontFamily: "POPPINS_FONT",
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0),
                          textAlign: TextAlign.center),
                    ),
                    /* RaisedButton(
                      padding:EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Text("Buscar",style: TextStyle(fontSize: 24.0, color: Colors.white)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.transparent)),
                      onPressed: () {
                      },
                    ), */
                  ],
                ),
              ),
            ),
          ),
    );
  }
}