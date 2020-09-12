import 'package:flutter/material.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/screens/page_producto_view.dart';
import 'package:catalogo/screens/page_producto_new.dart';
import 'package:flutter/services.dart';

class WidgetSeachCode extends StatefulWidget {
  WidgetSeachCode({Key key}) : super(key: key);

  @override
  _WidgetSeachCodeState createState() => _WidgetSeachCodeState();
}

class _WidgetSeachCodeState extends State<WidgetSeachCode> {

  String codigoBar = "";
  TextStyle textStyle = new TextStyle(fontSize: 30.0);
  bool buscando = false;
  String textoTextResult = "";
  String texto = "";
  bool buttonAddProduct=false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Buscar")),
      body: _body(),
    );
  }

  Widget _body() {

    
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextField(
              //keyboardType: TextInputType.number,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.allow(new RegExp('[1234567890]'))],
              onChanged: (value){
                setState(() {
                  codigoBar = value;
                  buttonAddProduct=false;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: "Código"),
              style: textStyle,
            ),
            !buscando? RaisedButton(
                    onPressed: () {
                      setState(() {
                        buscando = true;
                        texto = "";
                        getIdProducto(id: codigoBar ?? "");
                      });
                    },
                    child: Text("Buscar"),
                  )
                :SizedBox( child: CircularProgressIndicator(),height:screenSize.width/2, width:screenSize.width/2,),
            Text(texto),
            buttonAddProduct?RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) =>ProductNew(id: this.codigoBar,),
                      ));
                    },
                    padding:EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                    label: Text("Agregar nuevo producto", style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    icon: Container(), // Icon( Icons.add,color: Colors.white),
                    textColor: Colors.white,
                  ):Container(),
          ],
        ),
      ),
    );
  }

  void getIdProducto({@required String id}) {
    Global.getProductosPrecargado(idProducto: id)
        .getDataProductoGlobal()
        .then((product) {
      if(product!= null) {
        if(product.convertProductoNegocio() != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ProductScreen(producto: product.convertProductoNegocio()),
            ),
          );
        } else {
          texto = "No existee!";
          buscando = false;
          buttonAddProduct= true;
          setState(() {});
        }
      } else {
        texto = "No existe!";
        buttonAddProduct= true;
        buscando = false;
        setState(() {});
      }
    });
  }
}
