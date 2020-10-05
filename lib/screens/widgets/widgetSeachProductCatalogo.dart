import 'package:flutter/material.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/screens/page_producto_view.dart';
import 'package:producto/screens/page_producto_new.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:animate_do/animate_do.dart';

class WidgetSeachProduct extends StatefulWidget {
  String codigo;
  WidgetSeachProduct({this.codigo});

  @override
  _WidgetSeachProductState createState() =>
      _WidgetSeachProductState(codigoBar: codigo);
}

class _WidgetSeachProductState extends State<WidgetSeachProduct> {
  TextEditingController textEditingController = new TextEditingController();
  String codigoBar = "";
  bool buscando = false;
  String textoTextResult = "";
  bool buttonAddProduct = false;
  Color colorView;
  bool resultState = true;

  _WidgetSeachProductState({this.codigoBar = ""});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (codigoBar != null) {
      getIdProducto(id: codigoBar ?? "");
    }
    textEditingController = TextEditingController(text: codigoBar ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorView =
        resultState == true ? Theme.of(context).primaryColor : Colors.red[400];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorView,
        title: Text(resultState ? "Buscar" : "No se encontro coincidencia"),
      ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    controller: textEditingController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          new RegExp('[1234567890]'))
                    ],
                    onChanged: (value) {
                      setState(() {
                        codigoBar = value;
                        buttonAddProduct = false;
                      });
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              textEditingController.clear();
                              buttonAddProduct = false;
                              resultState = true;
                            });
                          },
                          icon: Icon(Icons.clear,color: colorView),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorView)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: colorView)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colorView)),
                        labelStyle: TextStyle(color: colorView),
                        labelText: "Código",
                        suffixStyle: TextStyle(color: colorView)),
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () {
                    FlutterClipboard.paste().then((value) {
                      // Do what ever you want with the value.
                      setState(() {
                        textEditingController.text = value ?? "";
                        buttonAddProduct = false;
                        codigoBar = value;
                        resultState = true;
                      });
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !buscando
                    ? FadeInRight(
                        child: Container(
                        width: double.infinity,
                        child: RaisedButton.icon(
                          color: colorView,
                          padding: EdgeInsets.all(16.0),
                          icon: Icon(Icons.search),
                          onPressed: () {
                            if (textEditingController.text != "") {
                              setState(() {
                                getIdProducto(id: codigoBar ?? "");
                              });
                            }
                          },
                          label: Text("Buscar"),
                          textColor: Colors.white,
                        ),
                      ))
                    : SizedBox(
                        child: CircularProgressIndicator(),
                        height: screenSize.width / 2,
                        width: screenSize.width / 2,
                      ),
                !buscando ? SizedBox(width: 12.0, height: 12.0) : Container(),
                !buscando
                    ? FadeInLeft(
                        child: Container(
                        width: double.infinity,
                        child: RaisedButton.icon(
                            color: colorView,
                            padding: EdgeInsets.all(16.0),
                            icon: Image(
                                color: Colors.white,
                                height: 20.0,
                                width: 20.0,
                                image: AssetImage('assets/barcode.png'),
                                fit: BoxFit.contain),
                            label: Text('Escanea el código',
                                style: TextStyle(color: Colors.white)),
                            textColor: Colors.white,
                            onPressed: () {
                              scanBarcodeNormal(context: context);
                            }),
                      ))
                    : Container(),
              ],
            ),
            buttonAddProduct
                ? Container(
                    width: double.infinity,
                    child: RaisedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => ProductNew(
                            id: this.codigoBar,
                          ),
                        ));
                      },
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.all(12.0),
                      label: Text("Agregar nuevo producto",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white)),
                      icon: Icon(Icons.add),
                      textColor: Colors.white,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void getIdProducto({@required String id}) {
    buscando = true;
    buttonAddProduct = false;
    if (id == null) {
      id = "null";
    }
    if (id == "") {
      id = "null";
    }

    Global.getProductosPrecargado(idProducto: id)
        .getDataProductoGlobal()
        .then((product) {
      if (product != null) {
        if (product.convertProductoNegocio() != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ProductScreen(producto: product.convertProductoNegocio()),
            ),
          );
        } else {
          buscando = false;
          buttonAddProduct = true;
          colorView = Colors.red;
          resultState = false;
          setState(() {});
        }
      } else {
        buttonAddProduct = true;
        buscando = false;
        colorView = Colors.red;
        resultState = false;
        setState(() {});
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal({@required BuildContext context}) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    setState(() {
      textEditingController.text = barcodeScanRes ?? "";
      codigoBar = barcodeScanRes ?? "";
      buscando = true;
      buttonAddProduct = false;
      getIdProducto(id: barcodeScanRes ?? "");
    });
  }
}
