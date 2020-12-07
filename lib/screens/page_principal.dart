/* Copyright 2020 Logica Booleana Authors */

import 'dart:ui';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:producto/shared/progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

/* Dependencias */
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:producto/shared/widget_button.dart';
import 'package:producto/shared/widgets_image_circle.dart' as image;
import 'package:producto/services/preferencias_usuario.dart';
import 'package:producto/screens/page_BuscarProductGlobal.dart';
import 'package:producto/screens/page_producto_view.dart';
import 'package:producto/screens/widgets/widget_CatalogoGridList.dart';
import 'package:producto/services/services.dart';
import 'package:producto/screens/page_buscadorProductos.dart';
import 'package:producto/models/models_profile.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/models/models_catalogo.dart';
import 'package:producto/screens/widgets/widgetsCategoriViews.dart';
import 'package:producto/utils/dynamicTheme_lb.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación "Producto"  */

class PagePrincipal extends StatelessWidget {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();
  User firebaseUser;
  PreferenciasUsuario prefs;
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext buildContext) {
    // Initializate
    prefs = new PreferenciasUsuario();
    firebaseUser = Provider.of<User>(buildContext);

    return Global.prefs.getIdNegocio == ""
        ? scaffoldScan(buildContext: buildContext)
        : scaffondCatalogo(buildContext: buildContext);
  }

  Scaffold scaffoldScan({@required BuildContext buildContext}) {
    Color color = Theme.of(buildContext).brightness == Brightness.dark?Colors.white54: Colors.black38;
    return Scaffold(
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
                Text("Mi catálogo",
                    style: TextStyle(
                        color:
                            Theme.of(buildContext).textTheme.bodyText1.color),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          DynamicTheme.of(buildContext).getIConButton(buildContext),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              splashColor: Theme.of(buildContext).primaryColor,
              onTap: () => scanBarcodeNormal(context: buildContext),
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 0.2, color: color),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                child: Image(
                    color: color,
                    height: 200.0,
                    width: 200.0,
                    image: AssetImage('assets/barcode.png'),
                    fit: BoxFit.contain),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text("Escanea un producto para conocer su precio",
                  style: TextStyle(
                      fontFamily: "POPPINS_FONT",
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: 24.0),
                  textAlign: TextAlign.center),
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
              color: Colors.deepPurple,
              child: Text("Buscar",style: TextStyle(fontSize: 24.0, color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(color: Colors.transparent)),
              onPressed: () {
                Navigator.of(buildContext).push(MaterialPageRoute(
                  builder: (BuildContext context) => WidgetSeachProduct(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget scaffondCatalogo({@required BuildContext buildContext}) {
    return FutureBuilder(
      future: Global.getNegocio(idNegocio: Global.prefs.getIdNegocio).getDataPerfilNegocio(),
      builder: (c, snapshot) {
        if (snapshot.hasData) {
          Global.oPerfilNegocio = snapshot.data;
          return SafeArea(
            child: Consumer<ProviderPerfilNegocio>(
                builder: (consumerContext, cuenta, snapshot) {
              if (cuenta.getCuentaNegocio != null) {
                Global.oPerfilNegocio = cuenta.getCuentaNegocio;
              }
              return Scaffold(
                /* AppBar persistente que nunca se desplaza */
                appBar: AppBar(
                  elevation: 0.0,
                  backgroundColor: Theme.of(buildContext).canvasColor,
                  iconTheme: Theme.of(buildContext).iconTheme.copyWith(
                      color: Theme.of(buildContext).textTheme.bodyText1.color),
                  title: InkWell(
                    onTap: () => selectCuenta(buildContext),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                              Global.oPerfilNegocio == null
                                  ? "Seleccionar cuenta"
                                  : Global.oPerfilNegocio.nombre_negocio != ""
                                      ? Global.oPerfilNegocio.nombre_negocio
                                      : "Mi catalogo",
                              style: TextStyle(
                                  color: Theme.of(buildContext)
                                      .textTheme
                                      .bodyText1
                                      .color),
                              overflow: TextOverflow.fade,
                              softWrap: false),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: InkWell(
                        customBorder: new CircleBorder(),
                        splashColor: Colors.red,
                        onTap: () {
                          showModalBottomSheetConfig(
                              buildContext: buildContext);
                        },
                        child: Hero(
                          tag: "fotoperfiltoolbar",
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
                                  imageUrl: Global.oPerfilNegocio.imagen_perfil,
                                  placeholder: (context, url) => FadeInImage(
                                      image: AssetImage("assets/loading.gif"),
                                      placeholder:
                                          AssetImage("assets/loading.gif")),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(
                                        firebaseUser.displayName
                                            .substring(0, 1),
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
                    ),
                  ],
                ),
                body: new StreamBuilder(
                  stream: Global.getCatalogoNegocio(idNegocio: Global.oPerfilNegocio.id ?? "").streamDataProductoAll(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Global.listProudctosNegocio = snapshot.data;
                      buildContext.read<ProviderCatalogo>().setCatalogo =
                          snapshot.data;
                      return body(buildContext: buildContext);
                    } else {
                      return WidgetLoadingInit(appbar: false);
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
                              builder: (BuildContext context) =>
                                  WidgetSeachProduct(),
                            ));
                          })
                    ],
                    colorEndAnimation: Colors.grey,
                    animatedIconData:
                        AnimatedIcons.menu_close //To principal button
                    ),
              );
            }),
          );
        } else {
          return WidgetLoadingInit(appbar: true);
        }
      },
    );
  }

  // Widgets
  Widget body({@required BuildContext buildContext}) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        /* le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
        floatHeaderSlivers: true,
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                Global.listProudctosNegocio.length != 0
                    ? SizedBox(height: 12.0)
                    : Container(),
                Global.listProudctosNegocio.length != 0
                    ? widgetsListaHorizontalMarcas(buildContext: buildContext)
                    : Container(),
                Global.listProudctosNegocio.length != 0
                    ? widgetBuscadorView(buildContext: buildContext)
                    : Container(),
                Global.listProudctosNegocio.length != 0
                    ? SizedBox(height: 12.0)
                    : Container(),
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
                        child: ViewCategoria(
                          buildContext: buildContext,
                        ),
                      );
                    });
              },
              tabs: [
                Consumer<ProviderCatalogo>(
                  child: Tab(
                      text:
                          "Todos (${Global.listProudctosNegocio.length.toString()})"),
                  builder: (context, catalogo, child) {
                    return Tab(
                        text: catalogo.sNombreFiltro +
                            " (${catalogo.categoria != null ? catalogo.cataloLoadMore.length.toString() : Global.listProudctosNegocio.length.toString()})");
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

  Widget widgetBuscadorView({@required BuildContext buildContext}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Card(
        color: Theme.of(buildContext).brightness == Brightness.dark
            ? Colors.black12
            : Colors.white,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search,
                    color: Theme.of(buildContext).brightness == Brightness.dark
                        ? Colors.white38
                        : Colors.black54),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  'Buscar',
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

  Widget getAdminUserData({@required String idNegocio}) {
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
                                    image.DashedCircle(
                                      dashes:
                                          catalogo.getNumeroDeProductosDeMarca(
                                              id: marca.id),
                                      gradientColor: colorGradientInstagram,
                                      child: Padding(
                                        padding: EdgeInsets.all(5.0),
                                        child: image.viewCircleImage(
                                            url: marca.url_imagen,
                                            texto: marca.titulo,
                                            size: 50),
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
                              return image.DashedCircle(
                                dashes: 1,
                                gradientColor: colorGradientInstagram,
                                child: CircleAvatar(
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

  // ShowModalBottomSheet
  void selectCuenta(BuildContext buildContext) {
    bool createCuentaEmpresa = true;
    // muestre la hoja inferior modal
    showModalBottomSheet(
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (ctx) {
          return ClipRRect(
            child: Container(
              child: FutureBuilder(
                future: Global.getListNegocioAdmin(idNegocio: firebaseUser.uid).getDataAdminPerfilNegocioAll(),
                builder: (c, snapshot) {
                  if (snapshot.hasData) {
                    // Verificamos si ahi una cuenta creada
                    for (PerfilNegocio item in snapshot.data) {
                      if (firebaseUser.uid == item.id) {
                        createCuentaEmpresa = false;
                      }
                    }
                    Global.listAdminPerfilNegocio = snapshot.data;
                    if (Global.listAdminPerfilNegocio.length == 0) {
                      return Column(
                        children: [
                          createCuentaEmpresa
                              ? WidgetButtonListTile(buildContext: buildContext)
                                  .buttonListTileCrearCuenta(
                                      context: buildContext)
                              : Container(),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                          WidgetButtonListTile(buildContext: buildContext)
                              .buttonListTileCerrarSesion(
                                  buildContext: buildContext),
                        ],
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        shrinkWrap: true,
                        itemCount: Global.listAdminPerfilNegocio.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (Global.listAdminPerfilNegocio.length == 0) {
                            return Column(
                              children: <Widget>[
                                createCuentaEmpresa
                                    ? WidgetButtonListTile(
                                            buildContext: buildContext)
                                        .buttonListTileCrearCuenta(
                                            context: buildContext)
                                    : Container(),
                                WidgetButtonListTile(buildContext: buildContext)
                                    .buttonListTileItemCuenta(
                                        buildContext: buildContext,
                                        perfilNegocio: Global
                                            .listAdminPerfilNegocio[index],
                                        adminPropietario: Global
                                                .listAdminPerfilNegocio[index]
                                                .id ==
                                            firebaseUser.uid),
                              ],
                            );
                          }
                          if (index ==Global.listAdminPerfilNegocio.length - 1) {
                            return Column(
                              children: <Widget>[
                                WidgetButtonListTile(buildContext: buildContext)
                                    .buttonListTileItemCuenta(
                                        adminPropietario: Global
                                                .listAdminPerfilNegocio[index]
                                                .id ==
                                            firebaseUser.uid,
                                        buildContext: buildContext,
                                        perfilNegocio: Global
                                            .listAdminPerfilNegocio[index]),
                                Divider(
                                    endIndent: 12.0, indent: 12.0, height: 0.0),
                                WidgetButtonListTile(buildContext: buildContext)
                                    .buttonListTileCerrarSesion(
                                        buildContext: buildContext),
                              ],
                            );
                          }
                          return Column(
                            children: <Widget>[
                              WidgetButtonListTile(buildContext: buildContext)
                                  .buttonListTileItemCuenta(
                                      buildContext: buildContext,
                                      perfilNegocio:
                                          Global.listAdminPerfilNegocio[index],
                                      adminPropietario: Global
                                              .listAdminPerfilNegocio[index]
                                              .id ==
                                          firebaseUser.uid),
                              
                            ],
                          );
                        },
                      );
                    }
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

  // Function
  Future<void> scanBarcodeNormal({@required BuildContext context}) async {
    /*Platform messages are asynchronous, so we initialize in an async method */

    String barcodeScanRes = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
    bool coincidencia = false;
    ProductoNegocio productoSelected;

    if (Global.listProudctosNegocio.length != 0) {
      for (ProductoNegocio producto in Global.listProudctosNegocio) {
        if (producto.codigo == barcodeScanRes) {
          productoSelected = producto;
          coincidencia = true;
          break;
        }
      }
    }

    if (coincidencia) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ProductScreen(producto: productoSelected)));
    } else {
      if (barcodeScanRes.toString() != "") {
        if (barcodeScanRes.toString() != "-1") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  WidgetSeachProduct(codigo: barcodeScanRes)));
        }
      }
    }
  }
}
