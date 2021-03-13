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
  class Usuario {

    // informacion perfil
    String id="";
    String nombre="";
    String apellido="";
    String urlfotoPerfil="default";
    Timestamp timestamp_creation; // Fecha de creacion
    Timestamp timestamp_sesion; // Fecha de la ultima hora que inicio sesin a la app
    String email="";

    /*
   Referencia a la cuenta de negocios del usuario
   si es null el usuario no tiene una cuenta
    */
    String id_cuenta_negocio="";

  Usuario({ this.id, this.nombre, this.apellido,this.urlfotoPerfil, this.timestamp_creation, this.timestamp_sesion , this.email , this.id_cuenta_negocio });
  Usuario.fromMap(Map data) {
    id = data['id']?? "";
    nombre = data['nombre'] ?? "";
    apellido = data['apellido']??"";
    urlfotoPerfil = data['urlfotoPerfil']?? "";
    timestamp_creation = data['timestamp_creation'];
    timestamp_sesion = data['timestamp_sesion'];
    email = data['email']?? "";
  }
  
  Map<String, dynamic> toJson() => {
        "id": id??"",
        "nombre": nombre??true,
        "apellido": apellido??"",
        "urlfotoPerfil": urlfotoPerfil??"",
        "timestamp_creation": timestamp_creation,
        "timestamp_sesion": timestamp_sesion,
        "email": email??"",
    };

  }
class AsuarioAdministrador {
  String id_usuario="";
  bool habilitado=true;
  int tipocuenta=0 ;// 0 = administrador | 1 = etandar  

  AsuarioAdministrador({ this.id_usuario, this.habilitado, this.tipocuenta });
  AsuarioAdministrador.fromMap(Map data) {
    id_usuario = data['id_usuario']?? "";
    habilitado = data['habilitado'] ?? true;
    tipocuenta = data['tipocuenta']?? 0;
  }
  
  Map<String, dynamic> toJson() => {
        "id_usuario": id_usuario??"",
        "habilitado": habilitado??true,
        "tipocuenta": tipocuenta??"",
    };
}


class ProductoNegocio  {

    // valores del producto
    String id="";
    bool verificado = false; // estado de verificación  al un moderador
    bool favorite = false; 
    String id_marca=""; // ID de la marca por defecto esta vacia
    String urlimagen="https://default";  // URL imagen
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
      this.id="", 
      this.verificado=false,
      this.favorite=false,
      this.id_marca="", 
      this.urlimagen="", 
      this.titulo="", 
      this.descripcion="", 
      this.codigo="", 
      this.categoria="", 
      this.subcategoria="", 
      this.timestamp_creation, 
      this.timestamp_actualizacion,

