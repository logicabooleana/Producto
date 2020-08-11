import 'dart:async';

import 'package:catalogo/services/preferencias_usuario.dart';
import 'package:flutter/material.dart';

import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:catalogo/models/models_catalogo.dart';
import 'package:catalogo/models/models_profile.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static final String title = 'Fireship';
  static PerfilNegocio oPerfilNegocio;
  static List<PerfilNegocio> listAdminPerfilNegocio=new List();
  static List<Producto> listProudctosNegocio=new List();
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
    Producto: (data) => Producto.fromMap(data),
  };
  static final Map modelsCategoria = {
    Categoria: (data) => Categoria.fromMap(data),
  };
  static final Map modelsMarca = {
    Marca: (data) => Marca.fromMap(data),
  };
  

  // Firestore References for Writes
  static final Collection<Producto> listProductos = Collection<Producto>(path: 'PRODUCTOS');

  // Consultas DB ( Dodument )
  static Document<Marca> getMarca( { @required String idMarca,String isoPais="ARG"} ){
    // Firestore References for Writes
    return  Document<Marca>(path: '/APP/ARG/MARCAS/$idMarca');
  }
  static Document<PerfilNegocio> getNegocio( { String idNegocio} ){
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
  // Consultas DB ( Colecction )
  static Collection<Precio> getListPreciosProducto( { String idProducto,String isoPAis="ARG"} ){
    // Firestore References for Writes
    return  Collection<Precio>(path: '/APP/$isoPAis/PRODUCTOS/$idProducto/REGISTRO_PRECIOS_$isoPAis'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<PerfilNegocio> getListNegocioAdmin( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<PerfilNegocio>(path: '/USUARIOS/$idNegocio/ADMINISTRADOR_NEGOCIOS'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<Producto> getListSeguidores( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<Producto>(path: '/NEGOCIOS/$idNegocio/SEGUIDORES'); 
  }
  static Collection<Producto> getCatalogoNegocio( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<Producto>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO'); // '/APP/ARG/PRODUCTOS'
  }
  static Collection<Categoria> getCatalogoCategorias( { String idNegocio} ){
    // Firestore References for Writes
    return  Collection<Categoria>(path: '/NEGOCIOS/$idNegocio/EXTENSION_CATALOGO_CATEGORIA'); // '/APP/ARG/PRODUCTOS'
  }


  // Funciones
  static Future<List<Producto>> getSeach( { String seach} ) async{
    List<Producto> resutlList ;
    for (int i = 0; i < listProudctosNegocio.length; i++) { //listData[i]['titulo']
      if ( true) {
        resutlList.add(listProudctosNegocio[i]);
      }
    }
    return resutlList;
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
String idMarca="";
int _cantidadProductos =0; 

//Creamos el método Get, para poder obtener el valor de mitexto
int get getCantidadProductos =>_cantidadProductos; 
String get getIdMarca =>idMarca;
PerfilNegocio get getCuentaNegocio =>perfilNegocio;

//Ahora creamos el método set para poder actualizar el valor de _mitexto, este método recibe un valor newTexto de tipo String
set setCantidadProductos(int cantidadProductos ) {
  _cantidadProductos = cantidadProductos; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
}
set setIdMarca( String idmarca ) {
  idMarca = idmarca; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
}
set setCuentaNegocio( PerfilNegocio cuenta ) {
  perfilNegocio = cuenta; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
}
}
class ProviderIdMarca with ChangeNotifier {
//Creamos una clase "MyProvider" y le agregamos las capacidades de Change Notifier.

String idMarca="";

//Creamos el método Get, para poder obtener el valor de mitexto
String get getIdMarca =>idMarca??"";

//Ahora creamos el método set para poder actualizar el valor de _mitexto, este método recibe un valor newTexto de tipo String
set setIdMarca( String idmarca ) {
  idMarca = idmarca; 
  notifyListeners(); //notificamos a los widgets que esten escuchando el stream.
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



