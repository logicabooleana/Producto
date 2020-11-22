import 'dart:io';
import 'package:producto/screens/page_marca_create.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:producto/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/models/models_catalogo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/screens/widgets/widgetSeachMarcaProducto.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:producto/screens/widgets/widgets_notify.dart';
import 'package:producto/shared/progress_bar.dart';

class ProductEdit extends StatefulWidget {
  final ProductoNegocio producto;
  ProductEdit({@required this.producto});

  @override
  _ProductEditState createState() => _ProductEditState(producto);
}

class _ProductEditState extends State<ProductEdit> {
  // Controllers
  TextEditingController controllerTextEdit_descripcion;
  MoneyMaskedTextController controllerTextEdit_precio_venta;
  MoneyMaskedTextController controllerTextEdit_compra;
  MoneyMaskedTextController controllerTextEdit_comparacion;

  // Variables
  TextStyle textStyle = new TextStyle(fontSize: 24.0);
  TextStyle textStyle_disabled =new TextStyle(fontSize: 24.0, color: Colors.grey);
  bool enCatalogo =false; // verifica si el producto se encuentra en el catalogo o no
  bool editable = false; // TODO : Eliminar para produccion
  Marca marca;
  Categoria categoria;
  Categoria subcategoria;
  bool saveIndicador = false;
  bool deleteIndicador = false;
  ProductoNegocio producto;
  BuildContext contextPrincipal;
  Color colorCargando=Colors.orangeAccent;
  Color colorSaveOk=Colors.green;
  _ProductEditState(this.producto);

