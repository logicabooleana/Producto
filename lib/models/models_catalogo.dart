import 'package:cloud_firestore/cloud_firestore.dart';

class Precio{

  String id_negocio="";
  double precio=0.0;
  Timestamp timestamp;
  String moneda="";

   Precio({ 
    this.id_negocio="", 
    this.precio=0.0, 
    this.timestamp, 
    this.moneda, 
    });

  Precio.fromMap(Map data) {
    id_negocio = data['id_negocio'] ?? '';
    precio = data['precio'] ?? 0.0;
    timestamp = data['timestamp'];
    moneda = data['moneda'] ?? '';
  }
  Map<String, dynamic> toJson() => {
        "id_negocio": id_negocio,
        "precio": precio,
        "timestamp": timestamp,
        "moneda": moneda,
        
    };
}

class Categoria {
    String id="";
    String nombre="";

  Categoria({ 
    this.id="", 
    this.nombre="",
    });
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };

  factory Categoria.fromMap(Map data) {
    return Categoria(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
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
