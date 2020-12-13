import 'package:flutter/material.dart';
import 'package:Producto/services/globals.dart';
import 'package:Producto/screens/page_producto_view.dart';
import 'package:Producto/screens/page_producto_new.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Producto/shared/progress_bar.dart';

class WidgetSeachProduct extends StatefulWidget {
  String codigo;
  WidgetSeachProduct({this.codigo});

  @override
  _WidgetSeachProductState createState() =>
      _WidgetSeachProductState(codigoBar: codigo);
}

class _WidgetSeachProductState extends State<WidgetSeachProduct> {
  
  Color colorFondo = Colors.deepPurple;
  Color colorTextButton= Colors.white;
  TextEditingController textEditingController = new TextEditingController();
  String codigoBar = "";
  bool buscando = false;
  String textoTextResult = "";
  bool buttonAddProduct = false;
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
    colorFondo =resultState == true ? Theme.of(context).primaryColor : Colors.red[400];

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: colorFondo,
      appBar: AppBar(
        backgroundColor:colorFondo ,
        title: Text(resultState ? "Buscar" : "Sin resultados"),
        bottom: buscando ? linearProgressBarApp(color: colorTextButton) : null,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: textEditingController,
                        keyboardType:TextInputType.numberWithOptions(decimal: false),
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
                              onPressed: () {
                                setState(() {
                                  textEditingController.clear();
                                  buttonAddProduct = false;
                                  resultState = true;
                                });
                              },
                              icon: textEditingController.text != ""
                                  ? Icon(Icons.clear, color: colorTextButton)
                                  : Container(),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextButton)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextButton)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorTextButton)),
                            labelStyle: TextStyle(color: colorTextButton),
                            labelText: "Código",
                            suffixStyle: TextStyle(color: colorTextButton)),
                        style: TextStyle(fontSize: 30.0,color: colorTextButton),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          if (textEditingController.text != "") {
                                  setState(() {
                                    getIdProducto(id: codigoBar ?? "");
                                  });
                                }
                        },
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(12.0),
                      icon: Icon(Icons.content_copy,
                          color: colorTextButton),
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
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 12.0),
                    !buscando
                        ? FadeInRight(
                            child: Container(
                            width: double.infinity,
                            child: RaisedButton.icon(
                              color: colorTextButton,
                              padding: EdgeInsets.all(16.0),
                              icon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              onPressed: () {
                                if (textEditingController.text != "") {
                                  setState(() {
                                    getIdProducto(id: codigoBar ?? "");
                                  });
                                }
                              },
                              label: Text("Buscar",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                      color:
                                          Theme.of(context).primaryColorLight)),
                              textColor: Theme.of(context).primaryColorLight,
                            ),
                          ))
                        : Container(),
                    !buscando
                        ? SizedBox(width: 12.0, height: 12.0)
                        : Container(),
                    !buscando
                        ? FadeInLeft(
                            child: Container(
                            width: double.infinity,
                            child: RaisedButton.icon(
                                color: colorTextButton,
                                padding: EdgeInsets.all(16.0),
                                icon: Image(
                                    color: Theme.of(context).primaryColorLight,
                                    height: 20.0,
                                    width: 20.0,
                                    image: AssetImage('assets/barcode.png'),
                                    fit: BoxFit.contain),
                                label: Text('Escanear código de barra',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                        color: Theme.of(context)
                                            .primaryColorLight)),
                                textColor: Theme.of(context).primaryColorLight,
                                onPressed: () {
                                  scanBarcodeNormal(context: context);
                                }),
                          ))
                        : Container(),
                    buttonAddProduct
                        ? SizedBox(width: 12.0, height: 60.0)
                        : Container(),
                    buttonAddProduct
                        ? Container(
                            width: double.infinity,
                            child: RaisedButton.icon(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (BuildContext context) => ProductNew(
                                    id: this.codigoBar,
                                  ),
                                ));
                              },
                              color: colorTextButton,
                              padding: EdgeInsets.all(12.0),
                              label: Text("Agregar nuevo producto",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Theme.of(context).primaryColorLight)),
                              icon: Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              textColor: Theme.of(context).primaryColorLight,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ] //your list view content here
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
              builder: (BuildContext context) =>ProductScreen(producto: product.convertProductoNegocio()),
            ),
          );
        } else {
          buscando = false;
          buttonAddProduct = true;
          colorFondo = Colors.red[400];
          resultState = false;
          setState(() {});
        }
      } else {
        buttonAddProduct = true;
        buscando = false;
        colorFondo = Colors.red[400];
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
