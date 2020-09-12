import 'package:catalogo/models/models_catalogo.dart';
import 'package:catalogo/services/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewCategoria extends StatefulWidget {
  BuildContext buildContext;
  ViewCategoria({@required this.buildContext});

  @override
  _ViewCategoriaState createState() => _ViewCategoriaState(buildContextPrincipal: buildContext);
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
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 15.0),
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
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 15.0),
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
                              : widgetCrearCategoria(buildContext: buildContext),
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
                                    buildContext
                                        .read<ProviderCatalogo>()
                                        .setIdCategoria = "todos";
                                    buildContext
                                        .read<ProviderCatalogo>()
                                        .setNombreFiltro = "Todos";
                                    buildContext
                                        .read<ProviderCatalogo>()
                                        .setIdMarca = "";
                                    Navigator.pop(context,
                                        Global.listCategoriasCatalogo[index]);
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
                                        categoria.nombre.substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
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
                              //ViewSubCategoria();
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                                  backgroundColor:
                                      Theme.of(buildContext).canvasColor,
                                  context: buildContextPrincipal,
                                  builder: (ctx) {
                                    return ClipRRect(
                                      child: ViewSubCategoria(categoria:categoria,buildContextCategoria: buildContext,),
                                    );
                                  });
                              /*buildContext
                                      .read<ProviderCatalogo>()
                                      .setNombreFiltro =
                                  Global.listCategoriasCatalogo[index]
                                      .nombre;
                              buildContext
                                      .read<ProviderCatalogo>()
                                      .setIdCategoria =
                                  Global
                                      .listCategoriasCatalogo[index].id;
                              buildContext
                                  .read<ProviderCatalogo>()
                                  .setIdMarca = "";
                              Navigator.pop(context,
                                  Global.listCategoriasCatalogo[index]);*/
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
                                        categoria.nombre.substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
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
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0)),
                                  backgroundColor:
                                      Theme.of(buildContext).canvasColor,
                                  context: buildContextPrincipal,
                                  builder: (ctx) {
                                    return ClipRRect(
                                      child: ViewSubCategoria(categoria:categoria,buildContextCategoria:buildContext),
                                    );
                                  });
                              /* buildContext
                                      .read<ProviderCatalogo>()
                                      .setNombreFiltro =
                                  Global.listCategoriasCatalogo[index].nombre;
                              buildContext
                                      .read<ProviderCatalogo>()
                                      .setIdCategoria =
                                  Global.listCategoriasCatalogo[index].id;
                              buildContext.read<ProviderCatalogo>().setIdMarca =
                                  "";
                              Navigator.pop(context,
                                  Global.listCategoriasCatalogo[index]); */
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
    );
  }
  Categoria newCategoria=new Categoria();
  Widget widgetCrearCategoria({@required BuildContext buildContext}) {
    String id=new DateTime.now().millisecondsSinceEpoch.toString();
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
                onChanged: (value)=>newCategoria.nombre=value,
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
              onPressed: () async{
                setState(() {
                  loadSave = true;
                });
                newCategoria.id=id;
                await Global.getDataCatalogoCategoria(idNegocio:Global.oPerfilNegocio.id,idCategoria: newCategoria.id).upSetCategoria(newCategoria.toJson());
                setState(() {
                  Global.listCategoriasCatalogo.add(newCategoria);
                  loadSave = false;
                  crearCategoria= false;
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
  ViewSubCategoria({@required this.buildContextCategoria,@required this.categoria});

  @override
  ViewSubCategoriaState createState() => ViewSubCategoriaState(paramCategoria: this.categoria,buildContextCategoria: buildContextCategoria);
}

class ViewSubCategoriaState extends State<ViewSubCategoria> {
  ViewSubCategoriaState({@required this.buildContextCategoria,@required this.paramCategoria});
  // Variables
  BuildContext buildContextCategoria;
  Categoria paramCategoria;
  bool crearCategoria, loadSave = false;
  TextEditingController _editingController;
  List<Categoria> listaSubcategoria=new List<Categoria>();

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
        future:Global.getCatalogoSubcategorias(idNegocio: Global.oPerfilNegocio.id,idCategoria: paramCategoria.id??"").getDataCategoriaAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            listaSubcategoria = snapshot.data;
            if (listaSubcategoria.length == 0) {
              return Column(
                children: [
                  crearCategoria == false
                      ? ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15.0),
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
                      :widgetCrearSubcategoria(idCategoria: paramCategoria.id),
                  ListTile(
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    child: Icon(Icons.all_inclusive),
                                  ),
                                  dense: true,
                                  title: Text("Mostrar todos",
                                      style: TextStyle(fontSize: 16.0)),
                                  onTap: () {
                                    buildContextSubcategoria.read<ProviderCatalogo>()
                                        .setIdCategoria = paramCategoria.id;
                                    buildContextSubcategoria.read<ProviderCatalogo>()
                                        .setNombreFiltro = paramCategoria.nombre;
                                    buildContextSubcategoria.read<ProviderCatalogo>()
                                        .setIdMarca = "";
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
                Categoria subcategoria =listaSubcategoria[index];
                return index == 0
                    ? Column(
                        children: <Widget>[
                          crearCategoria == false
                              ? ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 15.0),
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
                          listaSubcategoria.length != 0
                              ? Divider(endIndent: 12.0, indent: 12.0)
                              : Container(),
                          listaSubcategoria.length != 0
                              ? ListTile(
                                  leading: CircleAvatar(
                                    radius: 24.0,
                                    child: Icon(Icons.all_inclusive),
                                  ),
                                  dense: true,
                                  title: Text("Mostrar todos",
                                      style: TextStyle(fontSize: 16.0)),
                                  onTap: () {
                                    buildContextSubcategoria.read<ProviderCatalogo>()
                                        .setIdCategoria = paramCategoria.id;
                                    buildContextSubcategoria.read<ProviderCatalogo>()
                                        .setNombreFiltro = paramCategoria.nombre;
                                    buildContextSubcategoria.read<ProviderCatalogo>()
                                        .setIdMarca = "";
                                    Navigator.pop(buildContextCategoria);
                                    Navigator.pop(buildContextSubcategoria);
                                  },
                                )
                              : Container(),
                          Divider(endIndent: 12.0, indent: 12.0),
                          ListTile(
                            leading: subcategoria.url_imagen == "" ||
                                    subcategoria.url_imagen == "default"
                                ? CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 24.0,
                                    child: Text(
                                        subcategoria.nombre.substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: subcategoria.url_imagen,
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
                            title: Text(subcategoria.nombre),
                            onTap: () {
                              buildContextSubcategoria.read<ProviderCatalogo>()
                                      .setNombreFiltro =listaSubcategoria[index].nombre;
                              buildContextSubcategoria.read<ProviderCatalogo>()
                                      .setIdCategoria =listaSubcategoria[index].id;
                              buildContextSubcategoria.read<ProviderCatalogo>().setIdMarca =
                                  "";
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                          ),
                          Divider(endIndent: 12.0, indent: 12.0),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ListTile(
                            leading: subcategoria.url_imagen == "" ||
                                    subcategoria.url_imagen == "default"
                                ? CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 24.0,
                                    child: Text(
                                        subcategoria.nombre.substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: subcategoria.url_imagen,
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
                            title: Text(subcategoria.nombre),
                            onTap: () {
                              buildContextSubcategoria.read<ProviderCatalogo>()
                                      .setNombreFiltro =listaSubcategoria[index].nombre;
                              buildContextSubcategoria.read<ProviderCatalogo>()
                                      .setIdCategoria =listaSubcategoria[index].id;
                              buildContextSubcategoria.read<ProviderCatalogo>().setIdMarca =
                                  "";
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
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
    );
  }

  Categoria newCategoria=new Categoria();
  Widget widgetCrearSubcategoria({@required String idCategoria=""}) {
    String id=new DateTime.now().millisecondsSinceEpoch.toString();
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
                onChanged: (value)=>newCategoria.nombre=value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText:"Subcategoria"),
                // your TextField's Content
              ),
            ),
          ),
        ],
      ),
      trailing: loadSave == false
          ? IconButton(
              icon: new Icon(Icons.check),
              onPressed: () async{
                setState(() {
                  loadSave = true;
                });
                newCategoria.id=id;
                await Global.getDataCatalogoSubcategoria(idNegocio:Global.oPerfilNegocio.id,idCategoria: idCategoria,idSubcategoria: newCategoria.id).upSetCategoria(newCategoria.toJson());
                setState(() {
                  listaSubcategoria.add(newCategoria);
                  loadSave = false;
                  crearCategoria= false;
                  _editingController.clear();
                });
              },
            )
          : CircularProgressIndicator(),
    );
  }
}
