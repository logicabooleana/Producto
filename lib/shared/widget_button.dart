import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/services.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catalogo/services/preferencias_usuario.dart';

class WidgetButtonCricle extends StatelessWidget {
  BuildContext context;
  String rute;
  String texto;
  Widget icon;

  double width;

  Color colorTexto, colorButton, colorButtonBorder, colorSplash;

  WidgetButtonCricle({
    @required this.context,
    @required this.texto,
    this.rute = "",
    this.icon,
    this.width = double.infinity,
    this.colorSplash = Colors.transparent,
    this.colorButtonBorder = Colors.white30,
    this.colorTexto = Colors.white,
    this.colorButton = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return icon != null ? getButtonIcon() : getButton();
  }

  Widget getButton() {
    return Center(
      child: Container(
        width: width,
        child: RaisedButton(
          shape: StadiumBorder(
              side: BorderSide(width: 0.0, color: colorButtonBorder)),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          textColor: colorTexto,
          color: colorButton,
          child: Text(texto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
          onPressed: () => Navigator.pushReplacementNamed(context, rute),
        ),
      ),
    );
  }

  Widget getButtonIcon() {
    return Center(
      child: Container(
        width: width,
        padding: EdgeInsets.all(12.0),
        child: RaisedButton.icon(
          shape: StadiumBorder(),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          textColor: colorTexto,
          icon: icon,
          splashColor: colorSplash,
          color: colorButton,
          label: Text(texto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center),
          onPressed: () => Navigator.pushReplacementNamed(context, rute),
        ),
      ),
    );
  }
}

class WidgetButtonCricleLine extends StatelessWidget {
  BuildContext context;
  String rute;
  String texto;
  Widget icon;

  double fontSize;
  double width;
  double padding;
  double elevation;
  double borderRadius;
  double borderSideWidth;

  Color colorTexto;
  Color colorButton;
  Color colorButtonLine;

  WidgetButtonCricleLine({
    @required this.context,
    @required this.texto,
    this.rute = "",
    this.icon,
    this.width = double.infinity,
    this.elevation = 5.0,
    this.padding = 12.0,
    this.fontSize = 16.0,
    this.borderRadius = 50.0,
    this.borderSideWidth = 1.0,
    this.colorTexto = Colors.white,
    this.colorButton = Colors.blue,
    this.colorButtonLine = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return getButton();
  }

  Widget getButton() {
    return Center(
      child: Container(
        width: width,
        child: RaisedButton(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide:
                  BorderSide(width: borderSideWidth, color: colorButtonLine)),
          padding: EdgeInsets.all(padding),
          textColor: colorTexto,
          color: colorButton,
          elevation: elevation,
          child: Text(texto,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w300),
              textAlign: TextAlign.center),
          onPressed: () => Navigator.pushReplacementNamed(context, rute),
        ),
      ),
    );
  }
}

class WidgetButtonListTile extends StatelessWidget {
  BuildContext buildContext;

  WidgetButtonListTile({@required this.buildContext});

  @override
  Widget build(BuildContext context) {
    return buttonListTileCrearCuenta(context: buildContext);
  }

  Widget buttonListTileCrearCuenta({@required BuildContext context}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: CircleAvatar(
        radius: 24.0,
        child: Icon(Icons.add),
      ),
      dense: true,
      title:
          Text("Crear cuenta para empresa", style: TextStyle(fontSize: 16.0)),
      onTap: () {},
    );
  }

  Widget buttonListTileCerrarSesion({@required BuildContext buildContext}) {
    User firebaseUser = Provider.of<User>(buildContext);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: firebaseUser.photoURL == "" || firebaseUser.photoURL == "default"
          ? CircleAvatar(
              backgroundColor: Colors.black26,
              radius: 24.0,
              child: Text(firebaseUser.displayName.substring(0, 1),
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )
          : CachedNetworkImage(
              imageUrl: firebaseUser.photoURL,
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 24.0,
                child: Text(firebaseUser.displayName.substring(0, 1),
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 24.0,
              ),
            ),
      dense: true,
      title: Text("Cerrar sesión", style: TextStyle(fontSize: 16.0)),
      subtitle: Text(firebaseUser.email),
      trailing: Icon(Icons.close),
      onTap: ()  {
        showDialogCerrarSesion(buildContext: buildContext);
      },
    );
  }

