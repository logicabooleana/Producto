/* Copyright 2020 Logica Booleana Authors */

import 'dart:ui';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

/* Dependencias */
import 'package:catalogo/shared/widgets_image_circle.dart';
import 'package:catalogo/screens/profile.dart';
import 'package:catalogo/shared/widgets_image_circle.dart'as image;
import 'package:catalogo/services/preferencias_usuario.dart';
import 'package:catalogo/screens/widgets/widgetSeachProductCatalogo.dart';
import 'package:catalogo/screens/page_producto_view.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:catalogo/screens/widgets/widget_profile.dart';
import 'package:catalogo/screens/widgets/widget_CatalogoGridList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:catalogo/utils/dynamicTheme_lb.dart';
import 'package:catalogo/services/services.dart';
import 'package:catalogo/screens/page_buscadorProductos.dart';
import 'package:catalogo/models/models_profile.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:catalogo/screens/widgets/widgets_categoria.dart';
/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación Catalogo app  */

class PagePrincipal extends StatelessWidget {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();
  User firebaseUser;
  PreferenciasUsuario prefs;
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext buildContext) {
    prefs = new PreferenciasUsuario();
    firebaseUser = Provider.of<User>(buildContext);

    return Global.prefs.getIdNegocio == ""
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Seleccionar cuenta"),
                    onPressed: () => selectCuenta(buildContext),
                    color: Colors.red,
                    textColor: Colors.white,
                    splashColor: Colors.grey,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  ),
                  RaisedButton(
                    child: Text("Cerrar sesion"),
                    onPressed: () async {
                      //TODO: Mejorar el metodo de cerrar sesion
                      showAlertDialog(buildContext);
                      Global.prefs.setIdNegocio = "";
                      AuthService auth = AuthService();
                      await auth.signOut();
                      Future.delayed(const Duration(milliseconds: 800), () {
                        Navigator.pushReplacementNamed(buildContext, '/');
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        : FutureBuilder(
            future: Global.getNegocio(idNegocio: Global.prefs.getIdNegocio)
                .getDataPerfilNegocio(),
            builder: (c, snapshot) {
              if (snapshot.hasData) {
                Global.oPerfilNegocio = snapshot.data;
                return SafeArea(
                  child: Consumer<ProviderPerfilNegocio>(
                      builder: (consumerContext, cuenta, snapshot) {
                    if (cuenta.getCuentaNegocio != null) {
                      Global.oPerfilNegocio = cuenta.getCuentaNegocio;
                    }
                    return scaffond(buildContext, Global.oPerfilNegocio);
                  }),
                );
              } else {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
            },
          );
  }

  Scaffold scaffond(BuildContext buildContext, PerfilNegocio perfilNegocio) {
    return Scaffold(
      /* AppBar persistente que nunca se desplaza */
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(buildContext).canvasColor,
        iconTheme: Theme.of(buildContext)
            .iconTheme
            .copyWith(color: Theme.of(buildContext).textTheme.bodyText1.color),
        title: InkWell(
          onTap: () => selectCuenta(buildContext),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: <Widget>[
                Text(
                    perfilNegocio == null
                        ? "Default"
                        : perfilNegocio.username == ""
                            ? perfilNegocio.nombre_negocio
                            : perfilNegocio.username,
                    style: TextStyle(
                        color:
                            Theme.of(buildContext).textTheme.bodyText1.color)),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
        ),
        actions: <Widget>[
          DynamicTheme.of(buildContext).getIConButton(buildContext),
          Container(
            padding: EdgeInsets.all(12.0),
            child: InkWell(
              customBorder: new CircleBorder(),
              splashColor: Colors.red,
              onTap: () {
                Navigator.of(buildContext).push(MaterialPageRoute(
                    builder: (BuildContext context) => ProfileScreen()));
              },
              child: CircleAvatar(
                radius: 17,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CachedNetworkImage(
                      width: 35.0,
                      height: 35.0,
                      fadeInDuration: Duration(milliseconds: 200),
                      fit: BoxFit.cover,
                      imageUrl: firebaseUser.photoURL,
                      placeholder: (context, url) => FadeInImage(
                          image: AssetImage("assets/loading.gif"),
                          placeholder: AssetImage("assets/loading.gif")),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            firebaseUser.displayName.substring(0, 1),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: new StreamBuilder(
        stream: Global.getCatalogoNegocio(idNegocio: perfilNegocio.id??"")
            .streamDataProductoAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Global.listProudctosNegocio = snapshot.data;
            buildContext.read<ProviderCatalogo>().setCatalogo = snapshot.data;
            return defaultTabController(buildContext: buildContext);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: AnimatedFloatingActionButton(
          //Fab list
          fabButtons: <Widget>[
            FloatingActionButton(
                heroTag: "Escanear codigo",
                child: Image(
                    color: Colors.white,
                    height: 30.0,
                    width: 30.0,
                    image: AssetImage('assets/barcode.png'),
                    fit: BoxFit.contain),
                tooltip: 'Escanea el codigo del producto',
                onPressed: () {
                  scanBarcodeNormal(context: buildContext);
                }),
            FloatingActionButton(
                heroTag: "Escribir codigo",
                child: Icon(Icons.edit),
                tooltip: 'Escribe el codigo del producto',
                onPressed: () {
                  Navigator.of(buildContext).push(MaterialPageRoute(
                    builder: (BuildContext context) => WidgetSeachProduct(),
                  ));
                })
          ],
          colorEndAnimation: Colors.grey,
          animatedIconData: AnimatedIcons.menu_close //To principal button
          ),
    );
  }

  String _scanBarcode = '';
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal({@required BuildContext context}) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
    _scanBarcode = barcodeScanRes;
    bool coincidencia = false;
    for (ProductoNegocio producto in Global.listProudctosNegocio) {
      if (producto.codigo == _scanBarcode) {
        coincidencia = true;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductScreen(producto: producto),
          ),
        );
        break;
      }
    }
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
            showSearch(context: buildContext,delegate: DataSearch(listOBJ: Global.listProudctosNegocio));
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

  void selectCuenta(BuildContext buildContext) {
    // muestre la hoja inferior modal
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (ctx) {
          return ClipRRect(
            child: Container(
              child: FutureBuilder(
                future: Global.getListNegocioAdmin(idNegocio: firebaseUser.uid)
                    .getDataAdminPerfilNegocioAll(),
                builder: (c, snapshot) {
                  if (snapshot.hasData) {
                    Global.listAdminPerfilNegocio = snapshot.data;

                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shrinkWrap: true,
                      itemCount: Global.listAdminPerfilNegocio.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15.0),
                                leading: CircleAvatar(
                                  radius: 24.0,
                                  child: Icon(Icons.add),
                                ),
                                dense: true,
                                title: Text("Crear cuenta para empresa",
                                    style: TextStyle(fontSize: 16.0)),
                                onTap: () {},
                              ),
                              FutureBuilder(
                                future: Global.getNegocio(
                                        idNegocio: Global
                                            .listAdminPerfilNegocio[index].id)
                                    .getDataPerfilNegocio(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PerfilNegocio perfilNegocio = snapshot.data;
                                    return Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: perfilNegocio
                                                          .imagen_perfil ==
                                                      "" ||
                                                  perfilNegocio.imagen_perfil ==
                                                      "default"
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black26,
                                                  radius: 24.0,
                                                  child: Text(
                                                      perfilNegocio
                                                          .nombre_negocio
                                                          .substring(0, 1),
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: perfilNegocio
                                                      .imagen_perfil,
                                                  placeholder: (context, url) =>
                                                      const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    radius: 24.0,
                                                  ),
                                                  imageBuilder:
                                                      (context, image) =>
                                                          CircleAvatar(
                                                    backgroundImage: image,
                                                    radius: 24.0,
                                                  ),
                                                ),
                                          dense: true,
                                          title: Text(
                                              perfilNegocio.nombre_negocio),
                                          subtitle: _getAdminUserData(
                                              idNegocio: perfilNegocio.id),
                                          onTap: () {
                                            if (perfilNegocio.id != "") {
                                              Global.oPerfilNegocio =
                                                  perfilNegocio;
                                              buildContext
                                                  .read<ProviderPerfilNegocio>()
                                                  .setCuentaNegocio = perfilNegocio;
                                              prefs.setIdNegocio =
                                                  perfilNegocio.id.toString();
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        Divider(endIndent: 12.0, indent: 12.0),
                                      ],
                                    );
                                  } else {
                                    return ListTile(title: Text("Cargando..."));
                                  }
                                },
                              ),
                            ],
                          );
                        }
                        if (index == Global.listAdminPerfilNegocio.length - 1) {
                          return Column(
                            children: <Widget>[
                              FutureBuilder(
                                future: Global.getNegocio(
                                        idNegocio: Global
                                            .listAdminPerfilNegocio[index].id)
                                    .getDataPerfilNegocio(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    PerfilNegocio perfilNegocio = snapshot.data;
                                    return Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: perfilNegocio
                                                          .imagen_perfil ==
                                                      "" ||
                                                  perfilNegocio.imagen_perfil ==
                                                      "default"
                                              ? CircleAvatar(
                                                  backgroundColor:
                                                      Colors.black26,
                                                  radius: 24.0,
                                                  child: Text(
                                                      perfilNegocio
                                                          .nombre_negocio
                                                          .substring(0, 1),
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: perfilNegocio
                                                      .imagen_perfil,
                                                  placeholder: (context, url) =>
                                                      const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey,
                                                    radius: 24.0,
                                                  ),
                                                  imageBuilder:
                                                      (context, image) =>
                                                          CircleAvatar(
                                                    backgroundImage: image,
                                                    radius: 24.0,
                                                  ),
                                                ),
                                          dense: true,
                                          title: Text(
                                              perfilNegocio.nombre_negocio),
                                          subtitle: _getAdminUserData(
                                              idNegocio: perfilNegocio.id),
                                          onTap: () {
                                            if (perfilNegocio.id != "") {
                                              Global.oPerfilNegocio =
                                                  perfilNegocio;
                                              buildContext
                                                  .read<ProviderPerfilNegocio>()
                                                  .setCuentaNegocio = perfilNegocio;
                                              prefs.setIdNegocio =
                                                  perfilNegocio.id.toString();
                                              Navigator.pop(context);
                                            }
                                          },
                                        ),
                                        Divider(endIndent: 12.0, indent: 12.0),
                                      ],
                                    );
                                  } else {
                                    return ListTile(title: Text("Cargando..."));
                                  }
                                },
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15.0),
                                leading: CircleAvatar(
                                  radius: 24.0,
                                  child: Icon(Icons.close),
                                ),
                                dense: true,
                                title: Text("Cerrar sesión",
                                    style: TextStyle(fontSize: 16.0)),
                                onTap: () async {
                                  //TODO: Mejorar el metodo de cerrar sesion
                                  showAlertDialog(buildContext);
                                  Global.prefs.setIdNegocio = "";
                                  AuthService auth = AuthService();
                                  await auth.signOut();
                                  Future.delayed(
                                      const Duration(milliseconds: 800), () {
                                    Navigator.pushReplacementNamed(
                                        buildContext, '/');
                                  });
                                },
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: <Widget>[
                            FutureBuilder(
                              future: Global.getNegocio(
                                      idNegocio: Global
                                          .listAdminPerfilNegocio[index].id)
                                  .getDataPerfilNegocio(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  PerfilNegocio perfilNegocio = snapshot.data;
                                  return Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: perfilNegocio.imagen_perfil ==
                                                    "" ||
                                                perfilNegocio.imagen_perfil ==
                                                    "default"
                                            ? CircleAvatar(
                                                backgroundColor: Colors.black26,
                                                radius: 24.0,
                                                child: Text(
                                                    perfilNegocio.nombre_negocio
                                                        .substring(0, 1),
                                                    style: TextStyle(
                                                        fontSize: 18.0,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    perfilNegocio.imagen_perfil,
                                                placeholder: (context, url) =>
                                                    const CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 24.0,
                                                ),
                                                imageBuilder:
                                                    (context, image) =>
                                                        CircleAvatar(
                                                  backgroundImage: image,
                                                  radius: 24.0,
                                                ),
                                              ),
                                        dense: true,
                                        title:
                                            Text(perfilNegocio.nombre_negocio),
                                        subtitle: _getAdminUserData(
                                            idNegocio: perfilNegocio.id),
                                        onTap: () {
                                          if (perfilNegocio.id != "") {
                                            Global.oPerfilNegocio =
                                                perfilNegocio;
                                            buildContext
                                                .read<ProviderPerfilNegocio>()
                                                .setCuentaNegocio = perfilNegocio;
                                            buildContext
                                                .read<ProviderCatalogo>()
                                                .setClean = true;
                                            prefs.setIdNegocio =
                                                perfilNegocio.id.toString();
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                      Divider(endIndent: 12.0, indent: 12.0),
                                    ],
                                  );
                                } else {
                                  return ListTile(title: Text("Cargando..."));
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Cargando..."));
                  }
                },
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget defaultTabController({@required BuildContext buildContext}) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        /* le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                WidgetProfile(),
                SizedBox(height: 12.0),
                Global.listProudctosNegocio.length == 0
                    ? Container()
                    : widgetsListaHorizontalMarcas(buildContext: buildContext),
                Global.listProudctosNegocio.length == 0
                    ? Container()
                    : widgetBuscadorView(buildContext: buildContext),
                SizedBox(height: 12.0),
              ]),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Divider(height: 0.0),
            TabBar(
              indicatorColor: Theme.of(buildContext).accentColor,
              indicatorWeight: 5.0,
              labelColor: Theme.of(buildContext).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              onTap: (value) {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    backgroundColor: Theme.of(buildContext).canvasColor,
                    context: buildContext,
                    builder: (ctx) {
                      return ClipRRect(
                        child: ViewCategoria(buildContext: buildContext,),
                      );
                    });
              },
              tabs: [
                Consumer<ProviderCatalogo>(
                  child: Tab(text: "Todos"),
                  builder: (context, catalogo, child) {
                    return Tab(text: catalogo.sNombreFiltro);
                  },
                ),
              ],
            ),
            Divider(height: 0.0),
            Expanded(
              child: TabBarView(
                children: [
                  WidgetCatalogoGridList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAdminUserData({@required String idNegocio}) {
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

  Widget widgetsListaHorizontalMarcas({@required BuildContext buildContext}) {
    /* Declarar variables */
    List<Color> colorGradientInstagram = [
      Color.fromRGBO(129, 52, 175, 1.0),
      Color.fromRGBO(129, 52, 175, 1.0),
      Color.fromRGBO(221, 42, 123, 1.0),
      Color.fromRGBO(68, 0, 71, 1.0)
    ];

    return Consumer<ProviderCatalogo>(builder: (context, catalogo, child) {
      if (catalogo.getMarcas.length == 0) {
        return Container();
      }
      return SizedBox(
        height: 110.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catalogo.getMarcas.length,
            itemBuilder: (BuildContext c, int index) {
              return Container(
                width: 81.0,
                height: 100.0,
                padding: EdgeInsets.all(5.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        FutureBuilder(
                          future: Global.getMarca(
                                  idMarca: catalogo.getMarcas[index])
                              .getDataMarca(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Marca marca = snapshot.data;
                              return GestureDetector(
                                onTap: () {
                                  buildContext
                                      .read<ProviderCatalogo>()
                                      .setIdMarca = marca.id;
                                  buildContext
                                      .read<ProviderCatalogo>()
                                      .setNombreFiltro = marca.titulo;
                                },
                                child: Column(
                                  children: <Widget>[
                                    DashedCircle(
                                      dashes:
                                          catalogo.getNumeroDeProductosDeMarca(
                                              id: marca.id),
                                      gradientColor: colorGradientInstagram,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: image.viewCircleImage(url:marca.url_imagen,texto:marca.titulo, size:50),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text(marca.titulo,
                                        style: TextStyle(
                                            fontSize:
                                                catalogo.getIdMarca == marca.id
                                                    ? 14
                                                    : 12,
                                            fontWeight:
                                                catalogo.getIdMarca == marca.id
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                        overflow: TextOverflow.fade,
                                        softWrap: false)
                                  ],
                                ),
                              );
                            } else {
                              return DashedCircle(
                                dashes: 1,
                                gradientColor: colorGradientInstagram,
                                child:CircleAvatar(
          backgroundColor: Colors.black26,
          radius: 30,
        ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      );
    });
  }

  Widget dividerOpciones() {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.borderAll, size: 24.0),
            FaIcon(FontAwesomeIcons.idBadge, size: 24.0),
          ],
        ),
        Divider(),
      ],
    );
  }
}
