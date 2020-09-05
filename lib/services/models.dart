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



class ProductoNegocio extends Producto {

    // valores del producto
    String id="";
    bool verificado = false; // estado de verificación  al un moderador
    String id_marca=""; // ID de la marca por defecto esta vacia
    String urlimagen="default";  // URL imagen
    String titulo="";  // Titulo
    String descripcion=""; // Informacion
    String codigo="";
    String categoria = ""; // ID de la categoria del producto
    String subcategoria = ""; // ID de la subcategoria del producto
    Timestamp timestamp_creation; // Marca de tiempo ( hora en que se creo el producto )
    Timestamp timestamp_actualizacion; // Marca de tiempo ( hora en que se edito el producto )

    // Datos de publicacion 
    String id_negocio=""; // ID del negocios
    String id_usuario=""; // ID del usuario quien creo la publicacion

    // Datos del producto
    bool producto_precargado = false;
    // Variables
    bool habilitado=true;
    double precio_venta = 0.0;
    double precio_compra = 0.0;
    double precio_comparacion = 0.0;
    bool control_stock=false;
    int cantidad_stock=0;
    int cantidad_ventas=0;
    //Map<String,int> registro_ventas; // Registro de ventas
    bool iva_aplicado = false; // Falso si el iva no se aplico al producto
    double iva=0.0;
    
    Timestamp timestamp_compra; // Marca de tiempo ( hora en que se compro el producto )
    String signo_moneda ;
    //Map<String,bool> mg=new Map();    // <ID,(true=me gusta | false=no me gusta)>
    int cantidad=1;

  ProductoNegocio(
    { 

      // Valores del producto 
      this.id, 
      this.verificado,
      this.id_marca, 
      this.urlimagen, 
      this.titulo, 
      this.descripcion, 
      this.codigo , 
      this.categoria, 
      this.subcategoria, 
      this.timestamp_creation, 
      this.timestamp_actualizacion,

      // valores de la cuenta 
      this.habilitado,
      this.precio_venta, 
      this.precio_compra, 
      this.precio_comparacion, 
      this.control_stock, 
      this.cantidad_stock, 
      this.cantidad_ventas , 
      //this.registro_ventas, 
      this.producto_precargado, 
      this.iva_aplicado,
      this.iva,
      this.timestamp_compra,
      this.signo_moneda,
      //this.mg,
      this.cantidad,
      }
  );

  factory ProductoNegocio.fromMap(Map data) {

    return ProductoNegocio(
      // Valores del producto 
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      id_marca: data['id_marca'] ?? '',
      urlimagen: data['urlimagen'] ?? 'default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestamp_actualizacion: data['timestamp_actualizacion'] ,
      timestamp_creation: data['timestamp_creation'] ?? false,
      // valores de la cuenta 
      producto_precargado: data['producto_precargado'] ?? true,
      habilitado: data['habilitado'] ?? true,
      precio_venta: data['precio_venta'] ?? 0.0,
      precio_compra: data['precio_compra'] ?? 0.0,
      precio_comparacion: data['precio_comparacion'] ?? 0.0,
      control_stock: data['control_stock'] ?? false,
      cantidad_ventas: data['cantidad_ventas'] ?? 0,
      //registro_ventas: data['registro_ventas'] ?? Map(),
      iva_aplicado: data['iva_aplicado'] ?? false,
      iva: data['iva'] ?? 0.0,
      timestamp_compra: data['timestamp_compra'] ?? null,
      signo_moneda: data['signo_moneda'] ?? '',
      //mg: data['mg'] ?? Map(),
      cantidad: data['cantidad'] ?? 0,

    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "verificado": verificado,
        "id_marca": id_marca,
        "urlimagen": urlimagen,
        "titulo": titulo,
        "descripcion": descripcion,
        "codigo": codigo,
        "categoria": categoria,
        "subcategoria": subcategoria,
        "timestamp_creation": timestamp_creation,
        "timestamp_creation": timestamp_creation,
        "producto_precargado": producto_precargado,
        "habilitado": habilitado,
        "precio_venta": precio_venta,
        "precio_compra": precio_compra,
        "precio_comparacion": precio_comparacion,
        "control_stock": control_stock,
        "cantidad_ventas": cantidad_ventas,
        "iva_aplicado": iva_aplicado,
        "iva": iva,
        "timestamp_compra": timestamp_compra,
        "signo_moneda": signo_moneda,
        "cantidad": cantidad,
        
    };

}
class Producto {
    String id="";
    bool verificado = false; // estado de verificación  al un moderador
    String id_marca=""; // ID de la marca por defecto esta vacia
    String urlimagen="default";  // URL imagen
    String titulo="";  // Titulo
    String descripcion=""; // Informacion
    String codigo="";
    String categoria = ""; // ID de la categoria del producto
    String subcategoria = ""; // ID de la subcategoria del producto
    Timestamp timestamp_creation; // Marca de tiempo ( hora en que se creo el producto )
    Timestamp timestamp_actualizacion; // Marca de tiempo ( hora en que se edito el producto )


  Producto({ 
    this.id, 
    this.verificado,
    this.id_marca, 
    this.urlimagen, 
    this.titulo, 
    this.descripcion, 
    this.codigo , 
    this.categoria, 
    this.subcategoria, 
    this.timestamp_creation, 
    this.timestamp_actualizacion, 
    });

  factory Producto.fromMap(Map data) {
    return Producto(
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      id_marca: data['id_marca'] ?? '',
      urlimagen: data['urlimagen'] ?? 'default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestamp_actualizacion: data['timestamp_actualizacion'] ,
      timestamp_creation: data['timestamp_creation'] ?? false,
    );
  }
  ProductoNegocio convertProductoNegocio(){
    ProductoNegocio productoNegocio=new ProductoNegocio();
    return productoNegocio;
  }

}


