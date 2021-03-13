import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Producto/models/models_catalogo.dart';
import 'package:Producto/services/globals.dart';
import 'package:Producto/screens/widgets/widgets_notify.dart';
import 'package:image_picker/image_picker.dart';

class PageCreateMarca extends StatefulWidget {
  Marca marca;
  PageCreateMarca({this.marca});
  @override
  _PageCreateMarcaState createState() => _PageCreateMarcaState(marca: marca);
}

class _PageCreateMarcaState extends State<PageCreateMarca> {
  
  Marca marca;
  _PageCreateMarcaState({this.marca});
  // Variables
  bool marcaEditable=false;
  bool saveIndicador = false;
  TextStyle textStyle = new TextStyle(fontSize: 24.0);
  Size screenSize;

  // Variables de imagen
  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext buildContext) {
    if( marca==null ){
      marcaEditable=false;
      marca=new Marca();
      marca.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }else{
      marcaEditable=true;
    }
    // Toma los pixeles del ancho y alto de la pantalla
    screenSize = MediaQuery.of(context).size;

    return Builder(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(marcaEditable==false?"Crear marca":"Actualizar marca"),
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
                    save(buildContext: context);
                  }),
            ],
          ),
          body: body(buildContext: context),
        );
      },
    );
  }

  Widget body({@required BuildContext buildContext}) {

    // Toma los pixeles del ancho y alto de la pantalla
    final screenSize = MediaQuery.of(buildContext).size;

    return Container(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: [
          Container(
            width: screenSize.width*0.90,
            height: screenSize.width*0.90,
            child:_imageFile == null
              ? this.marca.url_imagen!=""?CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: this.marca.url_imagen != ""
                          ? this.marca.url_imagen
                          : "default",
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 100.0,
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 100.0,
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 100.0,
                      ),
                    ):CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 100.0,
                      )
              : _previewImage(),
          ),
          SizedBox(height: 20.0, width: 20.0),
          RaisedButton.icon(
                color: Theme.of(context).accentColor,
                padding: const EdgeInsets.all(14.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                onPressed: () {
                  _onImageButtonPressed(ImageSource.gallery, context: context);
                },
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: Text("Cargar imagen",
                    style: TextStyle(fontSize: 18.0, color: Colors.white))),
          SizedBox(height: 12.0, width: 12.0),
          TextField(
            controller: new TextEditingController(text: this.marca.titulo),
            onChanged: (value) => this.marca.titulo = value,
            decoration: InputDecoration(border: OutlineInputBorder(), labelText: "Titulo"),
            style: textStyle,
          ),
          SizedBox(height: 12.0, width: 12.0),
          TextField(
            controller: new TextEditingController(text: this.marca.descripcion),
            onChanged: (value) => marca.descripcion = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Descripción (opcional)"),
            style: textStyle,
          ),
          SizedBox(height: 12.0, width: 12.0),
          TextField(
            controller: new TextEditingController(text: this.marca.codigo_empresa),
            onChanged: (value) => marca.codigo_empresa = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Código de empresa (opcional)"),
            style: textStyle,
          ),
          SizedBox(height: 12.0, width: 12.0),
        ],
      ),
    );
  }

  void save({@required BuildContext buildContext}) async {
    if (marca.id != "") {
      if (marca.titulo != "") {
        setState(() {
          saveIndicador = true;
        });
        // Si la "PickedFile" es distinto nulo procede a guardar la imagen en la base de dato de almacenamiento
        if (_imageFile != null) {
          StorageReference ref = FirebaseStorage.instance
              .ref()
              .child("APP")
              .child("ARG")
              .child("MARCAS")
              .child(marca.id);
          StorageUploadTask uploadTask = ref.putFile(File(_imageFile.path));
          // obtenemos la url de la imagen guardada
          urlIamgen = await (await uploadTask.onComplete).ref.getDownloadURL();
          // TODO: Por el momento los datos del producto se guarda junto a la referencia de la cuenta del negocio
          marca.url_imagen = urlIamgen;
        }
        // TODO : Eliminar verificacion para produccion
          marca.verificado=true;
        // Firebase ( save)
        await Global.getMarca(idMarca: marca.id).upSetMarca(marca.toJson());

        // Cierra la actividad y devuelve el objeto en el caso que se requiera
        Navigator.pop(context, marca);
      } else {
        showSnackBar(
            context: buildContext, message: 'Debe elegir una descripción');
      }
    } else {
      showSnackBar(
          context: buildContext, message: 'Debe elegir una descripción');
    }
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
      return CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: FileImage(File(_imageFile.path)),
                );
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
