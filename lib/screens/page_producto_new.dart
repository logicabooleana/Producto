import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:image_picker/image_picker.dart';

class ProductNew extends StatefulWidget {
  final String id;
  ProductNew({@required this.id});

  @override
  _ProductNewState createState() => _ProductNewState(id: id);
}

class _ProductNewState extends State<ProductNew> {

  bool saveIndicador = false;
  ProductoNegocio productoNegocio=new ProductoNegocio();
  Producto producto=new Producto();
  String id;
  _ProductNewState({@required this.id});

  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  // Toma los pixeles del ancho y alto de la pantalla
  Size screenSize;

  @override
  void initState() {
    productoNegocio.id=widget.id;
    producto.id=widget.id;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
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
                    color: Theme.of(context).textTheme.bodyText1.color)),
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
                //guardar();
              }),
        ],
      ),
      body:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widgetsImagen(),
                  widgetFormEditText(),
                ],
              ),
            ),
    );
  }

  Widget widgetsImagen() {
    return Column(
      children: [
        _imageFile == null
            ? Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    fadeInDuration: Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    imageUrl:this.productoNegocio.urlimagen??"default",
                    placeholder: (context, url) => FadeInImage(
                        image: AssetImage("assets/loading.gif"),
                        placeholder: AssetImage("assets/loading.gif")),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Icon(Icons.image),
                      ),
                    ),
                  ),
                ),
              )
            : _previewImage(),
          true //producto.verificado==false
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.gallery,
                            context: context);
                      },
                      heroTag: 'image0',
                      tooltip: 'Elegir imagen de la galería',
                      child: const Icon(Icons.photo_library),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        _onImageButtonPressed(ImageSource.camera,
                            context: context);
                      },
                      heroTag: 'image1',
                      tooltip: 'Toma una foto',
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  Widget widgetFormEditText() {
    TextStyle textStyle = new TextStyle(fontSize: 24.0);
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            enabled: !productoNegocio.verificado,
            onChanged: (value) {
              productoNegocio.titulo = value;
              producto.titulo = value;
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
            onChanged: (value)  {
              productoNegocio.descripcion = value;
              producto.descripcion= value;
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Descripción"),
            style: textStyle,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => productoNegocio.precio_venta = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de venta"),
            style: textStyle,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => productoNegocio.precio_compra = double.parse(value),
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

  void guardar() async {
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
      urlIamgen = await (await uploadTask.onComplete).ref.getDownloadURL();
      // TODO: Por el momento los datos del producto se guarda junto a la referencia de la cuenta del negocio
      productoNegocio.urlimagen=urlIamgen;
    }

    // TODO: Por defecto verificado es TRUE // Cambiar esto cuando se lanze a producción
    productoNegocio.verificado = true;
    // valores de creación
    productoNegocio.timestamp_creation=Timestamp.fromDate(new DateTime.now());
    updateProductoGlobal();
    // Firebase set
    await Global.getDataProductoNegocio(idNegocio: Global.prefs.getIdNegocio, idProducto: productoNegocio.id)
        .upSetProducto(productoNegocio.toJson());

    Navigator.pop(context);
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

    Map timestampUpdatePrecio;
    if (urlIamgen == "") {
      producto.timestamp_actualizacion=Timestamp.fromDate(new DateTime.now());
    } else {
      producto.timestamp_actualizacion=Timestamp.fromDate(new DateTime.now());
      producto.urlimagen=urlIamgen;
    }
    // Firebase set
    await Global.getProductosPrecargado(idProducto: productoNegocio.id, isoPAis: "ARG")
        .upSetPrecioProducto(producto.toJson());
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
      return Image.file(File(_imageFile.path),width:screenSize.width,height: screenSize.width,fit:BoxFit.cover,);
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
