import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './globals.dart';



class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  DocumentReference ref;

  Document({ this.path }) {
    ref = _db.document(path);
  }


  // Models Perfil User Admin Negocio
  Future<T> getDataAdminUsuarioCuenta() {
    return ref.get().then((v) => Global.modelsAdminUsuarioCuenta[T](v.data) as T);
  }
  Stream<T> streamDataAdminUsuarioCuenta() {
    return ref.snapshots().map((v) => Global.modelsAdminUsuarioCuenta[T](v.data) as T);
  }
  Future<void> upSetAdminUsuarioCuenta(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }
  // Models Seguidor Reference
  Future<T> getDataSeguidorRef() {
    return ref.get().then((v) => Global.modelsSeguidor[T](v.data) as T);
  }
  Stream<T> streamDataSeguidorRef() {
    return ref.snapshots().map((v) => Global.modelsSeguidor[T](v.data) as T);
  }
  Future<void> upSetDataSeguidorRef(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  // Models Perfil Negocio
  Future<T> getDataPerfilNegocio() {
    return ref.get().then((v) => Global.modelsPerfilNegocio[T](v.data) as T);
  }
  Stream<T> streamDataPerfilNegocio() {
    return ref.snapshots().map((v) => Global.modelsPerfilNegocio[T](v.data) as T);
  }
  Future<void> upSetPerfilNegocio(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  // Models Precio Producto
  Future<T> getDataPrecioProducto() {
    return ref.get().then((v) => Global.modelsPrecioProducto[T](v.data) as T);
  }
  Stream<T> streamDataPrecioProducto() {
    return ref.snapshots().map((v) => Global.modelsPrecioProducto[T](v.data) as T);
  }
  Future<void> upSetPrecioProducto(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  // Models Producto
  Future<T> getDataProducto() {
    return ref.get().then((v) => Global.modelsProducto[T](v.data) as T);
  }
  Stream<T> streamDataProducto() {
    return ref.snapshots().map((v) => Global.modelsProducto[T](v.data) as T);
  }
  Future<void> upSetProducto(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

  // Models Marca DEL PRODUCTO
  Future<T> getDataMarca() {
    return ref.get().then((v) => Global.modelsMarca[T](v.data) as T);
  }
  Stream<T> streamDataMarca() {
    return ref.snapshots().map((v) => Global.modelsMarca[T](v.data) as T);
  }
  Future<void> upSetMarca(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }

}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path; 
  CollectionReference ref;

  Collection({ this.path }) {
    ref = _db.collection(path);
  }

  // Model Precios producto
  Future<List<T>> getDataPreciosProductosAll() async {
    var snapshots = await ref.orderBy("timestamp",descending: true).getDocuments();
    return snapshots.documents.map((doc) => Global.modelsPrecioProducto[T](doc.data) as T ).toList();
  }
  Stream<List<T>> streamDataPreciosProductosAlll() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.modelsPrecioProducto[T](doc.data) as T) );
  }

  // Model Perfil Negocio
  Future<List<T>> getDataAdminPerfilNegocioAll() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) => Global.modelsPerfilNegocio[T](doc.data) as T ).toList();
  }
  Stream<List<T>> streamDataAdminPerfilNegocioAll() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.modelsPerfilNegocio[T](doc.data) as T) );
  }
  // Model Seguidor Reference
  Future<List<T>> getListSeguidoresAll() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) => Global.modelsSeguidor[T](doc.data) as T ).toList();
  }
  Stream<List<T>> streamListSeguidoresAll() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.modelsSeguidor[T](doc.data) as T) );
  }
  // Model Producto
  Future<List<T>> getDataProductoAll() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) => Global.modelsProducto[T](doc.data) as T ).toList();
  }
  Stream<List<T>> streamDataProductoAll() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.modelsProducto[T](doc.data) as T).toList() );
  }

  // Model Categoria
  Future<List<T>> getDataCategoriaAll() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents.map((doc) {
      var map = new Map();
      map=doc.data;
      // valor de id del documento  por si es nulo
      map["id"]=doc.documentID;
      return Global.modelsCategoria[T](map) as T;
      } ).toList();
  }
  Stream<List<T>> streamDataCategoriaAll() {
    return ref.snapshots().map((list) => list.documents.map((doc) => Global.modelsCategoria[T](doc.data) as T) );
  }
}


// TODO: Verificar usabilidad
class UserData<T> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({ this.collection });


  Stream<T> get documentStream {

    return _auth.onAuthStateChanged.switchMap((user) {
      if (user != null) {
          Document<T> doc = Document<T>(path: '$collection/${user.uid}'); 
          return doc.streamDataProducto();
      } else {
          return Stream<T>.value(null);
      }
    });
  }

  Future<T> getDocument() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Document doc = Document<T>(path: '$collection/${user.uid}'); 
      return doc.getDataProducto();
    } else {
      return null;
    }

  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Document<T> ref = Document(path:  '$collection/${user.uid}');
    return ref.upSetProducto(data);
  }

}
