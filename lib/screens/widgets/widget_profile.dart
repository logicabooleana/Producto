import 'package:flutter/material.dart';
import 'package:producto/screens/page_buscadorProductos.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/shared/widgets_image_circle.dart' as image;

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
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    child: image.viewCircleImage(
                        url: Global.oPerfilNegocio.imagen_perfil,
                        texto: Global.oPerfilNegocio.nombre_negocio,
                        size: 120.0),
                    onTap: () => Navigator.pushNamed(context, '/profilCuenta'),
                  ),
                ),
                MaterialButton(
                  elevation: 0.0,
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                          color: Theme.of(context).canvasColor,
                          width: 0.0,
                          style: BorderStyle.solid)),
                  minWidth: 16.0,
                  color: Theme.of(context).canvasColor,
                  child: Text(
                    'Editar',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/profilCuenta'),
                )
              ],
            ),
            Column(children: <Widget>[
              FutureBuilder(
                initialData: [],
                future: Global.getListSeguidores(idNegocio: Global.oPerfilNegocio.id).getListSeguidoresAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length!=0) {
                      return Text(snapshot.data.length.toString(),overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center);
                    } else {
                      return Text("0",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center);
                    }
                  } else {
                    return Text("...",overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center);
                  }
                },
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
                    color: Theme.of(buildContext).brightness == Brightness.dark
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

/* Crea una vista de la descripción del perfil */
Widget descripcion({@required BuildContext buildContext}) {
  if (Global.oPerfilNegocio != null) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Nombre
          Global.oPerfilNegocio.nombre_negocio != ""
              ? Text(Global.oPerfilNegocio.nombre_negocio,
                  style: new TextStyle(
                      fontSize: 26.0,
                      color: Theme.of(buildContext).textTheme.bodyText2.color))
              : Container(),
          // Descripción
          Global.oPerfilNegocio.descripcion != ""
              ? Text(Global.oPerfilNegocio.descripcion,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Theme.of(buildContext).textTheme.bodyText2.color))
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
