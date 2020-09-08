import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/services.dart';
import 'package:catalogo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:loadany/loadany_widget.dart';
import 'package:provider/provider.dart';

import '../page_producto_view.dart';

class WidgetCatalogoGridList extends StatefulWidget {
  @override
  _WidgetCatalogoGridListState createState() {
    return _WidgetCatalogoGridListState();
  }
}

class _WidgetCatalogoGridListState extends State<WidgetCatalogoGridList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderCatalogo>(
      child: Center(
        child: Text("Cargando..."),
      ),
      builder: (comsumerContext, catalogo, child) {
        return _gridListProductos(
            buildContext: context, providerCatalogo: catalogo);
      },
    );
  }

/* Generamos una GridList de los productos */
  Widget _gridListProductos(
      {BuildContext buildContext, ProviderCatalogo providerCatalogo}) {
    //Provider ( set )
    //buildContext.read<ProviderPerfilNegocio>().setCantidadProductos =Global.listProudctosNegocio.length;
    //buildContext.read<ProviderMarcasProductos>().listMarcas.clear();

    return providerCatalogo.getCatalogo.length != 0
        ? LoadAny(
            onLoadMore: providerCatalogo.getLoadMore,
            status: providerCatalogo.statusCargaGridListCatalogo,
            loadingMsg: 'Cargando...',
            errorMsg: 'errorMsg',
            finishMsg: providerCatalogo.listCatalogoFilter.length == 1
                ? providerCatalogo.listCatalogoFilter.length.toString() +
                    " resultado"
                : providerCatalogo.listCatalogoFilter.length.toString() +
                    " resultados",
            child: CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ProductoItem(
                          producto: providerCatalogo.getCatalogo[index]);
                    },
                    childCount: providerCatalogo.getCatalogo.length,
                  ),
                ),
              ],
            ),
          )
        : Expanded(
            child: Center(child: Text("Sin productos")),
          );
  }
}

class ProductoItem extends StatelessWidget {
  final ProductoNegocio producto;
  final double width;
  const ProductoItem({Key key, this.producto, this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   /*  return FutureBuilder(
      initialData: producto,
      future: Global.getProductosPrecargado(idProducto: producto.id).getDataProductoGlobal(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Producto productoGlobal = snapshot.data;

          return Center(child: Text(productoGlobal.titulo),);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ); */

    return Container(
      width: width,
      child: Hero(
        tag: producto.id,
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
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
                    WidgetImagenProducto(producto: producto),
                    WidgetContentInfo(producto: producto),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetImagenProducto extends StatelessWidget {
  const WidgetImagenProducto({@required this.producto});
  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
              errorWidget: (context, url, error) => Center(
                child: Text(
                  producto.titulo.substring(0, 3),
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            )
          : Container(color: Colors.black26),
    );
  }
}

class WidgetContentInfo extends StatelessWidget {
  const WidgetContentInfo({@required this.producto});
  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13), topRight: Radius.circular(13)),
      child: Container(
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
                      producto.titulo != "" && producto.titulo != "default"
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
                              Publicaciones.getFormatoPrecio(
                                  monto: producto.precio_venta),
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
    );
  }
}
