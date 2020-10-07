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

  PerfilNegocio({
    // Informacion del negocios
    this.id="",
    this.username="",
    this.imagen_perfil="default",
    this.nombre_negocio="",
    this.telefono="",
    this.categoria="",
    this.categoria_nombre="",
    this.sitio_web="",
    this.descripcion="",
    this.timestamp_creation, // Fecha en la que se creo la cuenta
    this.timestamp_login, // Fecha de las ultima ves que inicio la app
    this.signo_moneda ="\$" ,

    // Configuracion
    this.cuenta_privada=false,
    this.horario=true,

    // informacion de cuenta
    this.bloqueo=false,
    this.mensaje_bloqueo="",
    this.cuenta_activa = true, // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    this.cuenta_verificada=false, // Cuenta verificada

    // Ubicacion
    this.geolocation =false, // true si la geolocalizacion del negocios esta activada
    this.codigo_pais="",
    this.pais="",
    this.provincia="",
    this.ciudad="",
    this.direccion="",
    this.geopoint,
    this.codigo_postal="",
    });
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
    direccion = data['direccion'];
    ciudad = data['ciudad'];
    provincia = data['provincia'];
    pais = data['pais'];
    geopoint = data['geopoint'];
    codigo_postal = data['codigo_postal'];
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "imagen_perfil": imagen_perfil,
        "nombre_negocio": nombre_negocio,
        "telefono": telefono,
        "categoria": categoria,
        "categoria_nombre": categoria_nombre,
        "sitio_web": sitio_web,
        "descripcion": descripcion,
        "timestamp_creation": timestamp_creation,
        "timestamp_login": timestamp_login,
        "signo_moneda": signo_moneda,
        "cuenta_privada": cuenta_privada,
        "horario": horario,
        "bloqueo": bloqueo,
        "mensaje_bloqueo": mensaje_bloqueo,
        "cuenta_activa": cuenta_activa,
        "cuenta_verificada": cuenta_verificada,
        "geolocation": geolocation,
        "codigo_pais": codigo_pais,
        "pais": pais,
        "provincia": provincia,
        "ciudad": ciudad,
        "geopoint": geopoint,
        "codigo_postal": codigo_postal,
        
    };
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