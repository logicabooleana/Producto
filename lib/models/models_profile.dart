import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilNegocio {
  
  // Informacion del negocios
    String id="";
    String imagen_perfil="";
    String nombre_negocio="";
    String descripcion="";
    Timestamp timestamp_creation; // Fecha en la que se creo la cuenta
    Timestamp timestamp_login; // Fecha de las ultima ves que inicio la app
    String signo_moneda ="\$" ;


    // informacion de cuenta
    bool bloqueo=false;
    String  mensaje_bloqueo="";
    bool cuenta_activa = true;  // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    bool cuenta_verificada=false; // Cuenta verificada

    // Ubicacion
    String codigo_pais="";
    String pais="";
    String provincia="";
    String ciudad="";
    String direccion="";
   

  PerfilNegocio({
    // Informacion del negocios
    this.id="",
    this.imagen_perfil="",
    this.nombre_negocio="",
    this.descripcion="",
    this.timestamp_creation, // Fecha en la que se creo la cuenta
    this.timestamp_login, // Fecha de las ultima ves que inicio la app
    this.signo_moneda ="\$" ,
    // informacion de cuenta
    this.bloqueo=false,
    this.mensaje_bloqueo="",
    this.cuenta_activa = true, // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    this.cuenta_verificada=false, // Cuenta verificada

    // Ubicacion
    this.codigo_pais="",
    this.pais="",
    this.provincia="",
    this.ciudad="",
    this.direccion="",
    });
  PerfilNegocio.fromMap(Map data) {
    id = data['id'];
    imagen_perfil = data['imagen_perfil'] ?? '';
    nombre_negocio = data['nombre_negocio'];
    descripcion = data['descripcion'];
    timestamp_creation = data['timestamp_creation'];
    timestamp_login = data['timestamp_login'];
    signo_moneda = data['signo_moneda']??"\$";
    bloqueo = data['bloqueo'];
    mensaje_bloqueo = data['mensaje_bloqueo'];
    cuenta_activa = data['cuenta_activa'];
    cuenta_verificada = data['cuenta_verificada'];
    codigo_pais = data['codigo_pais'];
    direccion = data['direccion'];
    ciudad = data['ciudad'];
    provincia = data['provincia'];
    pais = data['pais'];
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "imagen_perfil": imagen_perfil,
        "nombre_negocio": nombre_negocio,
        "descripcion": descripcion,
        "timestamp_creation": timestamp_creation,
        "timestamp_login": timestamp_login,
        "signo_moneda": signo_moneda,
        "bloqueo": bloqueo,
        "mensaje_bloqueo": mensaje_bloqueo,
        "cuenta_activa": cuenta_activa,
        "cuenta_verificada": cuenta_verificada,
        "codigo_pais": codigo_pais,
        "pais": pais,
        "provincia": provincia,
        "ciudad": ciudad,
        
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