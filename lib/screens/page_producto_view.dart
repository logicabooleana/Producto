import 'package:cached_network_image/cached_network_image.dart';
import 'package:producto/models/models_catalogo.dart';
import 'package:producto/models/models_profile.dart';
import 'package:producto/screens/page_producto_edit.dart';
import 'package:producto/services/models.dart';
import 'package:producto/shared/widgets_load.dart';
import 'package:flutter/material.dart';
import 'package:producto/utils/utils.dart';
import 'package:producto/services/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:producto/shared/widgets_image_circle.dart' as image;

class ProductScreen extends StatefulWidget {
  // Variables

  String sSignoMoneda;
  ProductoNegocio producto;

  ProductScreen({this.producto, this.sSignoMoneda});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Categoria categoria;
  Categoria subcategoria;
  Marca marca;
  BuildContext contextScaffold;
  bool productoEnCatalogo = false;

  @override
  void initState() {
    getMarca();
    getCategoriaProducto();
    super.initState();
  }

  void getMarca() async {
    // Defaul values
    this.marca = null;
    if (widget.producto != null) {
      if (widget.producto.id_marca != "") {
        Global.getMarca(idMarca: widget.producto.id_marca)
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
    if( Global.oPerfilNegocio != null ){
      Global.getDataCatalogoCategoria(
            idNegocio: Global.oPerfilNegocio.id,
            idCategoria: widget.producto.categoria)
        .getDataCategoria()
        .then((value) {
      this.categoria = value ?? Categoria();
      if (this.categoria.subcategorias != null) {
        this.categoria.subcategorias.forEach((k, v) {
          Categoria subcategoria =
              new Categoria(id: k.toString(), nombre: v.toString());
          if (subcategoria.id == widget.producto.subcategoria) {
            this.subcategoria = subcategoria ?? Categoria();
          }
        });
      }
      setState(() {});
    });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    if (Global.oPerfilNegocio != null) {
      for (ProductoNegocio item in Global.listProudctosNegocio) {
        if (item.id == widget.producto.id) {
          widget.producto = item;
          productoEnCatalogo = true;
          break;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).textTheme.bodyText1.color),
        title: InkWell(
          onTap: () {
            if (contextScaffold != null) {
              Clipboard.setData(new ClipboardData(text: widget.producto.codigo))
                  .then((_) {
                Scaffold.of(contextScaffold).showSnackBar(
                    SnackBar(content: Text("Código copiado en portapapeles")));
              });
            }
          },
          child: Row(
            children: <Widget>[
              widget.producto.verificado == true
                  ? Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: new Image.asset('assets/icon_verificado.png',
                          width: 20.0, height: 20.0))
                  : new Container(),
              Text(this.widget.producto.id,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).textTheme.bodyText1.color)),
            ],
          ),
        ),
        actions: [
          Global.oPerfilNegocio != null
              ? IconButton(
                  padding: EdgeInsets.all(12.0),
                  icon: Icon(productoEnCatalogo ? Icons.edit : Icons.add_box),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => widget.producto != null
                          ? ProductEdit(producto: widget.producto)
                          : Scaffold(
                              body:
                                  Center(child: Text("Se produjo un Error!"))),
                    ));
                  },
                )
              : Container(),
        ],
      ),
      body: Stack(
        children: [
          Builder(builder: (contextBuilder) {
            contextScaffold = contextBuilder;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetImagen(producto: widget.producto, marca: this.marca),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetDescripcion(context),
                        //WidgetUltimosPrecios(producto: widget.producto),
                        productoEnCatalogo
                            ? WidgetOtrosProductos(producto: widget.producto)
                            : Container(),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 140.0,
                    width: 140.0,
                  ),
                ],
              ),
            );
          }),
          DraggableScrollableSheet(

            initialChildSize: 0.2,
            minChildSize: 0.1,
            maxChildSize: 0.85,
            builder: (BuildContext context, myscrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0,vertical:8.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: ListView(
                  controller: myscrollController,
                  children: [
                    productoEnCatalogo
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              widget.producto.precio_venta != null &&
                                      widget.producto.precio_venta != 0.0
                                  ? Text(
                                      Publicaciones.getFormatoPrecio(
                                          monto: widget.producto.precio_venta),
                                      style: TextStyle(
                                          height: 2,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end,
                                    )
                                  : Container(),
                              widget.producto.timestamp_actualizacion != null
                                  ? Text(
                                      Publicaciones.getFechaPublicacion(
                                              widget.producto
                                                  .timestamp_actualizacion
                                                  .toDate(),
                                              new DateTime.now())
                                          .toLowerCase(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54),
                                    )
                                  : Container(),
                            ],
                          )
                        : Container(),
                    Icon(Icons.keyboard_arrow_up),
                    WidgetUltimosPrecios(producto: widget.producto),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Padding WidgetDescripcion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          productoEnCatalogo
              ? Row(
                  children: [
                    this.categoria != null && this.categoria.nombre != ""
                        ? Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                  this.categoria.nombre.substring(0, 1) ?? "C"),
                            ),
                            label: Text(this.categoria.nombre),
                          )
                        : Container(),
                    this.categoria != null
                        ? SizedBox(
                            width: 3.0,
                          )
                        : Container(),
                    this.subcategoria != null && this.subcategoria.nombre != ""
                        ? Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                  this.subcategoria.nombre.substring(0, 1) ??
                                      "C"),
                            ),
                            label: Text(this.subcategoria.nombre),
                          )
                        : Container(),
                  ],
                )
              : Container(),
          widget.producto.titulo != ""
              ? Container(
                  child: Text(widget.producto.titulo,
                      style: TextStyle(
                          height: 2, fontSize: 30, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      softWrap: false),
                )
              : Container(),
          SizedBox(
            height: 8.0,
            width: 8.0,
          ),
          widget.producto.descripcion != ""
              ? Text(widget.producto.descripcion,
                  style: TextStyle(
                      height: 1, fontSize: 16, fontWeight: FontWeight.normal))
              : Container(),
          /* productoEnCatalogo
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.producto.precio_venta != null &&
                            widget.producto.precio_venta != 0.0
                        ? Text(
                            Publicaciones.getFormatoPrecio(
                                monto: widget.producto.precio_venta),
                            style: TextStyle(
                                height: 2,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          )
                        : Container(),
                    widget.producto.timestamp_actualizacion != null
                        ? Text(
                            Publicaciones.getFechaPublicacion(
                                    widget.producto.timestamp_actualizacion
                                        .toDate(),
                                    new DateTime.now())
                                .toLowerCase(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.black54),
                          )
                        : Container(),
                  ],
                )
              : Container(), */
        ],
      ),
    );
  }

  Widget _buildIcon(int index) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          color: Color(0xFFE7EBEE),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          Icons.ac_unit,
          size: 25.0,
          color: Color(0xFFB4C1C4),
        ),
      ),
    );
  }
}

