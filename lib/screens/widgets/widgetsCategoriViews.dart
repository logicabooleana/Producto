import 'package:cached_network_image/cached_network_image.dart';
import 'package:producto/models/models_catalogo.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/utils/dynamicTheme_lb.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:producto/screens/profileCuenta.dart';

class ViewCategoria extends StatefulWidget {
  BuildContext buildContext;
  ViewCategoria({@required this.buildContext});

  @override
  _ViewCategoriaState createState() =>
      _ViewCategoriaState(buildContextPrincipal: buildContext);
}

class _ViewCategoriaState extends State<ViewCategoria> {
  _ViewCategoriaState({@required this.buildContextPrincipal});

  // Variables
  Categoria categoriaSelected;
  bool crearCategoria, loadSave = false;
  BuildContext buildContextPrincipal;

  @override
  void initState() {
    crearCategoria = false;
    loadSave = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categoria"),
        actions: [
          IconButton(
              icon: Icon(Icons.add), onPressed: () => _showDialogSetCategoria())
        ],
      ),
      body: FutureBuilder(
        future:
            Global.getCatalogoCategorias(idNegocio: Global.oPerfilNegocio.id)
                .getDataCategoriaAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Global.listCategoriasCatalogo = snapshot.data;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shrinkWrap: true,
              itemCount: Global.listCategoriasCatalogo.length,
              itemBuilder: (BuildContext context, int index) {
                Categoria categoria = Global.listCategoriasCatalogo[index];
                return index == 0
                    ? Column(
                        children: <Widget>[
                          Global.listCategoriasCatalogo != 0
                              ? ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    child: Icon(Icons.all_inclusive),
                                  ),
                                  dense: true,
                                  title: Text("Mostrar todos",
                                      style: TextStyle(fontSize: 16.0)),
                                  onTap: () {
                                    buildContext
                                        .read<ProviderCatalogo>()
                                        .setNombreFiltro = "Todos";
                                    buildContext
                                        .read<ProviderCatalogo>()
                                        .setCategoria = null;
                                    buildContext
                                        .read<ProviderCatalogo>()
                                        .setIdMarca = "";
                                    Navigator.pop(context,
                                        Global.listCategoriasCatalogo[index]);
                                  },
                                )
                              : Container(),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 24.0,
                              child: Text(categoria.nombre.substring(0, 1),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            dense: true,
                            title: Text(categoria.nombre),
                            onTap: () {
                              buildContext
                                  .read<ProviderCatalogo>()
                                  .setNombreFiltro = categoria.nombre;
                              buildContext
                                  .read<ProviderCatalogo>()
                                  .setCategoria = categoria;
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  backgroundColor:
                                      Theme.of(buildContext).canvasColor,
                                  context: buildContextPrincipal,
                                  builder: (ctx) {
                                    return ClipRRect(
                                      child: ViewSubCategoria(
                                        categoria: categoria,
                                        buildContextCategoria: buildContext,
                                      ),
                                    );
                                  });
                            },
                            trailing:
                                popupMenuItemCategoria(categoria: categoria),
                          ),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 24.0,
                              child: categoria.nombre != ""
                                  ? Text(categoria.nombre.substring(0, 1),
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                  : Text("C"),
                            ),
                            dense: true,
                            title: Text(categoria.nombre),
                            onTap: () {
                              buildContext
                                  .read<ProviderCatalogo>()
                                  .setNombreFiltro = categoria.nombre;
                              buildContext
                                  .read<ProviderCatalogo>()
                                  .setCategoria = categoria;
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  backgroundColor:
                                      Theme.of(buildContext).canvasColor,
                                  context: buildContextPrincipal,
                                  builder: (ctx) {
                                    return ClipRRect(
                                      child: ViewSubCategoria(
                                          categoria: categoria,
                                          buildContextCategoria: buildContext),
                                    );
                                  });
                            },
                            trailing:
                                popupMenuItemCategoria(categoria: categoria),
                          ),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                        ],
                      );
              },
            );
          } else {
            return Center(child: Text("Cargando..."));
          }
        },
      ),
    );
  }

  Widget popupMenuItemCategoria({@required Categoria categoria}) {
    return new PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        new PopupMenuItem<String>(child: const Text('Editar'), value: 'editar'),
        new PopupMenuItem<String>(
            child: const Text('Eliminar'), value: 'eliminar'),
      ],
      onSelected: (value) async {
        switch (value) {
          case "editar":
            _showDialogSetCategoria(categoria: categoria);
            break;
          case "eliminar":
            await showDialog<String>(
              context: context,
              child: new AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                          "¿Desea continuar eliminando esta categoría?"),
                    )
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child: loadSave == false
                          ? Text("ELIMINAR")
                          : CircularProgressIndicator(),
                      onPressed: () async {
                        await Global.getDataCatalogoCategoria(
                                idNegocio: Global.oPerfilNegocio.id,
                                idCategoria: categoria.id)
                            .deleteDoc();
                        setState(() {
                          for (var i = 0;
                              i < Global.listCategoriasCatalogo.length;
                              i++) {
                            if (Global.listCategoriasCatalogo[i].id ==
                                categoria.id) {
                              Global.listCategoriasCatalogo.remove(i);
                            }
                          }
                        });
                      })
                ],
              ),
            );
            break;
        }
      },
    );
  }

  _showDialogSetCategoria({Categoria categoria}) async {
    bool loadSave = false;
    bool newProduct = false;
    if (categoria == null) {
      newProduct = true;
      categoria = new Categoria();
      categoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }
    TextEditingController controller =
        TextEditingController(text: categoria.nombre);

    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: controller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Categoria', hintText: 'Ej. golosinas'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: loadSave == false
                  ? Text(newProduct ? 'GUARDAR' : "ACTUALIZAR")
                  : CircularProgressIndicator(),
              onPressed: () async {
                if (controller.text != "") {
                  setState(() {
                    loadSave = true;
                  });
                  categoria.nombre = controller.text;
                  await Global.getDataCatalogoCategoria(
                          idNegocio: Global.oPerfilNegocio.id,
                          idCategoria: categoria.id)
                      .upSetCategoria(categoria.toJson());
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }
}

class ViewSubCategoria extends StatefulWidget {
  Categoria categoria;
  BuildContext buildContextCategoria;
  ViewSubCategoria(
      {@required this.buildContextCategoria, @required this.categoria});

  @override
  ViewSubCategoriaState createState() => ViewSubCategoriaState(
      paramCategoria: this.categoria,
      buildContextCategoria: buildContextCategoria);
}

class ViewSubCategoriaState extends State<ViewSubCategoria> {
  ViewSubCategoriaState(
      {@required this.buildContextCategoria, @required this.paramCategoria});
  // Variables
  BuildContext buildContextCategoria;
  Categoria paramCategoria;
  bool crearCategoria, loadSave = false;

  @override
  void initState() {
    crearCategoria = false;
    loadSave = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContextSubcategoria) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategoria"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                _showDialogSetSubCategoria(categoria: this.paramCategoria),
          )
        ],
      ),
      body: this.paramCategoria.subcategorias.length != 0
          ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shrinkWrap: true,
              itemCount: this.paramCategoria.subcategorias.length,
              itemBuilder: (BuildContext context, int index) {
                Categoria subcategoria = new Categoria(
                    id: this
                        .paramCategoria
                        .subcategorias
                        .keys
                        .elementAt(index)
                        .toString(),
                    nombre: this
                        .paramCategoria
                        .subcategorias
                        .values
                        .elementAt(index)
                        .toString());
                return index == 0
                    ? Column(
                        children: <Widget>[
                          this.paramCategoria.subcategorias.length != 0
                              ? ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 12.0),
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    child: Icon(Icons.all_inclusive),
                                  ),
                                  dense: true,
                                  title: Text("Mostrar todos",
                                      style: TextStyle(fontSize: 16.0)),
                                  onTap: () {
                                    Navigator.pop(buildContextCategoria);
                                    Navigator.pop(buildContextSubcategoria);
                                  },
                                )
                              : Container(),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 24.0,
                              child: Text(subcategoria.nombre.substring(0, 1),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            dense: true,
                            title: Text(subcategoria.nombre),
                            onTap: () {
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setNombreFiltro = subcategoria.nombre;
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setSubategoria = subcategoria;
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                            trailing: popupMenuItemSubCategoria(
                                categoria: paramCategoria,
                                subcategoria: subcategoria),
                          ),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 24.0,
                              child: Text(subcategoria.nombre.substring(0, 1),
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            dense: true,
                            title: Text(subcategoria.nombre),
                            onTap: () {
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setNombreFiltro = subcategoria.nombre;
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setSubategoria = subcategoria;
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                            trailing: popupMenuItemSubCategoria(
                                categoria: paramCategoria,
                                subcategoria: subcategoria),
                          ),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                        ],
                      );
              },
            )
          : ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              leading: CircleAvatar(
                radius: 24.0,
                child: Icon(Icons.all_inclusive),
              ),
              dense: true,
              title: Text("Mostrar todos", style: TextStyle(fontSize: 16.0)),
              onTap: () {
                Navigator.pop(buildContextCategoria);
                Navigator.pop(buildContextSubcategoria);
              },
            ),
    );
  }

  Widget popupMenuItemSubCategoria(
      {@required Categoria categoria, @required Categoria subcategoria}) {
    return new PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        new PopupMenuItem<String>(child: const Text('Editar'), value: 'editar'),
        new PopupMenuItem<String>(
            child: const Text('Eliminar'), value: 'eliminar'),
      ],
      onSelected: (value) async {
        switch (value) {
          case "editar":
            _showDialogSetSubCategoria(
                categoria: categoria, subcategoria: subcategoria);
            break;
          case "eliminar":
            await showDialog<String>(
              context: context,
              child: new AlertDialog(
                contentPadding: const EdgeInsets.all(16.0),
                content: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new Text(
                          "¿Desea continuar eliminando esta subcategoría?"),
                    )
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child: loadSave == false
                          ? Text("ELIMINAR")
                          : CircularProgressIndicator(),
                      onPressed: () async {
                        categoria.subcategorias.remove(subcategoria.id);
                        await Global.getDataCatalogoCategoria(
                                idNegocio: Global.oPerfilNegocio.id,
                                idCategoria: categoria.id)
                            .upSetCategoria(categoria.toJson());
                        setState(() {
                          Navigator.pop(context);
                        });
                      })
                ],
              ),
            );
            break;
        }
      },
    );
  }

  _showDialogSetSubCategoria(
      {@required Categoria categoria, Categoria subcategoria}) async {
    bool newSubcategoria = false;
    if (subcategoria == null) {
      newSubcategoria = true;
      subcategoria = new Categoria();
      subcategoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }
    bool loadSave = false;
    TextEditingController controller =
        TextEditingController(text: subcategoria.nombre);

    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: controller,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Subcategoria', hintText: 'Ej. chocolates'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: loadSave == false
                  ? Text(newSubcategoria ? 'GUARDAR' : "ACTUALIZAR")
                  : CircularProgressIndicator(),
              onPressed: () async {
                if (controller.text != "") {
                  setState(() {
                    loadSave = true;
                  });
                  subcategoria.nombre = controller.text;
                  categoria.subcategorias[subcategoria.id] =
                      subcategoria.nombre;
                  await Global.getDataCatalogoCategoria(
                          idNegocio: Global.oPerfilNegocio.id,
                          idCategoria: categoria.id)
                      .upSetCategoria(categoria.toJson());
                  Navigator.pop(context);
                } else {}
              })
        ],
      ),
    );
  }
}