      // valores de la cuenta 
      this.habilitado=false,
      this.precio_venta=0.0, 
      this.precio_compra=0.0, 
      this.precio_comparacion=0.0, 
      this.control_stock=false, 
      this.cantidad_stock=0, 
      this.cantidad_ventas=0, 
      //this.registro_ventas, 
      this.producto_precargado=false, 
      this.iva_aplicado=false,
      this.iva=0.0,
      this.timestamp_compra,
      this.signo_moneda="",
      //this.mg,
      this.cantidad,
      }
  );

  factory ProductoNegocio.fromMap(Map data) {

    return ProductoNegocio(
      // Valores del producto 
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      id_marca: data['id_marca'] ?? '',
      urlimagen: data['urlimagen'] ?? 'https://default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestamp_actualizacion: data['timestamp_actualizacion'] ,
      timestamp_creation: data['timestamp_creation'] ,
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
        "id": id??"",
        "verificado": verificado??false,
        "favorite": verificado??false,
        "id_marca": id_marca??"",
        "urlimagen": urlimagen??"https://default",
        "titulo": titulo??"",
        "descripcion": descripcion??"",
        "codigo": codigo??"",
        "categoria": categoria??"",
        "subcategoria": subcategoria??"",
        "producto_precargado": producto_precargado,
        "habilitado": habilitado,
        "precio_venta": precio_venta??0.0,
        "precio_compra": precio_compra??0.0,
        "precio_comparacion": precio_comparacion??0.0,
        "control_stock": control_stock,
        "cantidad_ventas": cantidad_ventas,
        "iva_aplicado": iva_aplicado,
        "iva": iva,
        "timestamp_compra": timestamp_compra,
        "timestamp_creation": timestamp_creation,
        "timestamp_actualizacion": timestamp_actualizacion,
        "signo_moneda": signo_moneda,
        "cantidad": cantidad,
        
    };

    Producto convertProductoDefault(){
    Producto productoDefault=new Producto();
    productoDefault.id=this.id??"";
    productoDefault.urlimagen=this.urlimagen??"";
    productoDefault.verificado=this.verificado??false;
    productoDefault.favorite=this.favorite??false;
    productoDefault.id_marca=this.id_marca??"";
    productoDefault.titulo=this.titulo??"";
    productoDefault.descripcion=this.descripcion??"";
    productoDefault.codigo=this.codigo??"";
    productoDefault.timestamp_actualizacion=this.timestamp_actualizacion;
    productoDefault.timestamp_creation=this.timestamp_creation;

    return productoDefault;
  }

}
class Producto {
    String id="";
    bool verificado = false; // estado de verificación  al un moderador
    bool favorite=false;
    String id_marca=""; // ID de la marca por defecto esta vacia
    String id_negocio=""; // ID del negocios que actualizo el producto
    String urlimagen="https://default";  // URL imagen
    String titulo="";  // Titulo
    String descripcion=""; // Informacion
    String codigo="";
    String categoria = ""; // ID de la categoria del producto
    String subcategoria = ""; // ID de la subcategoria del producto
    Timestamp timestamp_creation; // Marca de tiempo ( hora en que se creo el producto )
    Timestamp timestamp_actualizacion; // Marca de tiempo ( hora en que se edito el producto )


  Producto({ 
    this.id="", 
    this.verificado=false,
    this.favorite=false,
    this.id_marca="", 
    this.id_negocio="", 
    this.urlimagen="", 
    this.titulo="", 
    this.descripcion="", 
    this.codigo="", 
    this.categoria="", 
    this.subcategoria="", 
    this.timestamp_creation, 
    this.timestamp_actualizacion,
    });

      Map<String, dynamic> toJson() => {
        "id": id??"",
        "verificado": verificado??false,
        "favorite": verificado??false,
        "id_marca": id_marca??"",
        "id_negocio": id_negocio??"",
        "urlimagen": urlimagen??"https://default",
        "titulo": titulo??"",
        "descripcion": descripcion??"",
        "codigo": codigo??"",
        "categoria": categoria??"",
        "subcategoria": subcategoria??"",
    };

  factory Producto.fromMap(Map data) {
    return Producto(
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      id_marca: data['id_marca'] ?? '',
      id_negocio: data['id_negocio'] ?? '',
      urlimagen: data['urlimagen'] ?? 'https://default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestamp_actualizacion: data['timestamp_actualizacion'] ,
      timestamp_creation: data['timestamp_creation'] ,
    );
  }
  ProductoNegocio convertProductoNegocio(){
    ProductoNegocio productoNegocio=new ProductoNegocio();
    productoNegocio.id=this.id??"";
    productoNegocio.urlimagen=this.urlimagen??"";
     productoNegocio.id_negocio=this.id_negocio??"";
    productoNegocio.verificado=this.verificado??false;
    productoNegocio.favorite=this.favorite??false;
    productoNegocio.id_marca=this.id_marca??"";
    productoNegocio.titulo=this.titulo??"";
    productoNegocio.descripcion=this.descripcion??"";
    productoNegocio.codigo=this.codigo??"";
    productoNegocio.categoria=this.categoria??"";
    productoNegocio.subcategoria=this.subcategoria??"";
    productoNegocio.timestamp_actualizacion=this.timestamp_actualizacion;
    productoNegocio.timestamp_creation=this.timestamp_creation;

    return productoNegocio;
  }

}


