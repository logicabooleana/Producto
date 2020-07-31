/* Copyright 2020 Logica Booleana Authors */

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

/* Dependencias */
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; /* font_awesome_flutter: ^x.x.x */

import 'package:catalogo/utils/dynamicTheme_lb.dart';
import 'package:catalogo/services/services.dart';
import 'package:catalogo/screens/page_buscadorProductos.dart';
import 'package:catalogo/models/models_profile.dart';
import 'package:catalogo/services/globals.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación Catalogo app  */

class PageProfile2 extends StatefulWidget {
  @override
  _PageProfile2State createState() => _PageProfile2State();
}

class _PageProfile2State extends State<PageProfile2> {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();
  String sCategoria = "Todas";
  String sIdCategoria = "todos";
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

    buildContext=context;
    prefs = new PreferenciasUsuario();
    firebaseUser = Provider.of<FirebaseUser>(context);

    return prefs.getIdNegocio == "" || Global.oPerfilNegocio == null ? Scaffold(
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
    :
    SafeArea(
      child: Scaffold(
        /* AppBar persistente que nunca se desplaza */
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Theme.of(context).canvasColor,
          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Theme.of(context).textTheme.bodyText1.color),
          title: InkWell(
            onTap: () => selectCuenta(context),
            child: Text(
              Global.oPerfilNegocio == null
                  ? "Default"
                  : Global.oPerfilNegocio.nombre_negocio,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.tune),
                onPressed: () =>
                    Navigator.pushNamed(context, '/page_themeApp')),
            DynamicTheme.of(context).getIConButton(context),
            IconButton(icon: Icon(FontAwesomeIcons.bars), onPressed: () {})
          ],
        ),
        body: defaultTabController(),
      ),
    );
  }

  /* Devuelve una widget de una barra para buscar */
  Widget buscadorView() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
      child: TextFormField(
        onTap: () {
          showSearch(
              context: context,
              delegate: DataSearch(listOBJ: Global.listProudctosNegocio));
        },
        style: TextStyle(color: Colors.white),
        obscureText: false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              gapPadding: 12.0,
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.circular(20.0)),
          enabledBorder: OutlineInputBorder(
              gapPadding: 12.0,
              borderSide: BorderSide(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.circular(20.0)),
          hintText: "Buscar Producto",
          hintStyle: TextStyle(color: Colors.white24),
          contentPadding: EdgeInsets.all(20.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white10,
          prefixIcon: Icon(Icons.search, color: Colors.white24),
          suffixIcon: Icon(Icons.tune),
        ),
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
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    perfilNegocio
                                                        .imagen_perfil),
                                                radius: 24.0,
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
            Divider(
              height: 0.0,
            ),
            TabBar(
              onTap: (value) => _showMyDialog(),
              tabs: [
                Tab(
                  text: sCategoria,
                ),
              ],
            ),
            Divider(
              height: 0.0,
            ),
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

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Categorias'),
            actions: <Widget>[
              RaisedButton(
                child: Text("Mostrar todos"),
                onPressed: () {
                  setState(() {
                    sCategoria = "Todos";
                    sIdCategoria = "todos";
                    Navigator.pop(context);
                  });
                },
                color: Colors.red,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
            ],
            content: Container(
              width: double.minPositive,
              child: FutureBuilder(
                future: Global.getCatalogoCategorias(
                        idNegocio: Global.oPerfilNegocio.id)
                    .getDataCategoriaAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Global.listCategoriasCatalogo = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: Global.listCategoriasCatalogo.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title:
                              Text(Global.listCategoriasCatalogo[index].nombre),
                          onTap: () {
                            setState(() {
                              sCategoria =
                                  Global.listCategoriasCatalogo[index].nombre;
                              sIdCategoria =
                                  Global.listCategoriasCatalogo[index].id;
                              Navigator.pop(context,
                                  Global.listCategoriasCatalogo[index]);
                            });
                          },
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

  Future<void> _showDialogAdminCuentasNegocios() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Cuentas'),
            actions: <Widget>[
              RaisedButton(
                child: Text("Cerrar Sesión"),
                onPressed: () async {
                  await auth.signOut();
                  prefs.setIdNegocio = "";
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                color: Colors.red,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              RaisedButton(
                child: Text("Cancelar"),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                color: Colors.red,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
            ],
            content: Container(
              width: double.minPositive,
              child: FutureBuilder(
                future: Global.getListNegocioAdmin(idNegocio: firebaseUser.uid)
                    .getDataAdminPerfilNegocioAll(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Global.listAdminPerfilNegocio = snapshot.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: Global.listAdminPerfilNegocio.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            Divider(),
                            FutureBuilder(
                              future: Global.getNegocio(
                                      idNegocio: Global
                                          .listAdminPerfilNegocio[index].id)
                                  .getDataPerfilNegocio(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  PerfilNegocio perfilNegocio = snapshot.data;
                                  return ListTile(
                                    title: Text(perfilNegocio.nombre_negocio),
                                    subtitle: _getAdminUserData(
                                        idNegocio: perfilNegocio.id),
                                    onTap: () {
                                      setState(() {
                                        Global.actualizarPerfilNegocio(
                                            perfilNegocio: perfilNegocio);
                                        prefs.setIdNegocio =
                                            perfilNegocio.id.toString();
                                        sCategoria = "Todos";
                                        sIdCategoria = "todos";
                                        Navigator.pop(context);
                                      });
                                    },
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
                    return Text("Cargando...");
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
    return FutureBuilder(
      future: Global.getCatalogoNegocio(idNegocio: Global.oPerfilNegocio.id)
          .getDataProductoAll(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Global.listProudctosNegocio = snapshot.data;
          Provider.of<ProviderPerfilNegocio>(buildContext, listen: false).setCantidadProductos = Global.listProudctosNegocio.length;

          List listProductosItems = Global.listProudctosNegocio;
          // Refactoriza la lista de productos segun la categoria
          sIdCategoria == "todos"
              ? listProductosItems = listProductosItems
              : listProductosItems
                  .removeWhere((item) => item.categoria != sIdCategoria);

          if (listProductosItems.length != 0) {
            return GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 0.60,
              children: List.generate(listProductosItems.length, (index) {
                return Padding(
                  child: ProductoItem(producto: listProductosItems[index]),
                  padding: EdgeInsets.all(1.0),
                );
              }),
            );
          } else {
            return Expanded(
              child: Center(child: Text("Sin productos")),
            );
          }
        }
      },
    );
  }

  Widget profileUser({@required BuildContext context}) {
    return Container(
      margin: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          fotoPerfilContadores(context: context),
          SizedBox(height: 12.0),
          descripcion(),
          SizedBox(height: 12.0),
          buscadorView(),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }

  /* Creamos las vista de los contadores  */
  Widget fotoPerfilContadores({@required BuildContext context}) {
    if (Global.oPerfilNegocio != null) {
      return Container(
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(3.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).canvasColor,
                radius: 40.0,
                backgroundImage:
                    NetworkImage(Global.oPerfilNegocio.imagen_perfil),
              ),
            ),
            Expanded(child: _contadoroes()),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  /* Devuelve una vista con los contadores publiccaciones : seguidores : seguidos */
  Widget _contadoroes() {
    const double sizeWidth = 70;

    return Consumer<ProviderPerfilNegocio>(
      builder: (context, catalogo, child) => Stack(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: sizeWidth,
                  child: Column(children: <Widget>[
                    TextCountProductos(),
                    Text(
                      "Productos",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ),
                SizedBox(width: 5.0),
                Container(
                  width: sizeWidth,
                  child: Column(children: <Widget>[
                    Text(
                      "456",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Seguidores",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ),
                SizedBox(width: 5.0),
                Container(
                  width: sizeWidth,
                  child: Column(children: <Widget>[
                    Text(
                      "5.0",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Calificación",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.center,
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
      // Construye el widget costoso aquí.
      child: Text("Chiel"),
    );
  }

  /* Crea una vista de la descripción del perfil */
  Widget descripcion() {
    if (Global.oPerfilNegocio != null) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(Global.oPerfilNegocio.nombre_negocio,
                style: new TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0)),
            Text(
              Global.oPerfilNegocio.descripcion,
              style: new TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color),
            ),
            Text(Global.oPerfilNegocio.sitio_web,
                style: new TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline))
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

/* Una astilla cuyo tamaño varía cuando la astilla se desplaza hacia el borde de la ventana opuesta a la Dirección de crecimiento de la astilla . */
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(child: _tabBar);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class ProductoItem extends StatelessWidget {
  final Producto producto;
  const ProductoItem({Key key, this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: producto.id,
        child: Card(
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => producto != null
                      ? ProductScreen(producto: producto)
                      : Scaffold(
                          body: Center(
                            child: Text("Se produjo un Error!"),
                          ),
                        ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: 100 / 100,
                  child: producto.urlimagen != ""
                      ? CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 200),
                          fit: BoxFit.cover,
                          imageUrl: producto.urlimagen,
                          placeholder: (context, url) => FadeInImage(
                              image: AssetImage("assets/loading.gif"),
                              placeholder: AssetImage("assets/loading.gif")),
                          errorWidget: (context, url, error) =>
                              Container(color: Colors.black12),
                        )
                      : Container(
                          color: Colors.black26,
                        ),
                ),
                Row(
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
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.fade,
                                    softWrap: false)
                                : Container(),
                            producto.descripcion != ""
                                ? Text(producto.descripcion,
                                    style: TextStyle(
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                    overflow: TextOverflow.fade,
                                    softWrap: false)
                                : Container(),
                            producto.precio_venta != 0.0
                                ? Text(
                                    "${producto.signo_moneda}${producto.precio_venta}",
                                    style: TextStyle(
                                        height: 1.5,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
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
                // )
                //AnimatedProgressbar(value: 5.4, ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  final Producto producto;

  ProductScreen({this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.id),
      ),
      body: ListView(children: [
        Hero(
          tag: producto.urlimagen,
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            fadeInDuration: Duration(milliseconds: 200),
            fit: BoxFit.cover,
            imageUrl: producto.urlimagen,
            placeholder: (context, url) => FadeInImage(
                image: AssetImage("assets/loading.gif"),
                placeholder: AssetImage("assets/loading.gif")),
            errorWidget: (context, url, error) =>
                Container(color: Colors.black12),
          ),
        ),
        Text(producto.descripcion,
            style: TextStyle(
                height: 2, fontSize: 14, fontWeight: FontWeight.bold)),
        Text(producto.precio_venta.toString(),
            style: TextStyle(
                height: 2, fontSize: 14, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class TextCountProductos extends StatelessWidget {
  const TextCountProductos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        '${context.watch<ProviderPerfilNegocio>().getCantidadProductos}',
        style: Theme.of(context).textTheme.headline4);
  }
}
