import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:catalogo/screens/page_buscadorProductos.dart';
import 'package:catalogo/services/globals.dart';

class WidgetProfile extends StatelessWidget {
  const WidgetProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return profileUser(context: context);
  }
}

 Widget profileUser({@required BuildContext context}) {
    Color colorSubtexto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white54
        : Colors.black54;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(children: <Widget>[
                Text(
                        Global.listProudctosNegocio.length.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                Text(
                  "Productos",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: colorSubtexto,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ]),
              viewCircleImage(
                  url: Global.oPerfilNegocio.imagen_perfil, radius: 75.0),
              Column(children: <Widget>[
                Text(
                  Global.listProudctosNegocio.length.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Seguidores",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12.0,
                      color: colorSubtexto,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ]),
            ],
          ),
          SizedBox(height: 20.0),
          descripcion(buildContext: context),
        ],
      ),
    );
  }

   /* Devuelve una widget de una barra para buscar */
  Widget widgetBuscadorView({@required BuildContext buildContext}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  'Buscar "galletita"',
                  style: TextStyle(
                      color:
                          Theme.of(buildContext).brightness == Brightness.dark
                              ? Colors.white38
                              : Colors.black54),
                ),
              ],
            ),
          ),
          onTap: () {
            showSearch(
                context: buildContext,
                delegate: DataSearch(listOBJ: Global.listProudctosNegocio));
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1,
        margin: EdgeInsets.all(0.0),
      ),
    );
  }

  Widget viewCircleImage({@required String url, double radius = 85.0}) {
    return Global.oPerfilNegocio.imagen_perfil == "" ||
            Global.oPerfilNegocio.imagen_perfil == "default"
        ? CircleAvatar(
            backgroundColor: Colors.black26,
            radius: radius,
            child: Text(Global.oPerfilNegocio.nombre_negocio.substring(0, 1),
                style: TextStyle(
                    fontSize: radius,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          )
        : CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => CircleAvatar(
              backgroundColor: Colors.grey,
              radius: radius,
            ),
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: radius,
            ),
          );
  }

  /* Crea una vista de la descripción del perfil */
  Widget descripcion({@required BuildContext buildContext}) {
    if (Global.oPerfilNegocio != null) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Nombre
            Global.oPerfilNegocio.nombre_negocio != ""
                ? Text(Global.oPerfilNegocio.nombre_negocio,
                    style: new TextStyle(
                        fontSize: 30.0,
                        color:
                            Theme.of(buildContext).textTheme.bodyText2.color))
                : Container(),
            // Descripción
            Global.oPerfilNegocio.descripcion != ""
                ? Text(Global.oPerfilNegocio.descripcion,
                    style: new TextStyle(
                        fontSize: 14.0,
                        color:
                            Theme.of(buildContext).textTheme.bodyText2.color))
                : Container(),
            // Sitio web
            Global.oPerfilNegocio.sitio_web != ""
                ? Text(Global.oPerfilNegocio.sitio_web,
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.blue,
                        decoration: TextDecoration.underline))
                : Container(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }