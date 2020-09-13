import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  // Variables
  Categoria categoria;
  Categoria subcategoria;
  bool saveIndicador = false;
  bool deleteIndicador = false;
  ProductoNegocio producto;
  BuildContext contextPrincipal;
  _ProductEditState(this.producto);

  @override
  void initState() {
    getCategoriaProducto();
    controllerTextEdit_titulo = TextEditingController(text: producto.titulo);
    controllerTextEdit_descripcion =
        TextEditingController(text: producto.descripcion);
    controllerTextEdit_precio_venta =
        TextEditingController(text: producto.precio_venta.toString());
    controllerTextEdit_compra =
        TextEditingController(text: producto.precio_compra.toString());
    controllerTextEdit_comparacion =
        TextEditingController(text: producto.precio_comparacion.toString());
    super.initState();
  }

  void getCategoriaProducto() async {
    Global.getDataCatalogoCategoria(
            idNegocio: Global.oPerfilNegocio.id,
            idCategoria: producto.categoria)
        .getDataCategoria()
        .then((value) {
      setState(() {
        this.categoria = value ?? Categoria();
      });
    });
    if (producto.subcategoria != "") {
      Global.getDataCatalogoSubcategoria(
              idNegocio: Global.oPerfilNegocio.id,
              idCategoria: producto.categoria,
              idSubcategoria: producto.subcategoria)
          .getDataCategoria()
          .then((value) {
        setState(() {
          this.subcategoria = value ?? Categoria();
        });
      });
    }
  }

  @override
  void dispose() {
    controllerTextEdit_titulo.dispose();
    controllerTextEdit_descripcion.dispose();
    controllerTextEdit_precio_venta.dispose();
    controllerTextEdit_compra.dispose();
    controllerTextEdit_comparacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contextPrincipal) {
    this.contextPrincipal = contextPrincipal;

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
                producto.verificado == true
                    ? Padding(
                        padding: EdgeInsets.only(right: 3.0),
                        child: new Image.asset('assets/icon_verificado.png',
                            width: 16.0, height: 16.0))
                    : new Container(),
                Text(widget.producto.id,
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
          body: FutureBuilder(
            future: Global.getProductosPrecargado(idProducto: this.producto.id)
                .getDataProductoGlobal(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                Producto productoGlobal = snapshot.data;
                this.producto.urlimagen = productoGlobal.urlimagen;
                this.producto.titulo = productoGlobal.titulo;
                this.producto.descripcion = productoGlobal.descripcion;
                this.producto.verificado = productoGlobal.verificado;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widgetsImagen(),
                      widgetFormEditText(builderContext: context),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      }),
    );
  }

  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

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
              )
            : _previewImage(),
        // TODO : Modificar antes de lanzar a produccion
        true //producto.verificado==false
            ? Row(
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
                                BorderRadius.all(Radius.circular(35.0))),
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.gallery,
                              context: context);
                        },
                        icon: const Icon(Icons.photo_library),
                        label: Text("Galeria",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.white))),
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
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Flexible(
                    child: InkWell(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = this.categoria != null
                              ? this.categoria.nombre
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
                        getCategoria(buildContext: builderContext);
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
                          ..text = this.subcategoria != null
                              ? this.subcategoria.nombre
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
                        if (this.categoria != null) {
                          getSubCategoria(
                              buildContext: builderContext,
                              idCategoria: this.categoria.id);
                        }
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
            enabled: !producto.verificado,
            onChanged: (value) => producto.titulo = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2)),
                labelText: "Titulo"),
            style: textStyle,
            controller: controllerTextEdit_titulo,
          ),
          SizedBox(height: 16.0),
          TextField(
            enabled: !producto.verificado,
            onChanged: (value) => producto.descripcion = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Descripción"),
            style: textStyle,
            controller: controllerTextEdit_descripcion,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => producto.precio_venta = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de venta"),
            style: textStyle,
            controller: controllerTextEdit_precio_venta,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) => producto.precio_compra = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de compra"),
            style: textStyle,
            controller: controllerTextEdit_compra,
          ),
          SizedBox(height: 16.0),
          TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) =>
                producto.precio_comparacion = double.parse(value),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Precio de comparación"),
            style: textStyle,
            controller: controllerTextEdit_comparacion,
          ),
          SizedBox(height: 25.0),
          deleteIndicador == false
          ?SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              onPressed: ()async{
                setState(() {
                  deleteIndicador=true;
                });
                // Firebase ( delete )
                await Global.getDataProductoNegocio(idNegocio: Global.prefs.getIdNegocio, idProducto: producto.id).deleteDoc(); // Procede a eliminar el documento de la base de datos del catalogo de la cuenta
                // Emula un retardo de 2 segundos
                Future.delayed(const Duration(milliseconds: 2000), () {
                  Navigator.pop(builderContext);
                });
              },
              color: Colors.red[400],
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(12.0),
              label: Text("Borrar producto",
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
            ),
          ):SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              onPressed: (){},
              color: Colors.red[400],
              icon:Container(width: 16.0,height: 16.0,child: CircularProgressIndicator(backgroundColor: Colors.white)),
              padding: EdgeInsets.all(12.0),
              label: Text("Borrando de su catalogo...",
                  style: TextStyle(fontSize: 18.0, color: Colors.white)),
            ),
          ),
          
          //CircularProgressIndicator(),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment
                .center, // Align however you like (i.e .centerRight, centerLeft)
            child: Text("Este producto será eliminado de su catálogo",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14.0)),
          ),
          SizedBox(height: 25.0),
        ],
      ),
    );
  }


  void guardar({@required BuildContext buildContext}) async {
    if (this.categoria != null && this.subcategoria != null) {
      if (producto.titulo != "") {
        if (producto.descripcion != "") {
          if (producto.precio_venta != 0.0) {
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
                  .child(producto.id);
              StorageUploadTask uploadTask = ref.putFile(File(_imageFile.path));
              // obtenemos la url de la imagen guardada
              urlIamgen =
                  await (await uploadTask.onComplete).ref.getDownloadURL();
              // TODO: Por el momento los datos del producto se guarda junto a la referencia de la cuenta del negocio
              producto.urlimagen = urlIamgen;
            }

            // TODO: Por defecto verificado es TRUE // Cambiar esto cuando se lanze a producción
            producto.verificado = true;
            producto.categoria = this.categoria.id;
            producto.subcategoria = this.subcategoria.id;
            updateProductoGlobal();
            // Firebase set
            await Global.getDataProductoNegocio(
                    idNegocio: Global.prefs.getIdNegocio,
                    idProducto: producto.id)
                .upSetProducto(producto.toJson());

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
        precio: producto.precio_venta,
        moneda: producto.signo_moneda,
        timestamp: Timestamp.fromDate(new DateTime.now()));
    // Firebase set
    await Global.getPreciosProducto(
            idNegocio: Global.oPerfilNegocio.id,
            idProducto: producto.id,
            isoPAis: "ARG")
        .upSetPrecioProducto(precio.toJson());

    Map timestampUpdatePrecio;
    if (urlIamgen == "") {
      timestampUpdatePrecio = {
        'timestamp_actualizacion': Timestamp.fromDate(new DateTime.now())
      };
    } else {
      timestampUpdatePrecio = {
        'timestamp_actualizacion': Timestamp.fromDate(new DateTime.now()),
        'urlimagen': urlIamgen
      };
    }
    // Firebase set
    await Global.getProductosPrecargado(idProducto: producto.id, isoPAis: "ARG")
        .upSetPrecioProducto(timestampUpdatePrecio);
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

  // VIEWS
  getCategoria({@required BuildContext buildContext}) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(title: Text("Categoría")),
            body: FutureBuilder(
              future: Global.getCatalogoCategorias(
                      idNegocio: Global.oPerfilNegocio.id)
                  .getDataCategoriaAll(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Global.listCategoriasCatalogo = snapshot.data;
                  if (Global.listCategoriasCatalogo.length != 0) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shrinkWrap: true,
                      itemCount: Global.listCategoriasCatalogo.length,
                      itemBuilder: (BuildContext context, int index) {
                        Categoria categoriaSelect =
                            Global.listCategoriasCatalogo[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: 24.0,
                                child: Text(
                                    categoriaSelect.nombre.substring(0, 1),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              dense: true,
                              title: Text(categoriaSelect.nombre),
                              onTap: () {
                                setState(() {
                                  this.categoria = categoriaSelect;
                                  this.subcategoria = null;
                                  Navigator.pop(ctx);
                                  getSubCategoria(
                                      buildContext: buildContext,
                                      idCategoria: this.categoria.id);
                                });
                              },
                            ),
                            Divider(endIndent: 12.0, indent: 12.0),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Cargando..."));
                  }
                } else {
                  return Center(child: Text("Cargando..."));
                }
              },
            ),
          );
        });
  }

  getSubCategoria(
      {@required BuildContext buildContext, @required String idCategoria}) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(title: Text("Subcategoria")),
            body: FutureBuilder(
              future: Global.getCatalogoSubcategorias(
                      idNegocio: Global.oPerfilNegocio.id,
                      idCategoria: idCategoria)
                  .getDataCategoriaAll(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Global.listCategoriasCatalogo = snapshot.data;
                  if (Global.listCategoriasCatalogo.length != 0) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shrinkWrap: true,
                      itemCount: Global.listCategoriasCatalogo.length,
                      itemBuilder: (BuildContext context, int index) {
                        Categoria categoriaSelect =
                            Global.listCategoriasCatalogo[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: 24.0,
                                child: Text(
                                    categoriaSelect.nombre.substring(0, 1),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              dense: true,
                              title: Text(categoriaSelect.nombre),
                              onTap: () {
                                setState(() {
                                  this.subcategoria = categoriaSelect;
                                  Navigator.pop(buildContext);
                                });
                              },
                            ),
                            Divider(endIndent: 12.0, indent: 12.0),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Cargando..."));
                  }
                } else {
                  return Center(child: Text("Cargando..."));
                }
              },
            ),
          );
        });
  }
}
