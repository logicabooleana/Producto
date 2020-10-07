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
  bool crearCategoria, loadSave = false;
  BuildContext buildContextPrincipal;
  TextEditingController _editingController;

  @override
  void initState() {
    crearCategoria = false;
    loadSave = false;
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categoria"),
      ),
      body: FutureBuilder(
        future:
            Global.getCatalogoCategorias(idNegocio: Global.oPerfilNegocio.id)
                .getDataCategoriaAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Global.listCategoriasCatalogo = snapshot.data;
            if (Global.listCategoriasCatalogo.length == 0) {
              return crearCategoria == false
                  ? ListTile(
                      contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                      leading: CircleAvatar(
                        radius: 24.0,
                        child: Icon(Icons.add),
                      ),
                      dense: true,
                      title: Text("Crear categoría"),
                      onTap: () {
                        setState(() {
                          crearCategoria = true;
                        });
                      },
                    )
                  : widgetCrearCategoria(buildContext: buildContext);
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shrinkWrap: true,
              itemCount: Global.listCategoriasCatalogo.length,
              itemBuilder: (BuildContext context, int index) {
                Categoria categoria = Global.listCategoriasCatalogo[index];
                return index == 0
                    ? Column(
                        children: <Widget>[
                          crearCategoria == false
                              ? ListTile(
                                  contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    child: Icon(Icons.add),
                                  ),
                                  dense: true,
                                  title: Text("Crear categoría"),
                                  onTap: () {
                                    setState(() {
                                      crearCategoria = true;
                                    });
                                  },
                                )
                              : widgetCrearCategoria(
                                  buildContext: buildContext),
                          Global.listCategoriasCatalogo != 0
                              ? Divider(endIndent: 12.0, indent: 12.0,height: 0.0)
                              : Container(),
                          Global.listCategoriasCatalogo != 0
                              ? ListTile(
                                contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
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
                                        .setNombreFiltro = "Mostrar todos";
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
                          Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
                          ListTile(
                            contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
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
                              buildContext.read<ProviderCatalogo>().setNombreFiltro = categoria.nombre;
                              buildContext.read<ProviderCatalogo>().setCategoria = categoria;
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                                  backgroundColor:Theme.of(buildContext).canvasColor,
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
                          ),
                          Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
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
                                          buildContextCategoria: buildContext),
                                    );
                                  });
                            },
                          ),
                          Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
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

  Categoria newCategoria = new Categoria();
  Widget widgetCrearCategoria({@required BuildContext buildContext}) {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 24.0,
            child: Icon(Icons.border_color),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _editingController,
                onChanged: (value) => newCategoria.nombre = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Categoria"),
                // your TextField's Content
              ),
            ),
          ),
        ],
      ),
      trailing: loadSave == false
          ? IconButton(
              icon: new Icon(Icons.check),
              onPressed: () async {
                setState(() {
                  loadSave = true;
                });
                newCategoria.id = id;
                await Global.getDataCatalogoCategoria(
                        idNegocio: Global.oPerfilNegocio.id,
                        idCategoria: newCategoria.id)
                    .upSetCategoria(newCategoria.toJson());
                setState(() {
                  Global.listCategoriasCatalogo.add(newCategoria);
                  loadSave = false;
                  crearCategoria = false;
                  _editingController.clear();
                });
              },
            )
          : CircularProgressIndicator(),
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
  TextEditingController _editingController;
  List<Categoria> listaSubcategoria = new List<Categoria>();

  @override
  void initState() {
    crearCategoria = false;
    loadSave = false;
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContextSubcategoria) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategoria"),
      ),
      body: FutureBuilder(
        future: Global.getCatalogoSubcategorias(
                idNegocio: Global.oPerfilNegocio.id,
                idCategoria: paramCategoria.id ?? "")
            .getDataCategoriaAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            listaSubcategoria = snapshot.data;
            if (listaSubcategoria.length == 0) {
              return Column(
                children: [
                  crearCategoria == false
                      ? ListTile(
                          contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                          leading: CircleAvatar(
                            radius: 24.0,
                            child: Icon(Icons.add),
                          ),
                          dense: true,
                          title: Text("Crear categoría"),
                          onTap: () {
                            setState(() {
                              crearCategoria = true;
                            });
                          },
                        )
                      : widgetCrearSubcategoria(idCategoria: paramCategoria.id),
                  ListTile(
                    contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                    leading: CircleAvatar(
                      radius: 24.0,
                      child: Icon(Icons.all_inclusive),
                    ),
                    dense: true,
                    title:
                        Text("Mostrar todos", style: TextStyle(fontSize: 16.0)),
                    onTap: () {
                      Navigator.pop(buildContextCategoria);
                      Navigator.pop(buildContextSubcategoria);
                    },
                  )
                ],
              );
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shrinkWrap: true,
              itemCount: listaSubcategoria.length,
              itemBuilder: (BuildContext context, int index) {
                Categoria subcategoria = listaSubcategoria[index];
                return index == 0
                    ? Column(
                        children: <Widget>[
                          crearCategoria == false
                              ? ListTile(
                                contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    child: Icon(Icons.add),
                                  ),
                                  dense: true,
                                  title: Text("Crear categoría"),
                                  onTap: () {
                                    setState(() {
                                      crearCategoria = true;
                                    });
                                  },
                                )
                              : widgetCrearSubcategoria(
                                  idCategoria: paramCategoria.id),
                          listaSubcategoria.length != 0
                              ? Divider(endIndent: 12.0, indent: 12.0,height: 0.0)
                              : Container(),
                          listaSubcategoria.length != 0
                              ? ListTile(
                                contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
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
                          Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
                          ListTile(
                            contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
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
                                      .setNombreFiltro =
                                  listaSubcategoria[index].nombre;
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setSubategoria = listaSubcategoria[index];
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                          ),
                          Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
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
                                      .setNombreFiltro =
                                  listaSubcategoria[index].nombre;
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setSubategoria = listaSubcategoria[index];
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                          ),
                          Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
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

  Categoria newCategoria = new Categoria();
  Widget widgetCrearSubcategoria({@required String idCategoria = ""}) {
    String id = new DateTime.now().millisecondsSinceEpoch.toString();
    return ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 24.0,
            child: Icon(Icons.border_color),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _editingController,
                onChanged: (value) => newCategoria.nombre = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Subcategoria"),
                // your TextField's Content
              ),
            ),
          ),
        ],
      ),
      trailing: loadSave == false
          ? IconButton(
              icon: new Icon(Icons.check),
              onPressed: () async {
                setState(() {
                  loadSave = true;
                });
                newCategoria.id = id;
                await Global.getDataCatalogoSubcategoria(
                        idNegocio: Global.oPerfilNegocio.id,
                        idCategoria: idCategoria,
                        idSubcategoria: newCategoria.id)
                    .upSetCategoria(newCategoria.toJson());
                setState(() {
                  listaSubcategoria.add(newCategoria);
                  loadSave = false;
                  crearCategoria = false;
                  _editingController.clear();
                });
              },
            )
          : CircularProgressIndicator(),
    );
  }
}


Future<void> showModalBottomSheetConfig({@required BuildContext buildContext}) async {
    showModalBottomSheet(
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (ctx) {
          return ClipRRect(
            borderRadius:  
            BorderRadius.circular(20), 
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
  _ViewConfigState createState() =>_ViewConfigState(buildContext: buildContext);
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
              contentPadding:EdgeInsets.symmetric(vertical: 8.0,horizontal: 13.0),
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
              onTap: (){
                Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => ProfileCuenta(perfilNegocio: Global.oPerfilNegocio,),
                ),
              );
              },
            ),
            Divider(endIndent: 12.0, indent: 12.0,height: 0.0),
            DynamicTheme.of(buildContext).getViewListTileSelectTheme(buildContext: buildContext),
          ],
        ),
      ),
    );
  }
}
