import 'dart:io';
import 'package:producto/screens/page_marca_create.dart';
import 'package:producto/screens/widgets/widgetsCategoriViews.dart';
import 'package:flutter/services.dart';
import 'package:producto/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/models/models_catalogo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:producto/screens/widgets/widgetSeachMarcaProducto.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:producto/screens/widgets/widgets_notify.dart';

class ProductNew extends StatefulWidget {
  final String id;
  ProductNew({@required this.id});

  @override
  _ProductNewState createState() =>
      _ProductNewState(new ProductoNegocio(id: this.id));
}

class _ProductNewState extends State<ProductNew> {
  TextEditingController controllerTextEdit_titulo;
  TextEditingController controllerTextEdit_descripcion;
  MoneyMaskedTextController controllerTextEdit_precio_venta;
  MoneyMaskedTextController controllerTextEdit_compra;
  MoneyMaskedTextController controllerTextEdit_comparacion;

  _ProductNewState(this.producto);
  // Variables
  TextStyle textStyle = new TextStyle(fontSize: 24.0);
  bool enCatalogo =false; // verifica si el producto se encuentra en el catalogo o no
  Marca marca;
  Categoria categoria;
  Categoria subcategoria;
  bool saveIndicador = false;
  ProductoNegocio producto;
  BuildContext contextPrincipal;

  // Variables de imagen
  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    checkCatalogo();
    controllerTextEdit_titulo = TextEditingController(text: producto.titulo);
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
            title: Text(this.producto.id,
                style: TextStyle(
                    fontSize: 18.0,
                    color:
                        Theme.of(contextPrincipal).textTheme.bodyText1.color)),
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
                widgetFormEditText(builderContext: context),
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
            ? Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.0),
                  color: Colors.grey,
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                ),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    _onImageButtonPressed(ImageSource.gallery,context: context);
                  },
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  label: Text("Galeria",
                      style: TextStyle(fontSize: 18.0, color: Colors.white))),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MaterialButton(
                elevation: 1.0,
                color: Theme.of(context).accentColor,
                onPressed: () =>
                    _onImageButtonPressed(ImageSource.camera, context: context),
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
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Global.prefs.getIdNegocio!=""?Consumer<ProviderCatalogo>(
            child: Text("Cargando categorías"),
            builder: (context, catalogo, child) {

              // set ( values )
              this.categoria=catalogo.categoria;
              this.subcategoria=catalogo.subcategoria;

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Flexible(
                    child: InkWell(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = catalogo.categoria != null
                              ? catalogo.categoria.nombre
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
                  new SizedBox(
                    height: 12.0,
                    width: 12.0,
                  ),
                  new Flexible(
                    child: InkWell(
                      child: TextField(
                        controller: TextEditingController()
                          ..text = catalogo.subcategoria != null
                              ? catalogo.subcategoria.nombre
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
                        if (catalogo.categoria != null) {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            backgroundColor:
                                Theme.of(builderContext).canvasColor,
                            context: builderContext,
                            builder: (ctx) {
                              return ClipRRect(
                                child: ViewSubCategoria(buildContextCategoria: ctx,categoria:this.categoria),
                              );
                            });
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ):Container(),
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
                minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
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
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            enabled: !producto.verificado,
            onChanged: (value) => producto.descripcion = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Descripción"),
            style: textStyle,
            controller: controllerTextEdit_descripcion,
          ),
          Global.prefs.getIdNegocio!=""?Column(
            children: [
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
            ],
          ):Container(),
          
          SizedBox(height: 25.0),
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
        this.marca != null
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
  void guardar({@required BuildContext buildContext}) async {
    if (this.categoria != null || (this.categoria == null && Global.prefs.getIdNegocio=="") ) {
      if (this.subcategoria != null || (this.categoria == null && Global.prefs.getIdNegocio=="") ) {
        if (producto.titulo != "") {
          if (producto.descripcion != "") {
            if (this.marca != null) {
              if (producto.precio_venta != 0.0 || (producto.precio_venta == 0.0 && Global.prefs.getIdNegocio=="") ) {
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
                producto.timestamp_actualizacion=Timestamp.fromDate(new DateTime.now());
                  producto.timestamp_creation=Timestamp.fromDate(new DateTime.now());
                producto.categoria = this.categoria==null?"":this.categoria.id;
                producto.subcategoria = this.subcategoria==null?"":this.subcategoria.id;
                producto.id_marca = this.marca==null?"":this.marca.id;
                savevProductoGlobal();
                // Firebase set
                if( Global.prefs.getIdNegocio!="" ){
                  await Global.getDataProductoNegocio(idNegocio: Global.prefs.getIdNegocio,idProducto: producto.id).upSetProducto(producto.toJson());
                }
                
                Navigator.pop(context);
              } else {
                showSnackBar(
                    context: buildContext,
                    message: 'Asigne un precio de venta');
              }
            } else {
              showSnackBar(context: buildContext, message: 'Debe seleccionar una marca');
            }
          } else {
            showSnackBar(context: buildContext, message: 'Debe elegir una descripción');
          }
        } else {
          showSnackBar(context: buildContext, message: 'Debe elegir un titulo');
        }
      } else {
        showSnackBar(
            context: buildContext, message: 'Debe elegir una subcategoría');
      }
    } else {
      showSnackBar(context: buildContext, message: 'Debe elegir una categoría');
    }
  }

  void savevProductoGlobal() async {
    // Valores para registrar el precio
    if( Global.prefs.getIdNegocio!="" ){
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
    }
    
    if (urlIamgen == "") {
      producto.timestamp_actualizacion=Timestamp.fromDate(new DateTime.now());
      producto.urlimagen="default";
    } else {
      producto.timestamp_actualizacion=Timestamp.fromDate(new DateTime.now());
      producto.urlimagen=urlIamgen;
    }
    // Firebase set
    await Global.getProductosPrecargado(idProducto: producto.id, isoPAis: "ARG")
        .upSetPrecioProducto(producto.convertProductoDefault().toJson());
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
                  onPressed:() {
                    Navigator.of(buildContext).push(MaterialPageRoute(
                    builder: (BuildContext context) => PageCreateMarca())).then((value){
                      setState(() {
                        Navigator.of(buildContext).pop();
                            this.marca = value;
                            this.producto.titulo=this.marca.titulo;
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
                            this.marca = value;
                            this.producto.titulo=this.marca.titulo;
                            Navigator.pop(buildContext);
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
                                  this.producto.titulo=this.marca.titulo;
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
