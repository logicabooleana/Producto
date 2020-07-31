import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilNegocio {
  
  // Informacion del negocios
    String id="";
    String username="";
    String imagen_perfil="default";
    String nombre_negocio="";
    String telefono="";
    String categoria="";
    String categoria_nombre="";
    String sitio_web="";
    String descripcion="";
    Timestamp timestamp_creation; // Fecha en la que se creo la cuenta
    Timestamp timestamp_login; // Fecha de las ultima ves que inicio la app
    String signo_moneda ="\$" ;

    // Configuracion
    bool cuenta_privada=false;
    bool horario=true;

    // informacion de cuenta
    bool bloqueo=false;
    String  mensaje_bloqueo="";
    bool cuenta_activa = true;  // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    bool cuenta_verificada=false; // Cuenta verificada

    // Ubicacion
    bool geolocation =false; // true si la geolocalizacion del negocios esta activada
    String codigo_pais="";
    String pais="";
    String provincia="";
    String ciudad="";
    String direccion="";
    GeoPoint geopoint;
    String codigo_postal="";

  PerfilNegocio.fromMap(Map data) {
    id = data['id'];
    username = data['username']??"";
    imagen_perfil = data['imagen_perfil'] ?? 'default';
    nombre_negocio = data['nombre_negocio'];
    telefono = data['telefono'];
    categoria = data['categoria'];
    categoria_nombre = data['categoria_nombre'];
    sitio_web = data['sitio_web'];
    descripcion = data['descripcion'];
    timestamp_creation = data['timestamp_creation'];
    timestamp_login = data['timestamp_login'];
    signo_moneda = data['signo_moneda']??"\$";
    cuenta_privada = data['cuenta_privada'];
    horario = data['horario'];
    bloqueo = data['bloqueo'];
    mensaje_bloqueo = data['mensaje_bloqueo'];
    cuenta_activa = data['cuenta_activa'];
    cuenta_verificada = data['cuenta_verificada'];
    geolocation = data['geolocation'];
    codigo_pais = data['codigo_pais'];
    pais = data['pais'];
    provincia = data['provincia'];
    ciudad = data['ciudad'];
    geopoint = data['geopoint'];
    codigo_postal = data['codigo_postal'];
  }
}

class AdminUsuarioCuenta {

  String id_usuario="";
  bool estado_cuenta_usuario = true;
  int tipo_usuario=0;
  int tipocuenta=0; // 0 = null | 1 = administrador  | 2 = etandar
  bool propietario_cuenta=false;// True el usuario fue quien creo la cuenta del negocios


  AdminUsuarioCuenta.fromMap(Map data) {
    id_usuario= data['id_usuario'] ??"";
    estado_cuenta_usuario= data['estado_cuenta_usuario'] ?? '';
    tipo_usuario= data['tipo_usuario'] ?? '';
    tipocuenta= data['tipocuenta'] ?? '';
    propietario_cuenta= data['propietario_cuenta'] ?? '';
  }

}

class Seguidor {
    String id_usuario=""; 
    bool local=false;

  Seguidor.fromMap(Map data) {
    id_usuario= data['id_usuario'] ??"";
    local= data['local'] ?? false;
  }

}