Future<void> showModalBottomSheetConfig({@required BuildContext buildContext}) async {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Theme.of(buildContext).canvasColor,
      context: buildContext,
      builder: (ctx) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ViewConfig(
            buildContext: buildContext,
          ),
        );
      });
}

class ViewConfig extends StatefulWidget {
  BuildContext buildContext;
  ViewConfig({@required this.buildContext});
  @override
  _ViewConfigState createState() =>
      _ViewConfigState(buildContext: buildContext);
}

class _ViewConfigState extends State<ViewConfig> {
  BuildContext buildContext;
  _ViewConfigState({@required this.buildContext});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
              leading: Global.oPerfilNegocio.imagen_perfil == "" ||
                      Global.oPerfilNegocio.imagen_perfil == "default"
                  ? CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 18.0,
                      child: Text(
                          Global.oPerfilNegocio.nombre_negocio.substring(0, 1),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    )
                  : CachedNetworkImage(
                      imageUrl: Global.oPerfilNegocio.imagen_perfil,
                      placeholder: (context, url) => const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 18.0,
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 18.0,
                      ),
                    ),
              title: Text('Editar'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfileCuenta(
                      perfilNegocio: Global.oPerfilNegocio,
                    ),
                  ),
                );
              },
            ),
            Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
            DynamicTheme.of(buildContext)
                .getViewListTileSelectTheme(buildContext: buildContext),
          ],
        ),
      ),
    );
  }
}
