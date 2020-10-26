import 'package:cloud_firestore/cloud_firestore.dart';

class Precio{

  String id_negocio="";
  double precio=0.0;
  Timestamp timestamp;
  String moneda="";
  String provincia="";
   String ciudad="";

   Precio({ 
    this.id_negocio="", 
    this.precio=0.0, 
    this.timestamp, 
    this.moneda, 
    this.provincia, 
    this.ciudad, 
    });

  Precio.fromMap(Map data) {
    id_negocio = data['id_negocio'] ?? '';
    precio = data['precio'] ?? 0.0;
    timestamp = data['timestamp'];
    moneda = data['moneda'] ?? '';
    provincia = data['provincia'] ?? '';
    ciudad = data['ciudad'] ?? '';
  }
  Map<String, dynamic> toJson() => {
        "id_negocio": id_negocio,
        "precio": precio,
        "timestamp": timestamp,
        "moneda": moneda,
        "provincia": provincia,
        "ciudad": ciudad,
        
    };
}

class Categoria {
    String id="";
    String nombre="";
    Map<String, dynamic> subcategorias = Map<String, dynamic>();

  Categoria({
    this.id="", 
    this.nombre="",
    this.subcategorias,
    });
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "subcategorias": subcategorias ?? new Map<String, dynamic>(),
  };
  factory Categoria.fromMap(Map data) {
    return Categoria(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      subcategorias: data['subcategorias'] ?? new Map<String, dynamic>(),
    );
  }
}

class Marca {
    
    String id = "";
    String titulo = "";
    String descripcion = "";
    String url_imagen = "";
    String codigo_empresa = "";
    Timestamp timestamp_seleccion ; // Marca de tiempo de la seleccion

    // Datos de la creación
    String id_usuario_creador=""; // ID el usuaruio que creo el productos
    Timestamp timestamp_creacion; // Marca de tiempo de la creacion del documento
    String id_usuario_actualizado =""; // ID el usuaruio que actualizo el productos
    Timestamp timestamp_actualizado; // Marca de tiempo de la ultima actualizacion
  Marca({
    this.id="",
    this.titulo="",
    this.descripcion="",
    this.url_imagen="",
    this.codigo_empresa="",
    this.timestamp_seleccion,
  });
  Marca.fromMap(Map data) {
    id= data['id'] ?? '';
      titulo= data['titulo'] ?? '';
      descripcion= data['descripcion'] ?? '';
      url_imagen= data['url_imagen'] ?? 'default';
      codigo_empresa= data['codigo_empresa'] ?? '';
      timestamp_seleccion= data['timestamp_seleccion'] ;
      id_usuario_creador= data['id_usuario_creador'] ?? '';
      timestamp_creacion= data['timestamp_creacion'];
      id_usuario_actualizado= data['id_usuario_actualizado'] ?? '';
      timestamp_actualizado= data['timestamp_actualizado'];
  }
 Map<String, dynamic> toJson() => {
        "id": id??"",
        "titulo": titulo??"",
        "descripcion": descripcion??"",
        "url_imagen": url_imagen??"",
        "codigo_empresa": codigo_empresa??"",
        "timestamp_seleccion": timestamp_seleccion,
        
    };

}