  void showDialogCerrarSesion({@required BuildContext buildContext}) {
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cerrar sesión"),
          content: new Text("¿Estás seguro de que quieres cerrar la sesión?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("si"),
              onPressed: () async{
                // Default values
                Global.actualizarPerfilNegocio(perfilNegocio: null);
                AuthService auth = AuthService();
                await auth.signOut();
                Future.delayed(const Duration(milliseconds: 800), () {
                  Navigator.of(buildContext).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget buttonListTileItemCuenta(
      {@required BuildContext buildContext, @required perfilNegocio}) {
    
    if(perfilNegocio.id==null){return Container();}
    return FutureBuilder(
      future:
          Global.getNegocio(idNegocio: perfilNegocio.id).getDataPerfilNegocio(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          PerfilNegocio perfilNegocio = snapshot.data;
          return Column(
            children: <Widget>[
              ListTile(
                leading: perfilNegocio.imagen_perfil == "" ||
                        perfilNegocio.imagen_perfil == "default"
                    ? CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 24.0,
                        child: Text(
                            perfilNegocio.nombre_negocio.substring(0, 1),
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                    : CachedNetworkImage(
                        imageUrl: perfilNegocio.imagen_perfil,
                        placeholder: (context, url) => const CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 24.0,
                        ),
                        imageBuilder: (context, image) => CircleAvatar(
                          backgroundImage: image,
                          radius: 24.0,
                        ),
                      ),
                dense: true,
                title: Text(perfilNegocio.nombre_negocio),
                subtitle: _getAdminUserData(idNegocio: perfilNegocio.id),
                trailing: Radio(
                  activeColor: Theme.of(context).primaryColor,
                  value:Global.oPerfilNegocio!=null? Global.oPerfilNegocio.id == perfilNegocio.id ? 0 : 1:1,
                  groupValue: 0,
                  onChanged: (val) {
                    Global.actualizarPerfilNegocio(
                        perfilNegocio: perfilNegocio);
                    Navigator.of(buildContext).pushNamedAndRemoveUntil(
                        '/page_principal', (Route<dynamic> route) => false);
                  },
                ),
                onTap: () {
                  if (perfilNegocio.id != "") {
                    Global.actualizarPerfilNegocio(
                        perfilNegocio: perfilNegocio);
                    Navigator.of(buildContext).pushNamedAndRemoveUntil(
                        '/page_principal', (Route<dynamic> route) => false);
                  }
                },
              ),
            ],
          );
        } else {
          final Color color = Colors.grey;
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: color, radius: 24.0),
              dense: true,
              title: Text("                               ",
                  style:
                      TextStyle(fontSize: 30.0, backgroundColor: Colors.grey)),
              onTap: () {},
            ),
          );
        }
      },
    );
  }

  Widget _getAdminUserData({@required String idNegocio}) {
    User firebaseUser = Provider.of<User>(buildContext);
    return FutureBuilder(
      future: Global.getDataAdminUserNegocio(
              idNegocio: idNegocio, idUserAdmin: firebaseUser.uid)
          .getDataAdminUsuarioCuenta(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AdminUsuarioCuenta adminUsuarioCuenta = snapshot.data;
          switch (adminUsuarioCuenta.tipocuenta) {
            case 0:
              return Text("Tipo de permiso no definido");
            case 1:
              return Text("Administrador");
            case 2:
              return Text("Estandar");
            default:
              return Text("Se produj un error al obtener los datos!");
          }
        } else {
          return Text("Cargando datos...");
        }
      },
    );
  }
}
