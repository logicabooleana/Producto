import 'package:flutter/material.dart';
import 'package:Producto/utils/utils.dart';
import 'package:Producto/models/models_catalogo.dart';
import 'package:Producto/shared/widgets_image_circle.dart';
import 'package:diacritic/diacritic.dart';

class DataSearchMarcaProduct extends SearchDelegate {
  List<Marca> listMarcas;
  DataSearchMarcaProduct({@required this.listMarcas}) {
    listMarcas = listMarcas;
  }

  @override
  String get searchFieldLabel => 'Buscar producto';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ThemeData(
        primaryColor: Colors.grey[800], brightness: theme.brightness);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones para nestro AppBar ( lado derecho )
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono del AppBar ( lado izquierdo )
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Las sugerencias que aparecen cuando la persona escribe

    if (query.isEmpty) {
      return Container(child: Center(child: Icon(Icons.search)));
    }
    List<Marca> resutlList = new List();
    for (int i = 0; i < listMarcas.length; i++) {
      if (Buscardor.buscar(
          removeDiacritics(listMarcas[i].titulo), removeDiacritics(query))) {
        resutlList.add(listMarcas[i]);
      }
    }
    if (resutlList.length == 0) {
      return Container(child: Center(child: Text("Sin resultados")));
    }
    return ListView.builder(
        itemCount: resutlList.length,
        itemBuilder: (context, index) {
          final Marca itemMarca = resutlList[index];
          return ListTile(
            leading: viewCircleImage(texto: itemMarca.titulo, url: itemMarca.url_imagen, size: 50.0),
            title: Row(
              children: <Widget>[
                itemMarca.verificado == true
                    ? Padding(
                        padding: EdgeInsets.all(5.0),
                        child: new Image.asset('assets/icon_verificado.png',
                            width: 16.0, height: 16.0))
                    : new Container(),
                Expanded(
                  child: Text(itemMarca.titulo,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).textTheme.bodyText1.color)),
                ),
              ],
            ),
            subtitle: Text(itemMarca.descripcion),
            onTap: () {
              Navigator.pop(context, itemMarca);
            },
          );
        });
  }
}
