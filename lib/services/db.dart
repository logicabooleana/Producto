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
    return ref.get().then((v) => Global.modelsProductoGlobal[T](v.data()) as T);
  }
  Stream<T> streamDataProducto() {
    return ref.snapshots().map((v) => Global.modelsProducto[T](v.data()) as T);
  }
  Future<void> upSetProducto(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }

  // Models Marca DEL PRODUCTO
  Future<T> getDataMarca() {
    return ref.get().then((v) => Global.modelsMarca[T](v.data()) as T);
  }
  Stream<T> streamDataMarca() {
    return ref.snapshots().map((v) => Global.modelsMarca[T](v.data()) as T);
  }
  Future<void> upSetMarca(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
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
  Future<List<T>> getDataProductoAll() async {
    var snapshots = await ref.get();
    return snapshots.docs.map((doc) => Global.modelsProducto[T](doc.data()) as T ).toList();
  }
  Stream<List<T>> streamDataProductoAll() {
    return ref.snapshots().map( (list) => list.docs.map((doc) => Global.modelsProducto[T](doc.data()) as T).toList() );
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


