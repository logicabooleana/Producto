import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import './globals.dart';



class Document<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path; 
  DocumentReference ref;

  Document({ this.path }) {
    ref = _db.doc(path);
  }

  Future<void> upSetDocument(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }


  // Models Perfil User Admin Negocio
  Future<T> getDataAdminUsuarioCuenta() {
    return ref.get().then((v) => Global.modelsAdminUsuarioCuenta[T](v.data()) as T);
  }
  Stream<T> streamDataAdminUsuarioCuenta() {
    return ref.snapshots().map((v) => Global.modelsAdminUsuarioCuenta[T](v.data()) as T);
  }
  Future<void> upSetAdminUsuarioCuenta(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }
  // Models Seguidor Reference
  Future<T> getDataSeguidorRef() {
    return ref.get().then((v) => Global.modelsSeguidor[T](v.data()) as T);
  }
  Stream<T> streamDataSeguidorRef() {
    return ref.snapshots().map((v) => Global.modelsSeguidor[T](v.data()) as T);
  }
  Future<void> upSetDataSeguidorRef(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }
  // Models Usuario Administrador
  Future<T> getDataUsuarioAdministrador() {
    return ref.get().then((v) => Global.modelsArminUsuario[T](v.data()) as T);
  }
  Stream<T> streamDataUsuarioAdministrador() {
    return ref.snapshots().map((v) => Global.modelsArminUsuario[T](v.data()) as T);
  }

  // Models Perfil Negocio
  
  Future<T> getDataPerfilNegocio() {
    return ref.get().then((v) => Global.modelsPerfilNegocio[T](v.data()) as T);
  }
  Stream<T> streamDataPerfilNegocio() {
    return ref.snapshots().map((v) => Global.modelsPerfilNegocio[T](v.data()) as T);
  }
  Future<void> upSetPerfilNegocio(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }

  // Models Precio Producto
  Future<T> getDataPrecioProducto() {
    return ref.get().then((v) => Global.modelsPrecioProducto[T](v.data()) as T);
  }
  Stream<T> streamDataPrecioProducto() {
    return ref.snapshots().map((v) => Global.modelsPrecioProducto[T](v.data()) as T);
  }
  Future<void> upSetPrecioProducto(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }

  // Models Producto
  Future<T> getDataProducto() {
    return ref.get().then((v) => Global.modelsProducto[T](v.data()) as T);
  }
  Future<T> getDataProductoGlobal() {
    return ref.get().then((v){
      if(!v.exists){ return  null; }
      return Global.modelsProductoGlobal[T](v.data()) as T;
    });
  }
  Future<T> getDataCategoria() {
    return ref.get().then((v){
      if(!v.exists){ return  null; }
      var map = new Map();
      map=v.data();
      // valor de id del documento  por si es nulo
      map["id"]=v.id;
      return Global.modelsCategoria[T](map) as T;
    });
  }
  Stream<T> streamDataProducto() {
    return ref.snapshots().map((v) => Global.modelsProducto[T](v.data()) as T);
  }
  Future<void> upSetProducto(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }

  // Models Marca DEL PRODUCTO
  Future<T> getDataMarca() {
    return ref.get().then((v){
      if(!v.exists){return null;}
      return Global.modelsMarca[T](v.data()) as T;
    });
  }
  Stream<T> streamDataMarca() {
    return ref.snapshots().map((v) => Global.modelsMarca[T](v.data()) as T);
  }
  Future<void> upSetMarca(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }
  Future<void> upSetCategoria(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }

  // DELETE
  Future<void> deleteDoc() {
    return ref.delete();
  }

}

class Collection<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String path; 
  CollectionReference ref;

  Collection({ this.path }) {
    ref = _firestore.collection(path);
  }

  // Model Precios producto
  Future<List<T>> getDataPreciosProductosAll() async {
    var snapshots = await ref.orderBy("timestamp",descending: true).get();
    return snapshots.docs.map((doc) => Global.modelsPrecioProducto[T](doc.data()) as T ).toList();
  }
  Stream<List<T>> streamDataPreciosProductosAlll() {
    return ref.snapshots().map((list) => list.docs.map((doc) => Global.modelsPrecioProducto[T](doc.data()) as T) );
  }

  // Model Perfil Negocio
  Future<List<T>> getDataAdminPerfilNegocioAll() async {
    var snapshots = await ref.get();
    return snapshots.docs.map((doc) => Global.modelsPerfilNegocio[T](doc.data()) as T ).toList();
  }
  Stream<List<T>> streamDataAdminPerfilNegocioAll() {
    return ref.snapshots().map((list) => list.docs.map((doc) => Global.modelsPerfilNegocio[T](doc.data()) as T) );
  }
  // Model Seguidor Reference
  Future<List<T>> getListSeguidoresAll() async {
    var snapshots = await ref.get();
    return snapshots.docs.map((doc) => Global.modelsSeguidor[T](doc.data()) as T ).toList();
  }
  Stream<List<T>> streamListSeguidoresAll() {
    return ref.snapshots().map((list) => list.docs.map((doc) => Global.modelsSeguidor[T](doc.data()) as T) );
  }
  // Model Producto
  Future<List<T>> getDataProductoAll({bool favorite=false,String idMarca="",int limit=0}) async {
    if (favorite){
      var snapshots = limit==0 ? await ref.orderBy("favorite").get() : await ref.orderBy("favorite").limit(limit).get();
      return snapshots.docs.map((doc) => Global.modelsProductoGlobal[T](doc.data()) as T ).toList();
    }if (idMarca != ""){
      var snapshots = limit==0?await ref.where("id_marca", isEqualTo: idMarca).get():await ref.where("id_marca", isEqualTo: idMarca).limit(limit).get();
      return snapshots.docs.map((doc) => Global.modelsProductoGlobal[T](doc.data()) as T ).toList();
    }else {
      var snapshots = await ref.orderBy("timestamp_actualizacion").limit(limit).get();
      return snapshots.docs.map((doc) => Global.modelsProductoGlobal[T](doc.data()) as T ).toList();
    }
    
  }
  Stream<List<T>> streamDataProductoAll() {
    return ref.orderBy('timestamp_actualizacion', descending: true).snapshots().map( (list) => list.docs.map((doc) => Global.modelsProducto[T](doc.data()) as T).toList() );
  }

  // Model MARCA
  Future<List<T>> getDataMarca() async {
    var snapshots = await ref.get();
    return snapshots.docs.map((doc) => Global.modelsMarca[T](doc.data()) as T ).toList();
  }
  

  // Model Categoria
  Future<List<T>> getDataCategoriaAll() async {
    var snapshots = await ref.get();
    return snapshots.docs.map((doc) {
      var map = new Map();
      map=doc.data();
      // valor de id del documento  por si es nulo
      map["id"]=doc.id;
      return Global.modelsCategoria[T](map) as T;
      } ).toList();
  }
  Stream<List<T>> streamDataCategoriaAll() {
    return ref.snapshots().map((list) => list.docs.map((doc) => Global.modelsCategoria[T](doc.data()) as T) );
  }
}


