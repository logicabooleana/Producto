/* Copyright 2020 Logica Booleana Authors */

import 'dart:ui';

import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/screens/widgets/widget_circle_border.dart';
import 'package:catalogo/services/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

/* Dependencias */
import 'package:catalogo/screens/widgets/widget_profile.dart';
import 'package:catalogo/screens/widgets/widget_CatalogoGridList.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; 
import 'package:catalogo/utils/dynamicTheme_lb.dart';
import 'package:catalogo/services/services.dart';
import 'package:catalogo/screens/page_buscadorProductos.dart';
import 'package:catalogo/models/models_profile.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_catalogo.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación Catalogo app  */

class PagePrincipal extends StatelessWidget {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();
  FirebaseUser firebaseUser;
  PreferenciasUsuario prefs;
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext buildContext) {
    prefs = new PreferenciasUsuario();
    firebaseUser = Provider.of<FirebaseUser>(buildContext);

    return Global.prefs.getIdNegocio == ""
        ? Scaffold(
            body: Center(
              child: RaisedButton(
                child: Text("Seleccionar cuenta"),
                onPressed: () => selectCuenta(buildContext),
                color: Colors.red,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
            ),
          )
        : FutureBuilder(
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
                        color: Theme.of(buildContext).textTheme.bodyText1.color)),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          DynamicTheme.of(buildContext).getIConButton(buildContext),
          IconButton(
              icon: Icon(Icons.tune),
              onPressed: () => Navigator.pushNamed(buildContext, '/page_themeApp')),
        ],
      ),
      body: FutureBuilder(
        future: Global.getCatalogoNegocio(idNegocio: perfilNegocio.id).getDataProductoAll(),
        builder: (c, snapshot) {
          if (snapshot.hasData) {
            Global.listProudctosNegocio=snapshot.data;
            buildContext.read<ProviderCatalogo>().setCatalogo=snapshot.data;
            return defaultTabController(buildContext: buildContext);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: AnimatedFloatingActionButton(
        fabButtons: fabButtons(buildContext),
        animatedIconData: AnimatedIcons.menu_close,
      ),
    );
  }

  List<Widget> fabButtons(BuildContext context) {
    return <Widget>[
      FloatingActionButton(
        heroTag: "Escanear codigo",
        child: Icon(Icons.border_clear),
        tooltip: 'Escanea el codigo del producto',
        onPressed: () {},
      ),
      FloatingActionButton(
          heroTag: "Agregar",
          child: Icon(Icons.add),
          tooltip: 'Crea tu propio catálogo',
          onPressed: () {}),
    ];
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
                                              Global.oPerfilNegocio = perfilNegocio;
                                              buildContext .read<ProviderPerfilNegocio>().setCuentaNegocio = perfilNegocio;
                                              prefs.setIdNegocio =perfilNegocio.id.toString();
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
                                            Global.oPerfilNegocio = perfilNegocio;
                                            buildContext.read<ProviderPerfilNegocio>() .setCuentaNegocio = perfilNegocio;
                                            buildContext.read<ProviderCatalogo>().setClean=true;
                                            prefs.setIdNegocio =perfilNegocio.id.toString();
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
              : widgetsListaHorizontalMarcas(buildContext:buildContext ),
          Global.listProudctosNegocio.length == 0
              ? Container()
              : widgetBuscadorView(buildContext: buildContext),
          SizedBox(height: 12.0),
              ]),
            ),
          ];
        },
        /* La vista de pestaña va aqui */
        body: Column(
          children: <Widget>[
            Divider(height: 0.0),
            TabBar(
              indicatorColor: Theme.of(buildContext).accentColor,
              indicatorWeight: 5.0,
              labelColor: Theme.of(buildContext).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              onTap: (value) => showSelectCategoria(buildContext: buildContext),
              tabs: [ 
                Consumer<ProviderCatalogo>(
                  child: Tab(text: "Todos"),
                  builder: (context, catalogo, child) {
                    return Tab(text: catalogo.getNombreCategoria);
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

  void showSelectCategoria({@required BuildContext buildContext}) {
    // muestre la hoja inferior modal
    showModalBottomSheet(
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (ctx) {
          return ClipRRect(
            child: Container(
              child: FutureBuilder(
                future: Global.getCatalogoCategorias(idNegocio: Global.oPerfilNegocio.id).getDataCategoriaAll(),
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
                                            buildContext.read<ProviderCatalogo>().setIdCategoria = "todos";
                                            buildContext.read<ProviderCatalogo>().setNombreFiltro = "Todos";
                                            buildContext.read<ProviderCatalogo>().setIdMarca = "";
                                            Navigator.pop(
                                                context,
                                                Global.listCategoriasCatalogo[
                                                    index]);
                                          },
                                        )
                                      : Container(),
                                  Divider(endIndent: 12.0, indent: 12.0),
                                  ListTile(
                                    leading: categoria.url_imagen == "" ||
                                            categoria.url_imagen == "default"
                                        ? CircleAvatar(
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
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: categoria.url_imagen,
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
                                    title: Text(categoria.nombre),
                                    onTap: () {
                                      buildContext.read<ProviderCatalogo>().setNombreFiltro =Global.listCategoriasCatalogo[index].nombre;
                                      buildContext.read<ProviderCatalogo>().setIdCategoria=Global.listCategoriasCatalogo[index].id;
                                      buildContext.read<ProviderCatalogo>().setIdMarca="";
                                      Navigator.pop(context,Global.listCategoriasCatalogo[index]);
                                    },
                                  ),
                                  Divider(endIndent: 12.0, indent: 12.0),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: categoria.url_imagen == "" ||
                                            categoria.url_imagen == "default"
                                        ? CircleAvatar(
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
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: categoria.url_imagen,
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
                                    title: Text(categoria.nombre),
                                    onTap: () {
                                      buildContext.read<ProviderCatalogo>().setNombreFiltro =Global.listCategoriasCatalogo[index].nombre;
                                      buildContext.read<ProviderCatalogo>().setIdCategoria=Global.listCategoriasCatalogo[index].id;
                                      buildContext.read<ProviderCatalogo>().setIdMarca="";
                                      Navigator.pop(context,Global.listCategoriasCatalogo[index]);
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


  Widget widgetsListaHorizontalMarcas({@required BuildContext buildContext}) {

    
  /* Declarar variables */
  List<Color> colorGradientInstagram = [
     Color.fromRGBO(129, 52, 175, 1.0),
     Color.fromRGBO(129, 52, 175, 1.0),
     Color.fromRGBO(221, 42, 123, 1.0),
     Color.fromRGBO(68, 0, 71, 1.0)
    ];

    return SizedBox(
      height: 110.0,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Consumer<ProviderCatalogo>(
              builder: (context, catalogo, child) => Stack(
                children: [
                  ListView.builder(
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
                                    future: Global.getMarca(idMarca:catalogo.getMarcas[index]).getDataMarca(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        Marca marca = snapshot.data;
                                        return GestureDetector(
                                          onTap: () {
                                            buildContext.read<ProviderCatalogo>().setIdMarca = marca.id;
                                            buildContext.read<ProviderCatalogo>().setNombreFiltro = marca.titulo;
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              DashedCircle(
                                                dashes: catalogo.getNumeroDeProductosDeMarca(id:marca.id ),
                                                gradientColor:  colorGradientInstagram,
                                                child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: viewCircleImage(url: marca.url_imagen,radius: 30),
                                              ),
                                                ),
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              Text(marca.titulo,
                                                  style: TextStyle(
                                                      fontSize: catalogo.getIdMarca==marca.id?14:12,
                                                      fontWeight: catalogo.getIdMarca==marca.id?FontWeight.bold:FontWeight.normal),
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