class WidgetImagen extends StatelessWidget {
  const WidgetImagen({
    @required this.producto,
    @required this.marca,
  });

  final ProductoNegocio producto;
  final Marca marca;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Hero(
        tag: producto.id,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                fadeInDuration: Duration(milliseconds: 200),
                fit: BoxFit.cover,
                imageUrl: producto.urlimagen ?? "default",
                placeholder: (context, url) => FadeInImage(
                    image: AssetImage("assets/loading.gif"),
                    placeholder: AssetImage("assets/loading.gif")),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      producto.titulo.substring(0, 3),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.25),
                    ),
                  ),
                ),
              ),
            ),
            this.marca != null
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Chip(
                      avatar: image.viewCircleImage(
                          url: marca.url_imagen, texto: marca.titulo, size: 20),
                      label: Text(marca.titulo),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class WidgetOtrosProductos extends StatelessWidget {
  const WidgetOtrosProductos({
    Key key,
    @required this.producto,
  }) : super(key: key);

  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(endIndent: 12.0, indent: 12.0),
        Padding(
          child: Text("Otros productos", style: TextStyle(fontSize: 16.0)),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: Global.listProudctosNegocio.length,
            itemBuilder: (context, index) {
              if (Global.listProudctosNegocio[index].subcategoria ==
                  producto.subcategoria) {
                return Container(
                    width: 150.0,
                    height: 150.0,
                    child: ProductoItemHorizontal(
                      producto: Global.listProudctosNegocio[index],
                    ));
              } else {
                return Container();
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

class WidgetUltimosPrecios extends StatelessWidget {
  const WidgetUltimosPrecios({
    Key key,
    @required this.producto,
  }) : super(key: key);

  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Global.getListPreciosProducto(idProducto: producto.id).getDataPreciosProductosAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Precio> listaPrecios = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Text(listaPrecios.length != 0?"Ultimos precios registrados":"No se registró ningún precio para este producto",
                          style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center,),
                    ),
              ListView.builder(
                //physics: const AlwaysScrollableScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 0.16),
                shrinkWrap: true,
                itemCount: listaPrecios.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: Global.getNegocio(
                              idNegocio: listaPrecios[index].id_negocio)
                          .getDataPerfilNegocio(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          PerfilNegocio perfilNegocio = snapshot.data;
                          return Column(
                            children: <Widget>[
                              ListTile(
                                leading: listaPrecios[index].id_negocio == "" ||
                                        perfilNegocio.imagen_perfil == "default"
                                    ? CircleAvatar(
                                        backgroundColor: Colors.black26,
                                        radius: 24.0,
                                        child: Text(
                                            perfilNegocio.nombre_negocio
                                                .substring(0, 1),
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: perfilNegocio.imagen_perfil,
                                        placeholder: (context, url) =>
                                            const CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: 24.0,
                                        ),
                                        imageBuilder: (context, image) =>
                                            CircleAvatar(
                                          backgroundImage: image,
                                          radius: 24.0,
                                        ),
                                      ),
                                title: Text(
                                  Publicaciones.getFormatoPrecio(
                                      monto: listaPrecios[index].precio),
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      Publicaciones.getFechaPublicacion(
                                              listaPrecios[index]
                                                  .timestamp
                                                  .toDate(),
                                              new DateTime.now())
                                          .toLowerCase(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white70
                                              : Colors.black54),
                                    ),
                                    listaPrecios[index].ciudad != ""
                                        ? Text(
                                            "En " +
                                                listaPrecios[index]
                                                    .ciudad
                                                    .toString(),
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0),
                                          )
                                        : Text("Ubicación desconocido",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12.0)),
                                  ],
                                ),
                                onTap: () {},
                              ),
                              SizedBox(
                                height: 7.0,
                              )
                            ],
                          );
                        } else {
                          return WidgetsLoad();
                        }
                      });
                },
              ),
            ],
          );
        } else {
          return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 12.0),
                      child: Text("No se registró ningún precio para este producto",
                          style: TextStyle(fontSize: 20.0)),
                    );
        }
      },
    );
  }
}

