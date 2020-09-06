
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:image_picker/image_picker.dart';

class ProductEdit extends StatefulWidget {

  final String sSignoMoneda;
  final ProductoNegocio producto;
  ProductEdit({this.producto, this.sSignoMoneda});

  @override
  _ProductEditState createState() => _ProductEditState(producto);
}

class _ProductEditState extends State<ProductEdit> {
  TextEditingController controllerTextEdit_titulo;

  TextEditingController controllerTextEdit_descripcion;
  TextEditingController controllerTextEdit_precio_venta;
  TextEditingController controllerTextEdit_compra;
  TextEditingController controllerTextEdit_comparacion;

  bool saveIndicador=false;
  ProductoNegocio producto;
  _ProductEditState(this.producto);

  @override
  void initState() {
    super.initState();
    controllerTextEdit_titulo = TextEditingController(text: producto.titulo);
    controllerTextEdit_descripcion =
        TextEditingController(text: producto.descripcion);
    controllerTextEdit_precio_venta =
        TextEditingController(text: producto.precio_venta.toString());
    controllerTextEdit_compra =
        TextEditingController(text: producto.precio_compra.toString());
    controllerTextEdit_comparacion =
        TextEditingController(text: producto.precio_comparacion.toString());
  }

  @override
  void dispose() {
    controllerTextEdit_titulo.dispose();
    controllerTextEdit_descripcion.dispose();
    controllerTextEdit_precio_venta.dispose();
    controllerTextEdit_compra.dispose();
    controllerTextEdit_comparacion.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).textTheme.bodyText1.color),
        title: Row(
          children: <Widget>[
            producto.verificado == true
                ? Padding(padding:EdgeInsets.only(right:3.0),child: new Image.asset('assets/icon_verificado.png',width: 16.0,height: 16.0))
                : new Container(),
            Text(widget.producto.id,style: TextStyle(fontSize: 18.0,color: Theme.of(context).textTheme.bodyText1.color)),
          ],
        ),
        actions: <Widget>[
          IconButton(icon: saveIndicador==false
            ?Icon(Icons.check):Container(width: 24.0,height: 24.0,child: CircularProgressIndicator(backgroundColor: Colors.white,),),
              onPressed: () {guardar();}),
        ],
      ),
      body: SingleChildScrollView(
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

  String urlIamgen="";
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker(); 
  
  Widget widgetsImagen(){
    return Column(
      children: [
        _imageFile==null?Container(
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
                  child: Hero(
                    tag: widget.producto.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        fadeInDuration: Duration(milliseconds: 200),
                        fit: BoxFit.cover,
                        imageUrl: widget.producto.urlimagen,
                        placeholder: (context, url) => FadeInImage(
                            image: AssetImage("assets/loading.gif"),
                            placeholder: AssetImage("assets/loading.gif")),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              widget.producto.titulo.substring(0, 3),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.25),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ):_previewImage(),
        producto.verificado==false
        ?Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
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
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image1',
              tooltip: 'Toma una foto',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      )
      :Container(),
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
            enabled: !producto.verificado,
            onChanged: (value) => producto.titulo = value,
            decoration:InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green, width: 2)),labelText: "Titulo"),
            style:textStyle,
            controller: controllerTextEdit_titulo,
          ),
          SizedBox(height: 16.0),
          TextField(
            enabled: !producto.verificado,
            onChanged: (value) => producto.descripcion = value,
            decoration:InputDecoration(border: OutlineInputBorder(),labelText: "Descripción"),
            style:textStyle,
            controller: controllerTextEdit_descripcion,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => producto.precio_venta = double.parse(value),
            decoration:InputDecoration(border: OutlineInputBorder(),labelText: "Precio de venta"),
            style:textStyle,
            controller: controllerTextEdit_precio_venta,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => producto.precio_compra = double.parse(value),
            decoration:InputDecoration(border: OutlineInputBorder(),labelText: "Precio de compra"),
            style:textStyle,
            controller: controllerTextEdit_compra,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => producto.precio_comparacion = double.parse(value),
            decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Precio de comparación"),
            style:textStyle,
            controller: controllerTextEdit_comparacion,
          ),
        ],
      ),
    );
  }
  void guardar()async{
    setState(() {
      saveIndicador=true;
    });
     urlIamgen="";

    // Si la "PickedFile" es distinto nulo procede a guardar la imagen en la base de dato de almacenamiento
    if( _imageFile != null ){
      StorageReference ref = FirebaseStorage.instance.ref().child(Global.oPerfilNegocio.id).child("EXTENSION_CATALOGO").child(producto.id);
      StorageUploadTask uploadTask = ref.putFile(File(_imageFile.path));
      // obtenemos la url de la imagen guardada
      urlIamgen = await (await uploadTask.onComplete).ref.getDownloadURL();
      // TODO: Por el momento los datos del producto se guarda junto a la referencia de la cuenta del negocio
      producto.urlimagen=urlIamgen;
    } 

    // TODO: Por defecto verificado es TRUE // Cambiar esto cuando se lanze a producción
    producto.verificado=true;
    updateProductoGlobal();
    // Firebase set
    await Global.getDataProductoNegocio(idNegocio: Global.prefs.getIdNegocio,idProducto: producto.id).upSetProducto(producto.toJson());
    
    Navigator.pop(context);
  }
  void updateProductoGlobal()async{

    // Valores para registrar el precio
    Precio precio = new Precio(
      id_negocio: Global.oPerfilNegocio.id,
      precio: producto.precio_venta,
      moneda: producto.signo_moneda,
      timestamp: Timestamp.fromDate(new DateTime.now())
    );
    // Firebase set
    await Global.getPreciosProducto(idNegocio: Global.oPerfilNegocio.id,idProducto: producto.id, isoPAis: "ARG").upSetPrecioProducto(precio.toJson());
    
    Map timestampUpdatePrecio;
    if(urlIamgen==""){
      timestampUpdatePrecio={
        'timestamp_actualizacion':Timestamp.fromDate(new DateTime.now())
      }; 
    }else{
      timestampUpdatePrecio={
        'timestamp_actualizacion':Timestamp.fromDate(new DateTime.now()),
        'urlimagen':urlIamgen
      }; 
    }
    // Firebase set
    await Global.getProductosPrecargado(idProducto: producto.id, isoPAis: "ARG").upSetPrecioProducto(timestampUpdatePrecio);
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