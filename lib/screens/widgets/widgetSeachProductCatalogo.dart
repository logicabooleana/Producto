import 'package:flutter/material.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/screens/page_producto_view.dart';
import 'package:catalogo/screens/page_producto_new.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class WidgetSeachProduct extends StatefulWidget {
  WidgetSeachProduct({Key key}) : super(key: key);

  @override
  _WidgetSeachProductState createState() => _WidgetSeachProductState();
}

class _WidgetSeachProductState extends State<WidgetSeachProduct> {
  TextEditingController textEditingController = new TextEditingController();

  String codigoBar = "";
  TextStyle textStyle = new TextStyle(fontSize: 30.0);
  bool buscando = false;
  String textoTextResult = "";
  String texto = "";
  bool buttonAddProduct = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar"),
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
              crossAxisAlignment:CrossAxisAlignment.center ,
              children: [
                Flexible(
                  child: TextField(
                    controller: textEditingController,
                    //keyboardType: TextInputType.number,
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
                        border: OutlineInputBorder(), labelText: "Código"),
                    style: textStyle,
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
                        texto = "";
                        codigoBar = value;
                      });
                    });
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment:CrossAxisAlignment.center ,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                !buscando
                ? Container(
                  width: double.infinity,
                  child: RaisedButton.icon(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(12.0),
                      icon: Icon(Icons.search),
                      onPressed: () {
                        if (textEditingController.text != "") {
                          setState(() {
                            buscando = true;
                            buttonAddProduct = false;
                            texto = "";
                            getIdProducto(id: codigoBar ?? "");
                          });
                        }
                      },
                      label: Text("Buscar"),
                      textColor: Colors.white,
                    ),
                )
                : SizedBox(
                    child: CircularProgressIndicator(),
                    height: screenSize.width / 2,
                    width: screenSize.width / 2,
                  ),
            !buscando?SizedBox(width: 12.0,height: 12.0):Container(),
            !buscando
                ? Container(
                  width: double.infinity,
                  child: RaisedButton.icon(
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(12.0),
                  icon: Image(
                      color: Colors.white,
                      height: 20.0,
                      width: 20.0,
                      image: AssetImage('assets/barcode.png'),
                      fit: BoxFit.contain),
                  label: Text('Escanea el código',style: TextStyle(color: Colors.white)),
                  textColor: Colors.white,
                  onPressed: () {
                    scanBarcodeNormal(context: context);
                  }),
                )
                : Container(),
              ],
            ),
            !buscando?Text(texto):Container(),
            buttonAddProduct? Container(
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
                          style: TextStyle(fontSize: 18.0, color: Colors.white)),
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
          texto = "No existee!";
          buscando = false;
          buttonAddProduct = true;
          setState(() {});
        }
      } else {
        texto = "No existe!";
        buttonAddProduct = true;
        buscando = false;
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
          texto = "";
          getIdProducto(id: barcodeScanRes ?? "");
        });
  }
}
