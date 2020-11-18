/* Copyright 2020 Logica Booleana Authors */

import 'dart:ui';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

/* Dependencias */
import 'package:producto/screens/page_producto_view.dart';
import 'package:producto/services/preferencias_usuario.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; /* font_awesome_flutter: ^x.x.x */
import 'package:producto/utils/utils.dart';
import 'package:producto/utils/dynamicTheme_lb.dart';
import 'package:producto/services/services.dart';
import 'package:producto/screens/page_buscadorProductos.dart';
import 'package:producto/models/models_profile.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/models/models_catalogo.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación Catalogo app  */

class PageProfile extends StatefulWidget {
  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();
  String sCategoria = "Todas";
  String sIdCategoria = "todos";
  String sIdMarca = "";
  FirebaseUser firebaseUser;
  PreferenciasUsuario prefs;
  final AuthService auth = AuthService();
  BuildContext buildContext;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    prefs = new PreferenciasUsuario();
    firebaseUser = Provider.of<FirebaseUser>(context);

    return Global.prefs.getIdNegocio == ""
        ? Scaffold(
            body: Center(
              child: RaisedButton(
                child: Text("Seleccionar cuenta"),
                onPressed: () => selectCuenta(context),
                color: Colors.red,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
            ),
          )
        : FutureBuilder(
            future: Global.getNegocio(idNegocio: Global.prefs.getIdNegocio).getDataPerfilNegocio(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                Global.oPerfilNegocio = snapshot.data;
                return SafeArea(
                  child: Scaffold(
                    /* AppBar persistente que nunca se desplaza */
                    appBar: AppBar(
                      elevation: 0.0,
                      backgroundColor: Theme.of(context).canvasColor,
                      iconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).textTheme.bodyText1.color),
                      title: InkWell(
                        onTap: () => selectCuenta(context),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                  Global.oPerfilNegocio == null
                                      ? "Default"
                                      : Global.oPerfilNegocio.nombre_negocio == ""
                                          ? "Mi negocio"
                                          : Global.oPerfilNegocio.nombre_negocio,
                                  style: TextStyle( color: Theme.of(context).textTheme.bodyText1 .color)),
                              Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        DynamicTheme.of(context).getIConButton(context),
                        IconButton(
                            icon: Icon(Icons.tune),
                            onPressed: () =>
                                Navigator.pushNamed(context, '/page_themeApp')),
                      ],
                    ),
                    body: FutureBuilder(
                      future: Global.getCatalogoNegocio(idNegocio: Global.oPerfilNegocio.id).getDataProductoAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Global.listProudctosNegocio = snapshot.data;
                          return defaultTabController();
                        } else {
                          return Center(
                            child: CircularProgressIndicator()
                          );
                        }
                      },
                    ),
                    floatingActionButton: AnimatedFloatingActionButton(
                      fabButtons: fabButtons(context),
                      animatedIconData: AnimatedIcons.menu_close,
                    ),
                  ),
                );
              } else {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
            },
          );
  }

  List<Widget> fabButtons(BuildContext context) {
    return <Widget>[
      FloatingActionButton(
        heroTag: "Escanear codigo",
        child: Icon(Icons.border_clear),
        tooltip: 'Escanea el codigo del producto',
        onPressed: () => setState(() {}),
      ),
      FloatingActionButton(
          heroTag: "Agregar",
          child: Icon(Icons.add),
          tooltip: 'Crea tu propio catálogo',
          onPressed: () {}),
    ];
  }

  /* Devuelve una widget de una barra para buscar */
  Widget widgetBuscadorView() {
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
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white38
                          : Colors.black54),
                ),
              ],
            ),
          ),
          onTap: () {
            showSearch(
                context: context,
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

  void selectCuenta(BuildContext context) {
    // muestre la hoja inferior modal
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(context).canvasColor,
        context: context,
        builder: (ctx) {
          return ClipRRect(
            child: Container(
              child: FutureBuilder(
                future: Global.getListNegocioAdmin(idNegocio: firebaseUser.uid)
                    .getDataAdminPerfilNegocioAll(),
                builder: (context, snapshot) {
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
                                onTap: () {
                                  //Navigator.pop(context,Global.listCategoriasCatalogo[index]);
                                },
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
                                              setState(() {
                                                Global.oPerfilNegocio =
                                                    perfilNegocio;
                                                prefs.setIdNegocio =
                                                    perfilNegocio.id.toString();
                                                sCategoria = "Todos";
                                                sIdCategoria = "todos";
                                                Navigator.pop(context);
                                              });
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
                                            setState(() {
                                              Global.oPerfilNegocio =
                                                  perfilNegocio;
                                              prefs.setIdNegocio =
                                                  perfilNegocio.id.toString();
                                              sCategoria = "Todos";
                                              sIdCategoria = "todos";
                                              Navigator.pop(context);
                                            });
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

  Widget defaultTabController() {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        /* le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                profileUser(context: context),
              ]),
            ),
          ];
        },
        /* La vista de pestaña va aqui */
        body: Column(
          children: <Widget>[
            Divider(height: 0.0),
            TabBar(
              indicatorColor: Theme.of(context).accentColor,
              indicatorWeight: 5.0,
              labelColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              onTap: (value) => showSelectCategoria(context),
              tabs: [
                Tab(text: sCategoria),
              ],
            ),
            Divider(height: 0.0),
            Expanded(
              child: TabBarView(
                children: [
                  _gridListProductos(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSelectCategoria(BuildContext context) {
    // muestre la hoja inferior modal
    showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(context).canvasColor,
        context: context,
        builder: (ctx) {
          return ClipRRect(
            child: Container(
              child: FutureBuilder(
                future: Global.getCatalogoCategorias(
                        idNegocio: Global.oPerfilNegocio.id)
                    .getDataCategoriaAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Global.listCategoriasCatalogo = snapshot.data;

                    if (Global.listCategoriasCatalogo.length == 0) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 15.0),
                        leading: CircleAvatar(
                          radius: 24.0,
                          child: Icon(Icons.add),
                        ),
                        dense: true,
                        title: Text("Crear categoría"),
                        onTap: () {
                          //Navigator.pop(context,Global.listCategoriasCatalogo[index]);
                        },
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shrinkWrap: true,
                      itemCount: Global.listCategoriasCatalogo.length,
                      itemBuilder: (BuildContext context, int index) {
                        Categoria categoria =
                            Global.listCategoriasCatalogo[index];
                        return index == 0
                            ? Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 24.0,
                                      child: Icon(Icons.add),
                                    ),
                                    dense: true,
                                    title: Text("Crear nueva categoría",
                                        style: TextStyle(fontSize: 16.0)),
                                    onTap: () {},
                                  ),
                                  Global.listCategoriasCatalogo != 0
                                      ? Divider(endIndent: 12.0, indent: 12.0)
                                      : Container(),
                                  Global.listCategoriasCatalogo != 0
                                      ? ListTile(
                                          leading: CircleAvatar(
                                            radius: 24.0,
                                            child: Icon(Icons.all_inclusive),
                                          ),
                                          dense: true,
                                          title: Text("Mostrar todos",
                                              style: TextStyle(fontSize: 16.0)),
                                          onTap: () {
                                            setState(() {
                                              sCategoria = "Todos";
                                              sIdCategoria = "todos";
                                              sIdMarca = "";
                                              Navigator.pop(
                                                  context,
                                                  Global.listCategoriasCatalogo[
                                                      index]);
                                            });
                                          },
                                        )
                                      : Container(),
                                  Divider(endIndent: 12.0, indent: 12.0),
                                  ListTile(
                                    leading: CircleAvatar(
                                            backgroundColor: Colors.black26,
                                            radius: 24.0,
                                            child: Text(
                                                categoria.nombre
                                                    .substring(0, 1),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                    dense: true,
                                    title: Text(categoria.nombre),
                                    onTap: () {
                                      setState(() {
                                        sCategoria = Global
                                            .listCategoriasCatalogo[index]
                                            .nombre;
                                        sIdCategoria = Global.listCategoriasCatalogo[index].id;
                                        sIdMarca = "";
                                        Navigator.pop(
                                            context,
                                            Global
                                                .listCategoriasCatalogo[index]);
                                      });
                                    },
                                  ),
                                  Divider(endIndent: 12.0, indent: 12.0),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  ListTile(
                                    leading:CircleAvatar(
                                            backgroundColor: Colors.black26,
                                            radius: 24.0,
                                            child: Text(
                                                categoria.nombre
                                                    .substring(0, 1),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                    dense: true,
                                    title: Text(categoria.nombre),
                                    onTap: () {
                                      setState(() {
                                        sCategoria = Global
                                            .listCategoriasCatalogo[index]
                                            .nombre;
                                        sIdCategoria = Global
                                            .listCategoriasCatalogo[index].id;
                                        sIdMarca = "";
                                        Navigator.pop(
                                            context,
                                            Global
                                                .listCategoriasCatalogo[index]);
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
                },
              ),
            ),
          );
        });
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

  /* Generamos una GridList de los productos */
  Widget _gridListProductos() {
    //Provider ( set )
    buildContext.read<ProviderPerfilNegocio>().setCantidadProductos =
        Global.listProudctosNegocio.length;
    buildContext.read<ProviderMarcasProductos>().listMarcas.clear();

    List<ProductoNegocio> listProductosItems = Global.listProudctosNegocio;
    List<String> listMarcas = new List<String>();

    // Refactoriza la lista de productos segun la categoria y/o marca
    if (sIdMarca == "") {
      if (sIdCategoria == "todos") {
        if (listProductosItems.length != 0) {
          // Carga todas las marcas del catalogo
          for (int i = 0; i < listProductosItems.length; i++) {
            String value = listProductosItems[i].id_marca;
            //Provider ( set )
            if (value != null) {
              if (value != "") {
                listMarcas.add(value);
              }
            }
          }
        }
      } else {
        // Carga los porductos de la categoria seleccionada
        listProductosItems
            .removeWhere((item) => item.categoria != sIdCategoria);
        // Carga todas las marca de la categoria seleccionada
        for (int i = 0; i < listProductosItems.length; i++) {
          String value = listProductosItems[i].id_marca;
          //Provider ( set )
          if (value != null) {
            if (value != "") {
              listMarcas.add(value);
            }
          }
        }
      }
    } else {
      if (sIdCategoria == "todos") {
        if (listProductosItems.length != 0) {
          // Carga todas las marcas del catalogo
          for (int i = 0; i < listProductosItems.length; i++) {
            String value = listProductosItems[i].id_marca;
            //Provider ( set )
            if (value != null) {
              if (value != "") {
                listMarcas.add(value);
              }
            }
          }
          // Carga los porductos de la marca seleccionada
          listProductosItems.removeWhere((item) => item.id_marca != sIdMarca);
        }
      } else {
        // Carga los porductos de la categoria seleccionada
        listProductosItems.removeWhere((item) => item.categoria != sIdCategoria);
        // Carga todas las marca de la categoria seleccionada
        for (int i = 0; i < listProductosItems.length; i++) {
          String value = listProductosItems[i].id_marca;
          //Provider ( set )
          if (value != null) {
            if (value != "") {
              listMarcas.add(value);
            }
          }
        }
        // Filtra por marca
        listProductosItems.removeWhere((item) => item.id_marca != sIdMarca);
      }
    }

    buildContext.read<ProviderMarcasProductos>().listMarcas =listMarcas.toSet().toList();

    return Consumer<ProviderPerfilNegocio>(
      builder: (context, catalogo, child) {
        return listProductosItems.length != 0
            ? GridView.count(
                crossAxisCount: 3,
                //childAspectRatio: 0.60,
                children: List.generate(listProductosItems.length, (index) {
                  return Padding(
                    child: ProductoItem(producto: listProductosItems[index]),
                    padding: EdgeInsets.all(0.0),
                  );
                }),
              )
            : Expanded(
                child: Center(child: Text("Sin productos")),
              );
      },
    );
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
                // Consumer Values
                Consumer<ProviderPerfilNegocio>(
                  builder: (context, catalogo, child) => Stack(
                    children: [
                      Text(
                        catalogo.getCantidadProductos.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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
              viewCircleImage(url: Global.oPerfilNegocio.imagen_perfil, radius: 75.0),
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
          descripcion(),
          SizedBox(height: 12.0),
          Global.listProudctosNegocio.length == 0
              ? Container()
              : widgetsListaHorizontalMarcas(),
          Global.listProudctosNegocio.length == 0
              ? Container()
              : widgetBuscadorView(),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  Widget widgetsListaHorizontalMarcas() {
    return SizedBox(
      height: 110.0,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Consumer<ProviderMarcasProductos>(
              builder: (context, catalogo, child) => Stack(
                children: [
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: catalogo.getHashMaplistaMarca.length,
                      itemBuilder: (BuildContext context, int index) {
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
                                            idMarca: catalogo
                                                .getHashMaplistaMarca[index])
                                        .getDataMarca(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Marca marca = snapshot.data;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              sCategoria = marca.titulo;
                                              sIdMarca = marca.id;
                                            });
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              viewCircleImage(
                                                  url: marca.url_imagen,
                                                  radius: 30),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              Text(marca.titulo,
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.fade,
                                                  softWrap: false)
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
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
  Widget descripcion() {
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
                        color: Theme.of(context).textTheme.bodyText2.color))
                : Container(),
            // Descripción
            Global.oPerfilNegocio.descripcion != ""
                ? Text(Global.oPerfilNegocio.descripcion,
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).textTheme.bodyText2.color))
                : Container(),
          ],
        ),
      );
    } else {
      return Container();
    }
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

class ProductoItem extends StatelessWidget {
  final ProductoNegocio producto;
  final double width;
  const ProductoItem({Key key, this.producto,this.width=double.infinity}) : super(key: key);

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
                      child: producto.urlimagen!=""
                          ?CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 200),
                              fit: BoxFit.cover,
                              imageUrl: producto.urlimagen,
                              placeholder: (context, url) => FadeInImage(fit: BoxFit.cover,image: AssetImage("assets/loading.gif"),placeholder:AssetImage("assets/loading.gif")),
                              errorWidget:(context,url,error)=>Container(color: Colors.black12),
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
                                        ? Text(producto.titulo,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),overflow: TextOverflow.fade,softWrap: false)
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
                                        ? Text(Publicaciones.getFormatoPrecio(monto: producto.precio_venta),
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
