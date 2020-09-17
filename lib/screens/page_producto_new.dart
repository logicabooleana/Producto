import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/screens/widgets/widgets_categoria.dart';
import 'package:catalogo/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductNew extends StatefulWidget {
  final String id;
  ProductNew({@required this.id});

  @override
  _ProductNewState createState() => _ProductNewState(id: id);
}

class _ProductNewState extends State<ProductNew> {
  // Variables
  Categoria categoria;
  Categoria subcategoria;
  bool saveIndicador = false;
  ProductoNegocio productoNegocio = new ProductoNegocio();
  String id;
  _ProductNewState({@required this.id});

  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  BuildContext contextPrincipal;
  final ImagePicker _picker = ImagePicker();

  // Toma los pixeles del ancho y alto de la pantalla
  Size screenSize;

  @override
  void initState() {
    productoNegocio.id = widget.id;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext contextPrincipal) {
    contextPrincipal = contextPrincipal;
    screenSize = MediaQuery.of(contextPrincipal).size;
    return Scaffold(
      body: Builder(builder: (contextBuilder) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(contextPrincipal).canvasColor,
            iconTheme: Theme.of(contextPrincipal).iconTheme.copyWith(
                color: Theme.of(contextPrincipal).textTheme.bodyText1.color),
            title: Row(
              children: <Widget>[
                productoNegocio.verificado == true
                    ? Padding(
                        padding: EdgeInsets.only(right: 3.0),
                        child: new Image.asset('assets/icon_verificado.png',
                            width: 16.0, height: 16.0))
                    : new Container(),
                Text(widget.id,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(contextPrincipal)
                            .textTheme
                            .bodyText1
                            .color)),
              ],
            ),
            actions: <Widget>[
              IconButton(
                  icon: saveIndicador == false
                      ? Icon(Icons.check)
                      : Container(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        ),
                  onPressed: () {
                    guardar(buildContext: contextBuilder);
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetsImagen(),
                widgetFormEditText(builderContext: contextBuilder),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget widgetsImagen() {
    return Column(
      children: [
        _imageFile == null
            ?Container(
                height: MediaQuery.of(context).size.width,
                color: Colors.grey,
                child: Center(child: Icon(Icons.image,color: Colors.white)),
              )
            : _previewImage(),
        Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(height: 12.0, width: 12.0),
                  Expanded(
                    child: RaisedButton.icon(
                        color: Theme.of(context).accentColor,
                        padding: const EdgeInsets.all(14.0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                        },
                        icon: const Icon(Icons.photo_library,
                            color: Colors.white),
                        label: Text("Galeria",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.white))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: MaterialButton(
                      elevation: 1.0,
                      color: Theme.of(context).accentColor,
                      onPressed: () => _onImageButtonPressed(ImageSource.camera,
                          context: context),
                      child: Icon(Icons.camera_alt, color: Colors.white),
                      padding: EdgeInsets.all(14.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                  ),
                ],
              )
      ],
    );
  }

  Widget widgetFormEditText({@required BuildContext builderContext}) {
    TextStyle textStyle = new TextStyle(fontSize: 24.0);
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<ProviderCatalogo>(
            child: Text("Cargando categorías"),
            builder: (context, catalogo, child) {
              this.categoria = catalogo.getCategoria;
              this.subcategoria = catalogo.getSubcategoria;
              return Row(
                children: [
                  new Flexible(
                    child: InkWell(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = catalogo.getCategoria != null
                              ? catalogo.getCategoria.nombre
                              : "",
                        enabled: false,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2)),
                            labelText: "Categoría"),
                        style: textStyle,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            backgroundColor:
                                Theme.of(builderContext).canvasColor,
                            context: builderContext,
                            builder: (ctx) {
                              return ClipRRect(
                                child: ViewCategoria(buildContext: ctx),
                              );
                            });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                    width: 12.0,
                  ),
                  new Flexible(
                    child: InkWell(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = catalogo.getSubcategoria != null
                              ? catalogo.getSubcategoria.nombre
                              : "",
                        enabled: false,
                        enableInteractiveSelection: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2)),
                            labelText: "Subcategoría"),
                        style: textStyle,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            backgroundColor:
                                Theme.of(builderContext).canvasColor,
                            context: builderContext,
                            builder: (ctx) {
                              return ClipRRect(
                                child: ViewSubCategoria(
                                    buildContextCategoria: ctx,
                                    categoria: catalogo.getCategoria),
                              );
                            });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(
            height: 12.0,
            width: 12.0,
          ),
          TextField(
            enabled: !productoNegocio.verificado,
            onChanged: (value) {
              productoNegocio.titulo = value;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2)),
                labelText: "Titulo"),
            style: textStyle,
          ),
          SizedBox(height: 16.0),
          TextField(
            enabled: !productoNegocio.verificado,
            onChanged: (value) {
              productoNegocio.descripcion = value;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Descripción"),
            style: textStyle,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                productoNegocio.precio_venta = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de venta"),
            style: textStyle,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                productoNegocio.precio_compra = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de compra"),
            style: textStyle,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                productoNegocio.precio_comparacion = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Precio de comparación"),
            style: textStyle,
          ),
        ],
      ),
    );
  }