Future<String> getLocation({double latitude, double longitude}) async {
  if (latitude != 0.0 && latitude != 0.0) {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    return placemark[0].locality;
  }

  return "ubicación desconocida";
}

class ProductoItemHorizontal extends StatelessWidget {
  final ProductoNegocio producto;
  final double width;
  const ProductoItemHorizontal(
      {Key key, this.producto, this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Card(
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => producto != null
                    ? ProductScreen(producto: producto)
                    : Scaffold(
                        body: Center(child: Text("Se produjo un Error!"))),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 100 / 100,
                    child: producto.urlimagen != ""
                        ? CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 200),
                            fit: BoxFit.cover,
                            imageUrl: producto.urlimagen,
                            placeholder: (context, url) => FadeInImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/loading.gif"),
                                placeholder: AssetImage("assets/loading.gif")),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.black12),
                          )
                        : Container(color: Colors.black26),
                  ),
                  Container(
                    color: Colors.black54,
                    child: ClipRect(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                children: <Widget>[
                                  producto.titulo != "" &&
                                          producto.titulo != "default"
                                      ? Text(producto.titulo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          softWrap: false)
                                      : Container(),
                                  producto.descripcion != ""
                                      ? Text(producto.descripcion,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          softWrap: false)
                                      : Container(),
                                  producto.precio_venta != 0.0
                                      ? Text(
                                          "${Publicaciones.getFormatoPrecio(monto: producto.precio_venta)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          softWrap: false)
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          // Text(topic.description)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProviderProductoView with ChangeNotifier {
  ProductoNegocio _producto = new ProductoNegocio();

//Creamos el método Get, para poder obtener el valor de mitexto
  ProductoNegocio get getHashMaplistaMarca => _producto;

//Ahora creamos el método set para poder actualizar el valor de _mitexto, este método recibe un valor newTexto de tipo String
  set setHashMaplistaMarca(ProductoNegocio producto) {
    _producto = producto;
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }
}
