import 'package:producto/services/models.dart';
import 'package:flutter/material.dart';
import 'package:producto/screens/page_producto_view.dart';
import 'package:producto/utils/utils.dart';

class DataSearch extends SearchDelegate {
  List listOBJ;
  DataSearch({@required this.listOBJ}) {
    listOBJ = listOBJ;
  }

  @override
  String get searchFieldLabel => 'Buscar producto';

  @override
 ThemeData appBarTheme(BuildContext context) {
   final ThemeData theme = Theme.of(context);
   return ThemeData(
     primaryColor:theme.primaryColor,
     brightness: theme.brightness,
   );
 }

 

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones para nestro AppBar ( lado derecho )
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () { query = ""; }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono del AppBar ( lado izquierdo )
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {close(context, null); });
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
    List<ProductoNegocio> resutlList = new List();
    for (int i = 0; i < listOBJ.length; i++) {
      if (Buscardor.buscar(listOBJ[i].titulo, query)||Buscardor.buscar(listOBJ[i].descripcion, query)) { 
        resutlList.add(listOBJ[i]);
      }
    }
    if (resutlList.length == 0) {
      return Container(child: Center(child: Text("Sin resultados")));
    }
    return ListView.builder(
        itemCount: resutlList.length,
        itemBuilder: (context, index) {
          final ProductoNegocio product = resutlList[index];
          return ListTile(
            leading: FadeInImage(
              image: NetworkImage(product.urlimagen),
              placeholder: AssetImage("assets/loading.gif"),
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
              width: 50.0,
            ),
            title: Text(product.titulo),
            subtitle: Text(product.descripcion),
            onTap: () {
               Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => product != null
                      ? ProductScreen(producto: product)
                      : Scaffold(
                          body: Center(child: Text("Se produjo un Error!"))),
                ),
              );
            },
          );
        });
  }
}
