import 'package:cloud_firestore/cloud_firestore.dart';


class Option {
  String value;
  String detail;
  bool correct;

  Option({ this.correct, this.value, this.detail });
  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}



class ProductoNegocio {
    // Datos de publicacion
    String id="";  // ID del producto
    String id_usuario="";   // ID del usuario quien creo la publicacion
    String id_negocio="";  // ID del negocios

    // Datos del producto
    String urlimagen="default";  // URL imagen
    String categoria="";  // ID categoria
    String subcategoria=""; // ID Subcategoria
    String titulo="";  // Titulo
    String descripcion=""; // Informacion
    bool producto_precargado = false;
    String id_marca=""; // ID de la marca por defecto esta vacia

    // Variables
    bool habilitado=true;
    double precio_venta = 0.0;
    double precio_compra = 0.0;
    double precio_comparacion = 0.0;
    bool control_stock=false;
    int cantidad_stock=0;
    int cantidad_ventas=0;
    //Map<String,int> registro_ventas; // Registro de ventas
    String codigo = ""; // codigo de barra
    bool iva_aplicado = false; // Falso si el iva no se aplico al producto
    double iva=0.0;

    Timestamp timestamp_creation; // Marca de tiempo ( hora en que se creo el producto )
    Timestamp timestamp_compra; // Marca de tiempo ( hora en que se compro el producto )
    Timestamp timestamp_actualizacion; // Marca de tiempo ( hora en que se edito el producto )
    String signo_moneda ;
    //Map<String,bool> mg=new Map();    // <ID,(true=me gusta | false=no me gusta)>
    int cantidad=1;

  ProductoNegocio(
    { 
      this.id, 
      this.id_usuario, 
      this.id_negocio, 
      this.urlimagen, 
      this.categoria, 
      this.subcategoria , 
      this.titulo, 
      this.descripcion, 
      this.id_marca,
      this.habilitado,
      this.precio_venta, 
      this.precio_compra, 
      this.precio_comparacion, 
      this.control_stock, 
      this.cantidad_stock, 
      this.cantidad_ventas , 
      //this.registro_ventas, 
      this.codigo, 
      this.producto_precargado, 
      this.iva_aplicado,
      this.iva,
      this.timestamp_creation,
      this.timestamp_compra,
      this.timestamp_actualizacion,
      this.signo_moneda,
      //this.mg,
      this.cantidad,
      }
  );

  factory ProductoNegocio.fromMap(Map data) {

    return ProductoNegocio(
      id: data['id'] ?? '',
      id_usuario: data['id_usuario'] ?? '',
      id_negocio: data['id_negocio'] ?? '',
      id_marca: data['id_marca'] ?? '',
      urlimagen: data['urlimagen'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      producto_precargado: data['producto_precargado'] ?? true,
      habilitado: data['habilitado'] ?? true,
      precio_venta: data['precio_venta'] ?? 0.0,
      precio_compra: data['precio_compra'] ?? 0.0,
      precio_comparacion: data['precio_comparacion'] ?? 0.0,
      control_stock: data['control_stock'] ?? false,
      cantidad_ventas: data['cantidad_ventas'] ?? 0,
      //registro_ventas: data['registro_ventas'] ?? Map(),
      codigo: data['codigo'] ?? '',
      iva_aplicado: data['iva_aplicado'] ?? false,
      iva: data['iva'] ?? 0.0,
      timestamp_creation: data['timestamp_creation'] ?? null,
      timestamp_compra: data['timestamp_compra'] ?? null,
      timestamp_actualizacion: data['timestamp_actualizacion'] ?? null,
      signo_moneda: data['signo_moneda'] ?? '',
      //mg: data['mg'] ?? Map(),
      cantidad: data['cantidad'] ?? 0,

    );
  }

}
class Producto {
    String id="";
    String id_marca=""; // ID de la marca por defecto esta vacia
    String urlimagen="default";  // URL imagen
    String titulo="";  // Titulo
    String descripcion=""; // Informacion
    String codigo="";
    String categoria = ""; // ID de la categoria del producto
    String subcategoria = ""; // ID de la subcategoria del producto
    Timestamp timestamp_actualizacion; // Marca de tiempo de actualizacion del precio del producto
    int tipo=0;

    // Values registros
    String signo_moneda;
    double precio_venta;
    int cantidad_ventas=0;

  Producto({ 
    this.id, 
    this.id_marca, 
    this.urlimagen, 
    this.titulo, 
    this.descripcion, 
    this.codigo , 
    this.categoria, 
    this.subcategoria, 
    this.timestamp_actualizacion, 
    this.cantidad_ventas,
    this.tipo,
    this.precio_venta,
    this.signo_moneda,
    });

  factory Producto.fromMap(Map data) {
    return Producto(
      id: data['id'] ?? '',
      id_marca: data['id_marca'] ?? '',
      urlimagen: data['urlimagen'] ?? '',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestamp_actualizacion: data['timestamp_actualizacion'] ,
      tipo: data['tipo'] ?? 0,
      precio_venta: data['precio_venta'] ?? 0.0,
      signo_moneda: data['signo_moneda'] ?? '',
    );
  }

}


