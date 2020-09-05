
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:catalogo/models/models_profile.dart';
import 'package:catalogo/screens/page_producto_edit.dart';
import 'package:catalogo/services/models.dart';
import 'package:catalogo/shared/widgets_load.dart';
import 'package:flutter/material.dart';
import 'package:catalogo/utils/utils.dart';
import 'package:catalogo/services/globals.dart';
import 'package:geolocator/geolocator.dart';

class ProductScreen extends StatelessWidget {
  String sSignoMoneda;
  final ProductoNegocio producto;

  ProductScreen({this.producto, this.sSignoMoneda});

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
            Text(this.producto.id,style: TextStyle(fontSize: 18.0,color: Theme.of(context).textTheme.bodyText1.color)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetImagen(producto: producto),
            WidgetDescripcion(context),
            WidgetUltimosPrecios(producto: producto),
            WidgetOtrosProductos(producto: producto),
          ],
        ),
      ),
    );
  }

  Padding WidgetDescripcion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          producto.titulo != ""
              ? Container(
                  child: Text(producto.titulo,
                      style: TextStyle(
                          height: 2,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      softWrap: false),
                )
              : Container(),
          producto.descripcion != ""
              ? Text(producto.descripcion,
                  style: TextStyle(
                      height: 1, fontSize: 16, fontWeight: FontWeight.normal))
              : Container(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              producto.precio_venta != 0.0
                  ? Text(
                      Publicaciones.getFormatoPrecio(monto: producto.precio_venta),
                      style: TextStyle(height: 2, fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                child: SizedBox(
                  height: 50,
                  child: RaisedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => producto != null
                            ? ProductEdit(producto: producto)
                            : Scaffold(
                                body: Center(
                                    child: Text("Se produjo un Error!"))),
                      ));
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                    label: Text('Editar',
                        style: TextStyle(fontSize: 18.0, color: Colors.white)),
                    icon: Container(), // Icon( Icons.add,color: Colors.white),
                    textColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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
    Key key,
    @required this.producto,
  }) : super(key: key);

  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return Container(
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
        tag: producto.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0.0),
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fadeInDuration: Duration(milliseconds: 200),
            fit: BoxFit.cover,
            imageUrl: producto.urlimagen,
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
            padding: EdgeInsets.all(12.0)),
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
      future:
          Global.getListPreciosProducto(idProducto: producto.id, isoPAis: "ARG").getDataPreciosProductosAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Precio> listaPrecios = snapshot.data;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              listaPrecios.length!=0?Divider(endIndent: 12.0, indent: 12.0):Container(),
              listaPrecios.length!=0?Padding(
                padding: EdgeInsets.all(12.0),
                child: Text("Ultimos precios registrados",style: TextStyle(fontSize: 16.0)),
              ):Container(),
              ListView.builder(
                //physics: const AlwaysScrollableScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 0.0),
                shrinkWrap: true,
                itemCount: listaPrecios.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: Global.getNegocio(idNegocio: listaPrecios[index].id_negocio).getDataPerfilNegocio(),
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
                                dense: true,
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
                                                  .timestamp.toDate(),
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
                                    FutureBuilder(
                                      future: getLocation(
                                          latitude:
                                              perfilNegocio.geopoint.latitude,
                                          longitude:
                                              perfilNegocio.geopoint.longitude),
                                      builder: (context, snapshot) {
                                        return snapshot.data.toString() == ""
                                            ? Text("")
                                            : Text(
                                                "En " +
                                                    snapshot.data.toString(),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                      },
                                    ),
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
          return Container();
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
                              padding: EdgeInsets.all(10.0),
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
                                          "${producto.signo_moneda}${producto.precio_venta}",
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

