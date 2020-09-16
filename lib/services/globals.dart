import 'dart:async';

import 'package:catalogo/services/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:loadany/loadany_widget.dart';

import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:catalogo/models/models_profile.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static PerfilNegocio oPerfilNegocio;
  static List<PerfilNegocio> listAdminPerfilNegocio=new List();
  static List<ProductoNegocio> listProudctosNegocio=new List();
  static List<Seguidor> listSeguidoresRef=new List();
  static List<Categoria> listCategoriasCatalogo=new List();
  static PreferenciasUsuario prefs = new PreferenciasUsuario();

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

    // Data Models
  static final Map modelsSeguidor = {
    Seguidor: (data) => Seguidor.fromMap(data),
  };
  static final Map modelsAdminUsuarioCuenta = {
    AdminUsuarioCuenta: (data) => AdminUsuarioCuenta.fromMap(data),
  };
  static final Map modelsPerfilNegocio = {
    PerfilNegocio: (data) => PerfilNegocio.fromMap(data),
  };
  static final Map modelsPrecioProducto = {
    Precio: (data) => Precio.fromMap(data),
  };
  static final Map modelsProducto = {
    ProductoNegocio: (data) => ProductoNegocio.fromMap(data),
  };
  static final Map modelsProductoGlobal = {
    Producto: (data) => Producto.fromMap(data),
  };
  static final Map modelsCategoria = {
    Categoria: (data) => Categoria.fromMap(data),
  };
  static final Map modelsMarca = {
    Marca: (data) => Marca.fromMap(data),
  };
  

  // Firestore References for Writes
  static final Collection<ProductoNegocio> listProductos = Collection<ProductoNegocio>(path: 'PRODUCTOS');

  // Consultas DB ( Dodument )
  static Document<Marca> getMarca( { @required String idMarca,String isoPais="ARG"} ){
    // Firestore References for Writes
    return  Document<Marca>(path: '/APP/ARG/MARCAS/$idMarca');
  }
  static Document<Precio> getPreciosProducto( { @required String idNegocio,@required String idProducto,String isoPAis="ARG"} ){
    // Firestore References for Writes
    return  Document<Precio>(path: '/APP/$isoPAis/PRODUCTOS/$idProducto/REGISTRO_PRECIOS_$isoPAis/$idNegocio'); // '/APP/ARG/PRODUCTOS'
  }
  static Document<PerfilNegocio> getNegocio( {@required String idNegocio} ){
    // Firestore References for Writes
    return  Document<PerfilNegocio>(path: '/NEGOCIOS/$idNegocio'); // '/APP/ARG/PRODUCTOS'
  }
  static Document<Seguidor> getSeguidores( { String idNegocio,String idSeguirdor } ){
    // Firestore References for Writes
    return  Document<Seguidor>(path: '/NEGOCIOS/$idNegocio/SEGUIDORES/$idSeguirdor'); // '/APP/ARG/PRODUCTOS'
  }
  static Document<AdminUsuarioCuenta> getDataAdminUserNegocio( { String idNegocio , String idUserAdmin } ){
    // Firestore References for Writes
    return  Document<AdminUsuarioCuenta>(path: '/NEGOCIOS/$idNegocio/ADMINISTRADOR_NEGOCIOS/$idUserAdmin'); // '/APP/ARG/PRODUCTOS'
  }
  static Document<AdminUsuarioCuenta> getDataProductoNegocio( { @required String idNegocio , @required String idProducto } ){
    // Firestore References for Writes
    return  Document<AdminUsuarioCuenta>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO/$idProducto'); // '/APP/ARG/PRODUCTOS'
  }
  static Document<Categoria> getDataCatalogoCategoria( { @required String idNegocio,@required String idCategoria} ){
    // Firestore References for Writes
    if(idNegocio==null){idNegocio="";}
    return  Document<Categoria>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO_CATEGORIA/$idCategoria'); 
  }
  static Document<Categoria> getDataCatalogoSubcategoria( { @required String idNegocio,@required String idCategoria,@required String idSubcategoria} ){
    // Firestore References for Writes
    if(idNegocio==null){idNegocio="";}
    return  Document<Categoria>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO_CATEGORIA/$idCategoria/SUBCATEGORIA/$idSubcategoria'); 
  }
  static Document<Producto> getProductosPrecargado({ String idProducto="",String isoPAis="ARG"} ){
    // Firestore References for Writes
    if(idProducto==null){idProducto="";}
    return  Document<Producto>(path: '/APP/ARG/PRODUCTOS/$idProducto'); 
  }

  // Consultas DB ( Colecction )
  static Collection<Marca> getMarcasAll( {String isoPais="ARG"} ){
    // Firestore References for Writes
    return  Collection<Marca>(path: '/APP/ARG/MARCAS');
  }
  static Collection<Precio> getListPreciosProducto( { String idProducto,String isoPAis="ARG"} ){
    // Firestore References for Writes
    return  Collection<Precio>(path: '/APP/$isoPAis/PRODUCTOS/$idProducto/REGISTRO_PRECIOS_$isoPAis'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<PerfilNegocio> getListNegocioAdmin( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<PerfilNegocio>(path: '/USUARIOS/$idNegocio/ADMINISTRADOR_NEGOCIOS'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<ProductoNegocio> getListSeguidores( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<ProductoNegocio>(path: '/NEGOCIOS/$idNegocio/SEGUIDORES'); 
  }
  static Collection<ProductoNegocio> getCatalogoNegocio( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<ProductoNegocio>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<Categoria> getCatalogoCategorias( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<Categoria>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO_CATEGORIA'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<Categoria> getCatalogoSubcategorias( { @required String idNegocio,@required String idCategoria} ){
    // Firestore References for Writes
    return  Collection<Categoria>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO_CATEGORIA/$idCategoria/SUBCATEGORIA'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<Producto> getProductosPrecargadoAll({ String idProducto,String isoPAis="ARG"} ){
    // Firestore References for Writes
    return  Collection<Producto>(path: '/APP/$isoPAis/PRODUCTOS/$idProducto'); 
  }


  // Funciones
  static Future<List<ProductoNegocio>> getSeach( { String seach} ) async{
    List<ProductoNegocio> resutlList ;
    for (int i = 0; i < listProudctosNegocio.length; i++) { //listData[i]['titulo']
      if ( true) {
        resutlList.add(listProudctosNegocio[i]);
      }
    }
    return resutlList;
  }
  // Funciones
  static Future<List<ProductoNegocio>> updateProductos({@required List<ProductoNegocio> listaProductos })  async{
    
    List<ProductoNegocio> nuevaLista=[];
    listaProductos.forEach((element)  {
      getProductosPrecargado(idProducto:element.id).getDataProductoGlobal().then((value) {
        element.urlimagen=value.urlimagen;
      });
      nuevaLista.add(element);
    });
    /* for (int i = 0; i < listaProductos.length; i++) {
      Producto producto = await getProductosPrecargado(idProducto: listaProductos[i].id).getDataProductoGlobal();
        listaProductos[i].urlimagen=producto.urlimagen;
    } */
    return nuevaLista;
  }


  // Funciones
  static void actualizarPerfilNegocio( { @required PerfilNegocio perfilNegocio } ){
    listProudctosNegocio.clear();
    listCategoriasCatalogo.clear();
    listAdminPerfilNegocio.clear();
    listSeguidoresRef.clear();
    oPerfilNegocio=perfilNegocio;
  }

  
}

class ProviderPerfilNegocio with ChangeNotifier {
//Creamos una clase "MyProvider" y le agregamos las capacidades de Change Notifier.

PerfilNegocio perfilNegocio ;
int _cantidadProductos =0; 

//Creamos el método Get, para poder obtener el valor de mitexto
int get getCantidadProductos =>_cantidadProductos; 
PerfilNegocio get getCuentaNegocio =>perfilNegocio;

//Ahora creamos el método set para poder actualizar el valor de _mitexto, este método recibe un valor newTexto de tipo String
set setCantidadProductos(int cantidadProductos ) {
  _cantidadProductos = cantidadProductos; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
}
set setCuentaNegocio( PerfilNegocio cuenta ) {
  perfilNegocio = cuenta; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
}
}
class ProviderCatalogo with ChangeNotifier {
  //Creamos una clase "MyProvider" y le agregamos las capacidades de Change Notifier.
  
  LoadStatus statusCargaGridListCatalogo = LoadStatus.normal;
  List<ProductoNegocio> cataloLoadMore = new List<ProductoNegocio>();
  List<String> listMarcas = new List<String>();
  List<ProductoNegocio> listCatalogo=new List();
  List<ProductoNegocio> listCatalogoFilter=new List();
  List<ProductoNegocio> listCatalogoCategoria=new List();
  String idMarca="";
  Categoria categoria;
  Categoria subcategoria;
  String sNombreFiltro="Todos";

  //Creamos el método Get, para poder obtener el valor de mitexto
  String get getIdMarca =>this.idMarca??"";
  Categoria get getCategoria =>this.categoria;
  Categoria get getSubcategoria =>this.subcategoria;
  List<ProductoNegocio> get getCatalogo =>cataloLoadMore;
  List<String> get getMarcas =>listMarcas??[];

  //Ahora creamos el método set para poder actualizar el valor de _mitexto, este método recibe un valor newTexto de tipo String
  set setClean(bool clean){
    if(clean){
      listMarcas.clear();
      listCatalogo.clear();
      listCatalogoFilter.clear();
      listCatalogoCategoria.clear();
      idMarca="";
      this.categoria=null;
      this.subcategoria=null; 
    }
  }
  set setIdMarca( String id ) {
    this.idMarca = id; 
    getFilterCatalogo(categoria:this.categoria,subcategoria: subcategoria,idMarca:this.idMarca );
    notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }
  
  set setCatalogo( List<ProductoNegocio> list ) {
    this.listCatalogo = list; 
    getFilterCatalogo(categoria:this.categoria,subcategoria: subcategoria ,idMarca:this.idMarca);
    //notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
  }
  set setNombreFiltro(String nombreFiltro){
    this.sNombreFiltro=nombreFiltro;
  }
  set setCategoria( Categoria categoria ) {
    this.subcategoria=null;
    this.categoria = categoria; 
    getFilterCatalogo(categoria:this.categoria,subcategoria: subcategoria,idMarca: this.idMarca );
    notifyListeners();
  }
  set setSubategoria( Categoria subcategoria ) {
    this.subcategoria = subcategoria; 
    getFilterCatalogo(categoria:this.categoria,subcategoria: subcategoria,idMarca: this.idMarca );
    notifyListeners();
  }
  int getNumeroDeProductosDeMarca({@required String id}){

    int cantidad=0;
    
    for (ProductoNegocio item in this.listCatalogo) {
      if(item.id_marca==id){
        cantidad++;
      }
    }

    return cantidad;
  }
  void getFilterCatalogo({@required Categoria categoria,@required Categoria subcategoria,String idMarca}){

    List<ProductoNegocio> lista =[];
    this.listCatalogoFilter.clear();
    this.listCatalogoCategoria.clear();
    statusCargaGridListCatalogo = LoadStatus.normal;

    if(categoria==null){

      for (var i = 0; i < this.listCatalogo.length; i++) {
          
        if(idMarca!=""){
          if( idMarca==this.listCatalogo[i].id_marca ){lista.add(this.listCatalogo[i]); }
        }else{
          lista.add(this.listCatalogo[i]);
        }
      }
      this.listCatalogoFilter=lista;
      // Carga las marca de los prosductos mostrados de la categoria
    }else{
      for (var i = 0; i < this.listCatalogo.length; i++) {

        if(subcategoria==null){
        if(categoria.id!=""&& idMarca=="" ){
          if(this.listCatalogo[i].categoria==categoria.id){ 
            lista.add(this.listCatalogo[i]); 
            listCatalogoCategoria.add(this.listCatalogo[i]); 
          }
        }else if(categoria.id!=""&& idMarca!=""){
          if(this.listCatalogo[i].categoria==categoria.id){listCatalogoCategoria.add(this.listCatalogo[i]);if( idMarca==this.listCatalogo[i].id_marca ){lista.add(this.listCatalogo[i]); }}
        }else if(categoria.id==""&& idMarca!=""){
          if( idMarca==this.listCatalogo[i].id_marca ){lista.add(this.listCatalogo[i]); }
        }
      }else{
        if(subcategoria.id!=""&& idMarca=="" ){
          if(this.listCatalogo[i].subcategoria==subcategoria.id){ 
            lista.add(this.listCatalogo[i]); 
            listCatalogoCategoria.add(this.listCatalogo[i]); 
          }
        }else if(subcategoria.id!=""&& idMarca!=""){
          if(this.listCatalogo[i].subcategoria==subcategoria.id){
            listCatalogoCategoria.add(this.listCatalogo[i]);
            if( idMarca==this.listCatalogo[i].id_marca ){
              lista.add(this.listCatalogo[i]); 
              }
            }
        }else if(subcategoria.id==""&& idMarca!=""){
          if( idMarca==this.listCatalogo[i].id_marca ){
            lista.add(this.listCatalogo[i]); 
            }
        }
      }
      }

    this.listCatalogoFilter=lista;
    }
    // Carga las marca de los prosductos mostrados de la categoria
    _updateMarcas(listaProductos:  this.listCatalogoFilter);
    this.cataloLoadMore.clear();
    for (var i = 0; i < 15; ++i) {
        if( this.cataloLoadMore.length < this.listCatalogoFilter.length ){
          this.cataloLoadMore.add(this.listCatalogoFilter[ i]);
        }
    } //notificamos a los widgets que esten escuchando el stream.

  }

  // extrae las marcas del catalogo
  _updateMarcas({ List<ProductoNegocio> listaProductos} ){

    this.listMarcas.clear();
    List<String>  marcas =[];

    if( this.categoria==null){
      for (var Producto in this.listCatalogo) {
        if( Producto.id_marca!= null && Producto.id_marca != "" ){
          marcas.add(Producto.id_marca);
        }
      }
    }else if( this.categoria!=null ){
      for (var Producto in this.listCatalogoCategoria) {
        if( Producto.id_marca!= null && Producto.id_marca != "" ){
          marcas.add(Producto.id_marca);
        }
      }
    }


    this.listMarcas=marcas.toSet().toList();
  }

  Future<void> getLoadMore() async {
    statusCargaGridListCatalogo = LoadStatus.loading;
     notifyListeners();
    Timer.periodic(Duration(milliseconds: 2000), (Timer timer) {
      timer.cancel();
      int length = cataloLoadMore.length;
      for (var i = 0; i < 15; ++i) {
        if( cataloLoadMore.length < this.listCatalogoFilter.length ){
          cataloLoadMore.add(listCatalogoFilter[length + i]);
        }
      }

      if (cataloLoadMore.length >= listCatalogoFilter.length) {
        statusCargaGridListCatalogo = LoadStatus.completed;
      } else {
        statusCargaGridListCatalogo = LoadStatus.normal;
      }
      notifyListeners();
    });
  }
}

class ProviderMarcasProductos with ChangeNotifier {

List<String> listMarcas = new List<String>();

//Creamos el método Get, para poder obtener el valor de mitexto
List<String> get getHashMaplistaMarca =>listMarcas; 

//Ahora creamos el método set para poder actualizar el valor de _mitexto, este método recibe un valor newTexto de tipo String
set setHashMaplistaMarca( List<String> hashMap ) {
  listMarcas = hashMap; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
}
}



