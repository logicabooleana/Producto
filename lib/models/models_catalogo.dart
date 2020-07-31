import 'package:cloud_firestore/cloud_firestore.dart';


class Categoria {
    String id="";
    String nombre="";
    String url_imagen="default";  // URL imagen

  Categoria({ 
    this.id, 
    this.nombre, 
    this.url_imagen, 
    });

  factory Categoria.fromMap(Map data) {
    return Categoria(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      url_imagen: data['url_imagen'] ?? '',
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

  Marca.fromMap(Map data) {
    id= data['id'] ?? '';
      titulo= data['titulo'] ?? '';
      descripcion= data['descripcion'] ?? '';
      url_imagen= data['url_imagen'] ?? '';
      codigo_empresa= data['codigo_empresa'] ?? '';
      timestamp_seleccion= data['timestamp_seleccion'] ;
      id_usuario_creador= data['id_usuario_creador'] ?? '';
      timestamp_creacion= data['timestamp_creacion'];
      id_usuario_actualizado= data['id_usuario_actualizado'] ?? '';
      timestamp_actualizado= data['timestamp_actualizado'];
  }

}