  @override
  void initState() {
    checkCatalogo();
    getMarca();
    getCategoriaProducto();
    controllerTextEdit_descripcion =
        TextEditingController(text: producto.descripcion);
    controllerTextEdit_precio_venta = MoneyMaskedTextController(
        initialValue: producto.precio_venta,
        decimalSeparator: ',',
        thousandSeparator: '.',
        precision: 2);
    controllerTextEdit_compra = MoneyMaskedTextController(
        initialValue: producto.precio_compra,
        decimalSeparator: ',',
        thousandSeparator: '.',
        precision: 2);
    controllerTextEdit_comparacion = MoneyMaskedTextController(
        initialValue: producto.precio_comparacion,
        decimalSeparator: ',',
        thousandSeparator: '.',
        precision: 2);
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
    // Obtenemos la identificacion de la categoria del producto
    Global.getDataCatalogoCategoria(
            idNegocio: Global.oPerfilNegocio.id,
            idCategoria: producto.categoria)
        .getDataCategoria()
        .then((value) {
      this.categoria = value ?? Categoria();
      if (this.categoria.subcategorias != null) {
        this.categoria.subcategorias.forEach((k, v) {
          Categoria subcategoria =
              new Categoria(id: k.toString(), nombre: v.toString());
          if (subcategoria.id == this.producto.subcategoria) {
            setState(() {
              this.subcategoria = subcategoria ?? Categoria();
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    controllerTextEdit_descripcion.dispose();
    controllerTextEdit_precio_venta.dispose();
    controllerTextEdit_compra.dispose();
    controllerTextEdit_comparacion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext contextPrincipal) {
    textStyle_disabled =
        new TextStyle(fontSize: 24.0, color: Theme.of(context).hintColor);
    this.contextPrincipal = contextPrincipal;

    return Scaffold(
      body: Builder(builder: (contextBuilder) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Theme.of(context).canvasColor ,
            iconTheme: Theme.of(contextPrincipal).iconTheme.copyWith(
                color: Theme.of(contextPrincipal).textTheme.bodyText1.color),
            title: saveIndicador ?Text("Actualizando...",style: TextStyle(fontSize: 18.0,color:Theme.of(contextPrincipal).textTheme.bodyText1.color)):Row(
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
                      : Container(),
                  onPressed: () {
                    guardar(buildContext: contextBuilder);
                  }),
            ],
            bottom: saveIndicador ? linearProgressBarApp() : null,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetsImagen(),
                widgetFormEditText(builderContext: context),
              ],
            ),
          ),
        );
      }),
    );
  }

  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
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
        producto.verificado == false
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              new Flexible(
                child: InkWell(
                  child: TextField(
                    controller: TextEditingController()
                      ..text =
                          this.categoria != null ? this.categoria.nombre : "",
                    enabled: false,
                    enableInteractiveSelection: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
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
                        border: OutlineInputBorder(borderSide:BorderSide(color: Colors.grey, width: 2)),
                        labelText: "Subcategoría"),
                    style: textStyle,
                  ),
                  onTap: () {
                    if (this.categoria != null) {
                      getSubCategoria(
                          buildContext: builderContext,
                          categoria: this.categoria);
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.0,
            width: 16.0,
          ),
          widgetTextFieldMarca(),
          SizedBox(
                  height: 16.0,
                  width: 16.0,
                ),
          TextField(
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            enabled: !producto.verificado,
            onChanged: (value) => producto.descripcion = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(borderSide:BorderSide(color:editable? Colors.grey: Colors.transparent ,width: 2)),
                labelText: "Descripción"),
            style: producto.verificado ? textStyle_disabled : textStyle,
            controller: controllerTextEdit_descripcion,
          ),
          SizedBox(height: 16.0),
          TextField(
            //inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => producto.precio_venta =
                controllerTextEdit_precio_venta.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de venta"),
            style: textStyle,
            controller: controllerTextEdit_precio_venta,
          ),
          SizedBox(height: 16.0),
          TextField(
            //inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => producto.precio_compra =
                controllerTextEdit_precio_venta.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de compra"),
            style: textStyle,
            controller: controllerTextEdit_compra,
          ),
          SizedBox(height: 16.0),
          TextField(
            //inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => producto.precio_comparacion =
                controllerTextEdit_precio_venta.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Precio de comparación"),
            style: textStyle,
            controller: controllerTextEdit_comparacion,
          ),
          SizedBox(height: 25.0),
          enCatalogo
              ? saveIndicador == false
                  ? widgetDeleteProducto(context: builderContext)
                  : Container()
              : Container(),
          saveIndicador == false
              ? widgetSaveProductoOPTDeveloper(context: builderContext)
              : Container(),
          saveIndicador == false
              ? widgetDeleteProductoOPTDeveloper(context: builderContext)
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
                border: OutlineInputBorder(),
                disabledBorder: OutlineInputBorder(borderSide:BorderSide(color:editable? Colors.grey: Colors.transparent )),
                labelText: "Marca",
              ),
              
              style: producto.verificado ? textStyle_disabled : textStyle,
            ),
            onTap: () {
              if (producto.verificado == false) {
                showModalSelectMarca(buildContext: contextPrincipal);
              }
            },
          ),
        ),
        this.marca != null && producto.verificado == false
            ? Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      this.marca = null;
                    });
                  },
                ),
              )
            : Container(),
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
                  label: Text("Quitar producto de mi catalogo",
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
    if (this.categoria != null) {
      if (this.subcategoria != null) {
          if (controllerTextEdit_descripcion.text != "") {
            if (this.marca != null) {
              if (controllerTextEdit_precio_venta.numberValue != 0.0) {
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
                // Set ( values )
                // TODO: Por defecto verificado es TRUE // Cambiar esto cuando se lanze a producción
                producto.verificado = true;
                producto.titulo = this.marca.titulo;
                producto.descripcion = controllerTextEdit_descripcion.text;
                producto.precio_venta =
                    controllerTextEdit_precio_venta.numberValue;
                producto.precio_compra = controllerTextEdit_compra.numberValue;
                producto.precio_comparacion =
                    controllerTextEdit_comparacion.numberValue;
                producto.timestamp_actualizacion =
                    Timestamp.fromDate(new DateTime.now());
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
                showSnackBar(
                    context: buildContext,
                    message: 'Asigne un precio de venta');
              }
            } else {
              showSnackBar(
                  context: buildContext, message: 'Debe seleccionar una marca');
            }
          } else {
            showSnackBar(
                context: buildContext, message: 'Debe elegir una descripción');
          }
      } else {
        showSnackBar(
            context: buildContext, message: 'Debe elegir una subcategoría');
      }
    } else {
      showSnackBar(context: buildContext, message: 'Debe elegir una categoría');
    }
  }

  void updateProductoGlobal() async {
    // Valores para registrar el precio
    Precio precio = new Precio(
        id_negocio: Global.oPerfilNegocio.id,
        precio: producto.precio_venta,
        moneda: producto.signo_moneda,
        provincia: Global.oPerfilNegocio.provincia,
        ciudad: Global.oPerfilNegocio.ciudad,
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
    await Global.getProductosPrecargado(idProducto: producto.id)
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

  // VIEWS
  getCategoria({@required BuildContext buildContext}) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (ctx) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Categoría"),
              actions: [
                IconButton(
                  onPressed: () => _showDialogCreateCategoria(),
                  icon: Icon(Icons.add),
                ),
              ],
            ),
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
                                      categoria: this.categoria);
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

  _showDialogCreateCategoria() async {
    bool loadSave = false;
    Categoria categoria = new Categoria();
    categoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    TextEditingController controller = TextEditingController();

    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: controller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Categoria', hintText: 'Ej. golosinas'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: loadSave == false
                  ? Text('GUARDAR')
                  : CircularProgressIndicator(),
              onPressed: () async {
                if (controller.text != "") {
                  setState(() {
                    loadSave = true;
                  });
                  categoria.nombre = controller.text;
                  await Global.getDataCatalogoCategoria(
                          idNegocio: Global.oPerfilNegocio.id,
                          idCategoria: categoria.id)
                      .upSetCategoria(categoria.toJson());
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }

  _showDialogCreateSubCategoria({@required Categoria categoria}) async {
    Categoria subcategoria = new Categoria();
    subcategoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    bool loadSave = false;
    TextEditingController controller = TextEditingController();

    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: controller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Subcategoria', hintText: 'Ej. chocolates'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: loadSave == false
                  ? Text('GUARDAR')
                  : CircularProgressIndicator(),
              onPressed: () async {
                if (controller.text != "") {
                  setState(() {
                    loadSave = true;
                  });
                  subcategoria.nombre = controller.text;
                  categoria.subcategorias[subcategoria.id]=subcategoria.nombre;
                  await Global.getDataCatalogoCategoria(
                          idNegocio: Global.oPerfilNegocio.id,
                          idCategoria: categoria.id)
                      .upSetCategoria(categoria.toJson());
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }

  getSubCategoria({@required BuildContext buildContext, @required Categoria categoria}) {
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Subcategoria"),
              actions: [
                IconButton(
                  onPressed: () => _showDialogCreateSubCategoria(categoria: categoria),
                  icon: Icon(Icons.add),
                ),
              ],),
            body: categoria.subcategorias != null
                ? ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    shrinkWrap: true,
                    itemCount: categoria.subcategorias.length,
                    itemBuilder: (context, index) {
                      Categoria subcategoria = new Categoria(
                          id: categoria.subcategorias.keys
                              .elementAt(index)
                              .toString(),
                          nombre: categoria.subcategorias.values
                              .elementAt(index)
                              .toString());

                      if (categoria.subcategorias.length != 0) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.black26,
                                radius: 24.0,
                                child: Text(subcategoria.nombre.substring(0, 1),
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              dense: true,
                              title: Text(subcategoria.nombre),
                              onTap: () {
                                setState(() {
                                  this.subcategoria = subcategoria;
                                  Navigator.pop(buildContext);
                                });
                              },
                            ),
                            Divider(endIndent: 12.0, indent: 12.0),
                          ],
                        );
                      } else {
                        return Center(child: Text("Sin subcategoria"));
                      }
                    },
                  )
                : Center(child: Text("Sin subcategoria")),
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
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(buildContext)
                        .push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PageCreateMarca()))
                        .then((value) {
                      setState(() {
                        Navigator.of(buildContext).pop();
                        this.marca = value;
                        this.producto.titulo = this.marca.titulo;
                      });
                    });
                  },
                ),
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
                            Navigator.of(buildContext).pop();
                            this.marca = value;
                            this.producto.titulo = this.marca.titulo;
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
                                  this.producto.titulo = this.marca.titulo;
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

  // TODO: OPCIONES PARA EL DESARROLLADOR ( Eliminar para producción )
  Widget widgetSaveProductoOPTDeveloper({@required BuildContext context}) {
    return Column(
      children: [
        deleteIndicador == false
            ? SizedBox(
                width: double.infinity,
                child: RaisedButton.icon(
                  onPressed: () {
                    if (editable) {
                      guardarDeveloper(buildContext: context);
                    } else {
                      setState(() {
                        editable = true;
                        producto.verificado = false;
                      });
                    }
                  },
                  color: editable ? Colors.green[400] : Colors.orange[400],
                  icon: Icon(Icons.security, color: Colors.white),
                  padding: EdgeInsets.all(12.0),
                  label: Text(
                      editable ? "Actualizar producto Global" : "Editar",
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              )
            : Container(),
        SizedBox(height: 25.0),
      ],
    );
  }

  Widget widgetDeleteProductoOPTDeveloper({@required BuildContext context}) {
    return Column(
      children: [
        deleteIndicador == false
            ? SizedBox(
                width: double.infinity,
                child: RaisedButton.icon(
                  onPressed: () {
                    showDialogDeleteOPTDeveloper(buildContext: context);
                  },
                  color: Colors.red[400],
                  icon: Icon(Icons.security, color: Colors.white),
                  padding: EdgeInsets.all(12.0),
                  label: Text("Borrar producto",
                      style: TextStyle(fontSize: 18.0, color: Colors.white)),
                ),
              )
            : Container(),
        SizedBox(height: 25.0),
      ],
    );
  }

  void showDialogDeleteOPTDeveloper({@required BuildContext buildContext}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "¿Seguro que quieres eliminar este producto definitivamente? (Desarrollador)"),
          content: new Text(
              "El producto será eliminado de tu catálogo ,de la base de dato global y toda la información acumulada menos el historial de precios registrado"),
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
                deleteProductOPTDeveloper(context: buildContext);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteProductOPTDeveloper({@required BuildContext context}) async {
    setState(() {
      deleteIndicador = true;
    });
    // Storage ( delete )
    if (producto.urlimagen != "") {
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child("APP")
          .child("ARG")
          .child("PRODUCTOS")
          .child(producto.id);
      await ref.delete(); // Procede a eliminar el archivo de la base de datos
    }
    // Firebase ( delete )
    await Global.getDataProductoNegocio(
            idNegocio: Global.prefs.getIdNegocio, idProducto: producto.id)
        .deleteDoc(); // Procede a eliminar el documento de la base de datos del catalogo de la cuenta
    await Global.getProductosPrecargado(idProducto: producto.id)
        .deleteDoc(); // Procede a eliminar el documento de la base de datos del catalogo de la cuenta
    // Emula un retardo de 2 segundos
    Future.delayed(const Duration(milliseconds: 5000), () {
      Navigator.pop(context);
    });
  }

  void guardarDeveloper({@required BuildContext buildContext}) async {
    if (this.categoria != null) {
      if (this.subcategoria != null) {
          if (controllerTextEdit_descripcion.text != "") {
            if (this.marca != null) {
              if (controllerTextEdit_precio_venta.numberValue != 0.0) {
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

                producto.titulo = this.marca.titulo;
                producto.descripcion = controllerTextEdit_descripcion.text;
                producto.precio_venta =
                    controllerTextEdit_precio_venta.numberValue;
                producto.precio_compra = controllerTextEdit_compra.numberValue;
                producto.precio_comparacion =
                    controllerTextEdit_comparacion.numberValue;
                producto.timestamp_actualizacion =
                    Timestamp.fromDate(new DateTime.now());
                producto.categoria = this.categoria.id;
                producto.subcategoria = this.subcategoria.id;
                producto.id_marca = this.marca.id;
                producto.codigo=producto.id;
                updateProductoGlobalDeveloper();
                // Firebase set
                if (Global.prefs.getIdNegocio != "") {
                  await Global.getDataProductoNegocio(
                          idNegocio: Global.prefs.getIdNegocio,
                          idProducto: producto.id)
                      .upSetProducto(producto.toJson());
                }

                Navigator.pop(context);
              } else {
                showSnackBar(
                    context: buildContext,
                    message: 'Asigne un precio de venta');
              }
            } else {
              showSnackBar(
                  context: buildContext, message: 'Debe seleccionar una marca');
            }
          } else {
            showSnackBar(
                context: buildContext, message: 'Debe elegir una descripción');
          }
      } else {
        showSnackBar(
            context: buildContext, message: 'Debe elegir una subcategoría');
      }
    } else {
      showSnackBar(context: buildContext, message: 'Debe elegir una categoría');
    }
  }

  void updateProductoGlobalDeveloper() async {
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
    // set ( id del usuario que actualizo el producto )
    producto.id_negocio = Global.oPerfilNegocio.id;
    //producto.id_usuario=Global.us;
    // Firebase set
    await Global.getProductosPrecargado(idProducto: producto.id)
        .upSetPrecioProducto(producto.convertProductoDefault().toJson());
  }
}
