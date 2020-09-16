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
import 'package:catalogo/screens/widgets/widgetSeachMarcaProducto.dart';

class ProductEdit extends StatefulWidget {
  final ProductoNegocio producto;
  ProductEdit({@required this.producto});

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
  TextStyle textStyle = new TextStyle(fontSize: 24.0);
  bool enCatalogo =
      false; // verifica si el producto se encuentra en el catalogo o no
  Marca marca;
  Categoria categoria;
  Categoria subcategoria;
  bool saveIndicador = false;
  bool deleteIndicador = false;
  ProductoNegocio producto;
  BuildContext contextPrincipal;
  _ProductEditState(this.producto);

  @override
  void initState() {
    checkCatalogo();
    getMarca();
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

  void checkCatalogo() async {
    Global.listProudctosNegocio.forEach((element) {
      if (element.id == this.producto.id) {
        enCatalogo = true;
      }
    });
  }

  void getMarca() async {
    // Defaul values
    this.marca = null;
    if (producto != null) {
      if (producto.id_marca != "") {
        Global.getMarca(idMarca: producto.id_marca)
            .getDataMarca()
            .then((value) {
          if (value != null) {
            setState(() {
              this.marca = value;
            });
          }
        });
      }
    }
  }

  void getCategoriaProducto() async {
    Global.getDataCatalogoCategoria(
            idNegocio: Global.oPerfilNegocio.id,
            idCategoria: producto.categoria)
        .getDataCategoria()
        .then((value) {
      this.categoria = value ?? Categoria();
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
    } else {
      setState(() {});
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
                  new SizedBox(
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
          widgetTextFieldMarca(),
          this.marca == null
              ? SizedBox(
                  height: 12.0,
                  width: 12.0,
                )
              : Container(),
          this.marca == null
              ? TextField(
                  enabled: !producto.verificado,
                  onChanged: (value) => producto.titulo = value,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.green, width: 2)),
                      labelText: "Titulo"),
                  style: textStyle,
                  controller: controllerTextEdit_titulo,
                )
              : Container(),
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
          enCatalogo
              ? widgetDeleteProducto(context: builderContext)
              : Container(),
        ],
      ),
    );
  }

  Widget widgetTextFieldMarca() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        new Flexible(
          child: InkWell(
            child: TextField(
              controller: TextEditingController()
                ..text = this.marca != null ? this.marca.titulo : "",
              enabled: false,
              enableInteractiveSelection: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 2)),
                labelText: "Marca",
              ),
              style: textStyle,
            ),
            onTap: () {
              showModalSelectMarca(buildContext: contextPrincipal);
            },
          ),
        ),
        this.marca!=null?Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              setState(() {
                this.marca=null;
              });
            },
          ),
        ):Container(),
      ],
    );
  }

  Widget widgetDeleteProducto({@required BuildContext context}) {
    return Column(
      children: [
        deleteIndicador == false
            ? SizedBox(
                width: double.infinity,
                child: RaisedButton.icon(
                  onPressed: () {
                    showDialogDelete(buildContext: context);
                  },
                  color: Colors.red[400],
                  icon: Icon(Icons.delete, color: Colors.white),
                  padding: EdgeInsets.all(12.0),
                  label: Text("Borrar producto",
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: RaisedButton.icon(
                  onPressed: () {},
                  color: Colors.red[400],
                  icon: Container(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(
                          backgroundColor: Colors.white)),
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
    );
  }

  void deleteProduct({@required BuildContext context}) async {
    setState(() {
      deleteIndicador = true;
    });
    // Firebase ( delete )
    await Global.getDataProductoNegocio(
            idNegocio: Global.prefs.getIdNegocio, idProducto: producto.id)
        .deleteDoc(); // Procede a eliminar el documento de la base de datos del catalogo de la cuenta
    // Emula un retardo de 2 segundos
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pop(context);
    });
  }

  void guardar({@required BuildContext buildContext}) async {
    if (this.categoria != null && this.categoria.id != "") {
      if (this.subcategoria != null && this.subcategoria.id != "") {
        if (producto.titulo != "") {
          if (producto.descripcion != "") {
            if (this.marca != null) {
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
                  StorageUploadTask uploadTask =
                      ref.putFile(File(_imageFile.path));
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
                producto.id_marca = this.marca.id;
                updateProductoGlobal();
                // Firebase set
                await Global.getDataProductoNegocio(
                        idNegocio: Global.prefs.getIdNegocio,
                        idProducto: producto.id)
                    .upSetProducto(producto.toJson());

                Navigator.pop(context);
              } else {
                viewSnackBar(
                    context: buildContext,
                    message: 'Asigne un precio de venta');
              }
            } else {
              viewSnackBar(
                  context: buildContext, message: 'Debe seleccionar una marca');
            }
          } else {
            viewSnackBar(
                context: buildContext, message: 'Debe elegir una descripción');
          }
        } else {
          viewSnackBar(context: buildContext, message: 'Debe elegir un titulo');
        }
      } else {
        viewSnackBar(
            context: buildContext, message: 'Debe elegir una subcategoría');
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

  showModalSelectMarca({@required BuildContext buildContext}) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (_) {
          // Variables
          List<Marca> listMarcasAll = new List<Marca>();
          return Scaffold(
            appBar: AppBar(
              title: Text("Marcas"),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    if (listMarcasAll.length != 0) {
                      // Muestra un "showSearch" y espera ah revolver un resultado
                      showSearch(
                              context: buildContext,
                              delegate: DataSearchMarcaProduct(
                                  listMarcas: listMarcasAll))
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            this.marca = value;
                          });
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            body: FutureBuilder(
              future: Global.getMarcasAll().getDataMarca(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listMarcasAll = snapshot.data;
                  if (listMarcasAll.length != 0) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shrinkWrap: true,
                      itemCount: listMarcasAll.length,
                      itemBuilder: (BuildContext context, int index) {
                        Marca marcaSelect = listMarcasAll[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: 24.0,
                                child: Text(marcaSelect.titulo.substring(0, 1),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              dense: true,
                              title: Text(marcaSelect.titulo),
                              onTap: () {
                                setState(() {
                                  this.marca = marcaSelect;
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

  void showDialogDelete({@required BuildContext buildContext}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "¿Seguro que quieres eliminar este producto de tu catálogo?"),
          content: new Text(
              "El producto será eliminado de tu catálogo y toda la información acumulada"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Borrar"),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProduct(context: buildContext);
              },
            ),
          ],
        );
      },
    );
  }
}
