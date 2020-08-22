import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/services.dart';
import 'package:catalogo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../page_producto_view.dart';

class WidgetCatalogoGridList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final servicesCatalogo = Provider.of<ProviderCatalogo>(context);

    return Consumer<ProviderCatalogo>(
                    child: Center(
                      child: Text("Cargando..."),
                    ),
                    builder: (comsumerContext, catalogo, child) {
                      return _gridListProductos(buildContext: context,catalogo: servicesCatalogo.getCatalogo);
                    },
                  );
  }
}

 /* Generamos una GridList de los productos */
  Widget _gridListProductos({BuildContext buildContext,List<Producto> catalogo}) {
    //Provider ( set )
    buildContext.read<ProviderPerfilNegocio>().setCantidadProductos =Global.listProudctosNegocio.length;
    buildContext.read<ProviderMarcasProductos>().listMarcas.clear();
   
    return catalogo.length != 0
            ? GridView.count(
                crossAxisCount: 3,
                //childAspectRatio: 0.60,
                children: List.generate(catalogo.length, (index) {
                  return Padding(
                    child: ProductoItem(producto:catalogo[index]),
                    padding: EdgeInsets.all(0.0),
                  );
                }),
              )
            : Expanded(
                child: Center(child: Text("Sin productos")),
              );
  }

  class ProductoItem extends StatelessWidget {
  final Producto producto;
  final double width;
  const ProductoItem({Key key, this.producto, this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                  placeholder:
                                      AssetImage("assets/loading.gif")),
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