  void guardar({@required BuildContext buildContext}) async {
    if (this.categoria != null && this.subcategoria != null) {
      if (productoNegocio.titulo != "") {
        if (productoNegocio.descripcion != "") {
          if (productoNegocio.precio_venta != 0.0) {
            setState(() {
              saveIndicador = true;
            });
            urlIamgen = "";

            // Si la "PickedFile" es distinto nulo procede a guardar la imagen en la base de dato de almacenamiento
            if (_imageFile != null) {
              StorageReference ref = FirebaseStorage.instance
                  .ref()
                  .child("APP")
                  .child("ARG")
                  .child("PRODUCTOS")
                  .child(productoNegocio.id);
              StorageUploadTask uploadTask = ref.putFile(File(_imageFile.path));
              // obtenemos la url de la imagen guardada
              urlIamgen =
                  await (await uploadTask.onComplete).ref.getDownloadURL();
              // TODO: Por el momento los datos del producto se guarda junto a la referencia de la cuenta del negocio
              productoNegocio.urlimagen = urlIamgen;
            }

            // TODO: Por defecto verificado es TRUE // Cambiar esto cuando se lanze a producción
            productoNegocio.verificado = true;
            productoNegocio.categoria = this.categoria.id;
            productoNegocio.subcategoria = this.subcategoria.id;
            // valores de creación
            productoNegocio.timestamp_creation =
                Timestamp.fromDate(new DateTime.now());
            updateProductoGlobal();
            // Firebase set
            await Global.getDataProductoNegocio(
                    idNegocio: Global.prefs.getIdNegocio,
                    idProducto: productoNegocio.id)
                .upSetProducto(productoNegocio.toJson());
            Navigator.pop(context);
          } else {
            viewSnackBar(
                context: buildContext, message: 'Asigne un precio de venta');
          }
        } else {
          viewSnackBar(
              context: buildContext, message: 'Debe elegir una descripción');
        }
      } else {
        viewSnackBar(context: buildContext, message: 'Debe elegir un titulo');
      }
    } else {
      viewSnackBar(context: buildContext, message: 'Debe elegir una categoría');
    }
  }

  void viewSnackBar(
      {@required BuildContext context, @required String message}) async {
    final snackBar = SnackBar(
        content: Text('Debe elegir una categoría'),
        action: SnackBarAction(label: 'ok', onPressed: () {}));

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateProductoGlobal() async {
    // Valores para registrar el precio
    Precio precio = new Precio(
        id_negocio: Global.oPerfilNegocio.id,
        precio: productoNegocio.precio_venta,
        moneda: productoNegocio.signo_moneda,
        timestamp: Timestamp.fromDate(new DateTime.now()));
    // Firebase set
    await Global.getPreciosProducto(
            idNegocio: Global.oPerfilNegocio.id,
            idProducto: productoNegocio.id,
            isoPAis: "ARG")
        .upSetPrecioProducto(precio.toJson());

    // values
    // TODO: Por defecto verificado es TRUE // Cambiar esto cuando se lanze a producción
    productoNegocio.verificado = true;
    productoNegocio.categoria = this.categoria.id;
    productoNegocio.subcategoria = this.subcategoria.id;
    Map timestampUpdatePrecio;
    if (urlIamgen == "") {
      productoNegocio.timestamp_actualizacion =
          Timestamp.fromDate(new DateTime.now());
    } else {
      productoNegocio.timestamp_actualizacion =
          Timestamp.fromDate(new DateTime.now());
      productoNegocio.urlimagen = urlIamgen;
    }
    // Firebase set
    await Global.getProductosPrecargado(
            idProducto: productoNegocio.id, isoPAis: "ARG")
        .upSetPrecioProducto(productoNegocio.convertProductoDefault().toJson());
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 720.0,
        maxHeight: 720.0,
        imageQuality: 55,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(File(_imageFile.path));
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }
}
