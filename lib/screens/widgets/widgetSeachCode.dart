import 'package:flutter/material.dart';

class WidgetSeachCode extends StatefulWidget {
  WidgetSeachCode({Key key}) : super(key: key);

  @override
  _WidgetSeachCodeState createState() => _WidgetSeachCodeState();
}

class _WidgetSeachCodeState extends State<WidgetSeachCode> {

  String codigoBar="";
  TextStyle textStyle = new TextStyle(fontSize: 30.0);
  TextEditingController controllerTextEdit_comparacion;
  bool buscando=false;

   @override
  void dispose() {
    controllerTextEdit_comparacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title: Text("Buscar")),
       body: _body(),
    );
  }

  Widget _body(){
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, 
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) =>codigoBar=value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Código"),
              style: textStyle,
              controller: controllerTextEdit_comparacion,
            ),
            buscando==false?RaisedButton(
              onPressed: () {
                setState(() {
                  buscando=true;
                });
              },
              child: Text("Buscar"),
            ):CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}