import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catalogo/services/preferencias_usuario.dart';
import '../services/services.dart';
import 'package:catalogo/services/globals.dart';
import 'package:catalogo/models/models_profile.dart';

class ProfileCuenta extends StatefulWidget {
  @override
  _ProfileCuentaState createState() => _ProfileCuentaState();
}

class _ProfileCuentaState extends State<ProfileCuenta> {


  bool saveIndicador=false;
  PerfilNegocio perfilNegocio;
  TextEditingController controllerTextEdit_nombre;
  TextEditingController controllerTextEdit_descripcion;
  TextEditingController controllerTextEdit_username;
  TextEditingController controllerTextEdit_categoria_nombre;
  TextEditingController controllerTextEdit_telefono;
  TextEditingController controllerTextEdit_direccion;
  TextEditingController controllerTextEdit_sitio_web;
  TextEditingController controllerTextEdit_pais;
  TextEditingController controllerTextEdit_provincia;

  @override
  void initState() {
    super.initState();
    perfilNegocio=Global.oPerfilNegocio;
    controllerTextEdit_nombre=TextEditingController(text: Global.oPerfilNegocio.nombre_negocio);
    controllerTextEdit_descripcion=TextEditingController(text: Global.oPerfilNegocio.descripcion);
    controllerTextEdit_username=TextEditingController(text: Global.oPerfilNegocio.username);
    controllerTextEdit_categoria_nombre=TextEditingController(text: Global.oPerfilNegocio.categoria_nombre);
    controllerTextEdit_telefono=TextEditingController(text: Global.oPerfilNegocio.telefono);
    controllerTextEdit_sitio_web=TextEditingController(text: Global.oPerfilNegocio.sitio_web);
    controllerTextEdit_pais=TextEditingController(text: Global.oPerfilNegocio.pais);
    controllerTextEdit_provincia=TextEditingController(text: Global.oPerfilNegocio.provincia);
    controllerTextEdit_direccion=TextEditingController(text: Global.oPerfilNegocio.direccion);
  }
  @override
void dispose() {
 controllerTextEdit_nombre.dispose();
 controllerTextEdit_descripcion.dispose();
 controllerTextEdit_username.dispose();
 controllerTextEdit_categoria_nombre.dispose();
 controllerTextEdit_telefono.dispose();
 controllerTextEdit_sitio_web.dispose();
 controllerTextEdit_pais.dispose();
 controllerTextEdit_provincia.dispose();
 controllerTextEdit_direccion.dispose();
 super.dispose();

}

  @override
  Widget build(BuildContext context) {
    if (Global.oPerfilNegocio.id != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Editar"),
          actions: <Widget>[
            IconButton(icon: saveIndicador==false?Icon(Icons.check):Container(width: 24.0,height: 24.0,child: CircularProgressIndicator(backgroundColor: Colors.white,),),
            onPressed: () {
              guardar();
            },)
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Column(
                children: <Widget>[
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: Global.oPerfilNegocio.imagen_perfil,
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 100.0,
                    ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 100.0,
                    ),
                  ),
                  SizedBox(height: 24.0,),
                  Text("Cambiar imagen"),
                  widgetFormEditText(),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget widgetFormEditText() {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            onChanged: (value)=>perfilNegocio.nombre_negocio=value,
            decoration: InputDecoration(
              labelText: "Nombre",
            ),
            controller: controllerTextEdit_nombre,
          ),
          TextField(
            onChanged: (value)=>perfilNegocio.descripcion=value,
            decoration: InputDecoration(
              labelText: "Descripción",
            ),
            controller: controllerTextEdit_descripcion,
          ),
          TextField(
            onChanged: (value)=>perfilNegocio.username=value,
            decoration: InputDecoration(
              labelText: "username",
            ),
            controller: controllerTextEdit_username,
          ),
          TextField(
            onChanged: (value)=>perfilNegocio.categoria_nombre=value,
            decoration: InputDecoration(
              labelText: "Categoria",
            ),
            controller: controllerTextEdit_categoria_nombre,
          ),
          TextField(
            onChanged: (value)=>perfilNegocio.telefono=value,
            decoration: InputDecoration(
              labelText: "Telefono",
            ),
            controller: controllerTextEdit_telefono,
          ),
          TextField(
            onChanged: (value)=>perfilNegocio.sitio_web=value,
            decoration: InputDecoration(
              labelText: "Sitio web",
            ),
            controller: controllerTextEdit_sitio_web,
          ),
          SizedBox(height: 24.0,),
          Text("Ubicación",style: TextStyle(fontSize: 24.0)),
          TextField(
            onChanged: (value)=>perfilNegocio.direccion=value,
            decoration: InputDecoration(
              labelText: "Dirección",
            ),
            controller: controllerTextEdit_direccion,
          ),
          TextField(
            onChanged: (value)=>perfilNegocio.provincia=value,
            decoration: InputDecoration(
              labelText: "Provincia/Estado",
            ),
            controller: controllerTextEdit_provincia,
          ),
          TextField(
            onChanged:(value)=>perfilNegocio.pais=value,
            decoration: InputDecoration(
              labelText: "Pais",
            ),
            controller: controllerTextEdit_pais,
          ),
        ],
      ),
    );
  }

  void guardar()async{
    setState(() {
      saveIndicador=true;
    });

    await Global.getNegocio(idNegocio: Global.prefs.getIdNegocio).upSetPerfilNegocio(perfilNegocio.toJson());
    Navigator.pop(context);

  }
}
