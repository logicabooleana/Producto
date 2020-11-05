import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../services/services.dart';
import 'package:producto/services/globals.dart';
import 'package:producto/models/models_profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:producto/screens/widgets/widgets_notify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:producto/shared/progress_bar.dart';

class ProfileCuenta extends StatefulWidget {
  PerfilNegocio perfilNegocio;
  bool createCuenta;
  ProfileCuenta({@required this.perfilNegocio, this.createCuenta = false});
  @override
  _ProfileCuentaState createState() => _ProfileCuentaState(
      perfilNegocio: perfilNegocio, createCuenta: createCuenta);
}

class _ProfileCuentaState extends State<ProfileCuenta> {
  _ProfileCuentaState(
      {@required this.perfilNegocio, this.createCuenta = false});
  // Image
  String urlIamgen = "";
  PickedFile _imageFile;
  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  User firebaseUser;
  bool createCuenta;
  String titleAppBar = "Crear cuenta";

  // VAriables
  bool saveIndicador = false;
  PerfilNegocio perfilNegocio;
  TextEditingController controllerTextEdit_nombre;
  TextEditingController controllerTextEdit_descripcion;
  TextEditingController controllerTextEdit_username;
  TextEditingController controllerTextEdit_categoria_nombre;
  TextEditingController controllerTextEdit_telefono;
  TextEditingController controllerTextEdit_direccion;
  TextEditingController controllerTextEdit_sitio_web;
  TextEditingController controllerTextEdit_ciudad;
  TextEditingController controllerTextEdit_provincia;
  TextEditingController controllerTextEdit_pais;
  TextEditingController controllerTextEdit_signo_moneda;

  final FocusNode _focus_TextEdit_nombre = FocusNode();
  final FocusNode _focus_TextEdit_descripcion = FocusNode();
  final FocusNode _focus_TextEdit_username = FocusNode();
  final FocusNode _focus_TextEdit_categoria_nombre = FocusNode();
  final FocusNode _focus_TextEdit_telefono = FocusNode();
  final FocusNode _focus_TextEdit_direccion = FocusNode();
  final FocusNode _focus_TextEdit_sitio_web = FocusNode();
  final FocusNode _focus_TextEdit_ciudad = FocusNode();
  final FocusNode _focus_TextEdit_provincia = FocusNode();
  final FocusNode _focus_TextEdit_pais = FocusNode();

  @override
  void initState() {
    super.initState();
    perfilNegocio = perfilNegocio ?? new PerfilNegocio();
    controllerTextEdit_nombre =
        TextEditingController(text: perfilNegocio.nombre_negocio);
    controllerTextEdit_descripcion =
        TextEditingController(text: perfilNegocio.descripcion);
    controllerTextEdit_username =
        TextEditingController(text: perfilNegocio.username);
    controllerTextEdit_categoria_nombre =
        TextEditingController(text: perfilNegocio.categoria_nombre);
    controllerTextEdit_telefono =
        TextEditingController(text: perfilNegocio.telefono);
    controllerTextEdit_sitio_web =
        TextEditingController(text: perfilNegocio.sitio_web);
    controllerTextEdit_ciudad =
        TextEditingController(text: perfilNegocio.ciudad);
    controllerTextEdit_direccion =
        TextEditingController(text: perfilNegocio.direccion);
    controllerTextEdit_provincia =
        TextEditingController(text: perfilNegocio.provincia);
    controllerTextEdit_pais = TextEditingController(text: perfilNegocio.pais);
    controllerTextEdit_signo_moneda = TextEditingController(text:"\$");
  }

  @override
  void dispose() {
    controllerTextEdit_nombre.dispose();
    controllerTextEdit_descripcion.dispose();
    controllerTextEdit_username.dispose();
    controllerTextEdit_categoria_nombre.dispose();
    controllerTextEdit_telefono.dispose();
    controllerTextEdit_sitio_web.dispose();
    controllerTextEdit_ciudad.dispose();
    controllerTextEdit_direccion.dispose();
    controllerTextEdit_signo_moneda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Proveedor de datoss del usuario autenticado
    firebaseUser = Provider.of<User>(context);
    if (createCuenta) {
      this.perfilNegocio.id = firebaseUser.uid;
    }

    if (perfilNegocio.id != null) {
      if (perfilNegocio.id != "") {
        return Scaffold(
          appBar: AppBar(
            title: Text(!saveIndicador
                ? createCuenta ? "Crear cuenta" : "Editar"
                : "Actualizando"),
            actions: <Widget>[
              Builder(builder: (contextBuilder) {
                return IconButton(
                  icon:
                      saveIndicador == false ? Icon(Icons.check) : Container(),
                  onPressed: () {
                    guardar(context: context, contextBuilder: contextBuilder);
                  },
                );
              }),
            ],
            bottom: saveIndicador ? linearProgressBarApp() : null,
          ),
          body: Container(
            padding: EdgeInsets.all(12.0),
            child: ListView(
              children: [
                Column(
                  children: <Widget>[
                    widgetsImagen(),
                    SizedBox(
                      height: 24.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        if (saveIndicador == false) {
                          _showModalBottomSheetCambiarImagen(context: context);
                        }
                      },
                      child: Text(
                        "Cambiar imagen",
                      ),
                    ),
                    widgetFormEditText(),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  void _showModalBottomSheetCambiarImagen({@required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Capturar una imagen'),
                    onTap: () {
                      Navigator.pop(bc);
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    }),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Seleccionar desde la galería de fotos'),
                  onTap: () {
                    Navigator.pop(bc);
                    _onImageButtonPressed(ImageSource.gallery,
                        context: context);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget widgetsImagen() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          _imageFile == null
              ? perfilNegocio.imagen_perfil != ""
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: perfilNegocio.imagen_perfil != ""
                          ? perfilNegocio.imagen_perfil
                          : "default",
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 100.0,
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 100.0,
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 100.0,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 100.0,
                    )
              : CircleAvatar(
                  radius: 100.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: FileImage(File(_imageFile.path)),
                ),
        ],
      ),
    );
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(
        source: source,
        maxWidth: 720.0,
        maxHeight: 720.0,
        imageQuality: 55,
      );
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget widgetFormEditText() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            enabled: !saveIndicador,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => perfilNegocio.nombre_negocio = value,
            decoration: InputDecoration(
              labelText: "Nombre",
            ),
            controller: controllerTextEdit_nombre,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_nombre,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_nombre, _focus_TextEdit_descripcion);
            },
          ),
          TextField(
            enabled: !saveIndicador,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => perfilNegocio.descripcion = value,
            decoration: InputDecoration(
              labelText: "Descripción",
            ),
            controller: controllerTextEdit_descripcion,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_descripcion,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_descripcion, _focus_TextEdit_username);
            },
          ),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.username = value,
            decoration: InputDecoration(
              labelText: "username",
            ),
            controller: controllerTextEdit_username,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_username,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_username, _focus_TextEdit_categoria_nombre);
            },
          ),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.categoria_nombre = value,
            decoration: InputDecoration(
              labelText: "Categoria",
            ),
            controller: controllerTextEdit_categoria_nombre,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_categoria_nombre,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_categoria_nombre, _focus_TextEdit_telefono);
            },
          ),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.telefono = value,
            decoration: InputDecoration(
              labelText: "Telefono (ocional)",
            ),
            controller: controllerTextEdit_telefono,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_telefono,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_telefono, _focus_TextEdit_sitio_web);
            },
          ),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.sitio_web = value,
            decoration: InputDecoration(
              labelText: "Sitio web (ocional)",
            ),
            controller: controllerTextEdit_sitio_web,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_sitio_web,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_sitio_web, _focus_TextEdit_direccion);
            },
          ),
          InkWell(
            onTap: () => _buildBottomPicker(listItems: [
              "\$",
            ], 
            textEditingController: controllerTextEdit_signo_moneda),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              enabled: false,
              decoration: InputDecoration(labelText: "Signo de moneda"),
              controller: controllerTextEdit_signo_moneda,
              onChanged: (value) => perfilNegocio.signo_moneda = value,
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Text("Ubicación", style: TextStyle(fontSize: 24.0)),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.direccion = value,
            decoration: InputDecoration(
              labelText: "Dirección (ocional)" ,
            ),
            controller: controllerTextEdit_direccion,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_direccion,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_direccion, _focus_TextEdit_ciudad);
            },
          ),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.ciudad = value,
            decoration: InputDecoration(labelText: "Ciudad (ocional)"),
            controller: controllerTextEdit_ciudad,
          ),
          InkWell(
            onTap: () => _buildBottomPicker(listItems: [
              'Buenos Aires',
              'Catamarca',
              'Chaco',
              'Chubut',
              'Córdoba',
              'Corrientes',
              'Entre Ríos',
              'Formosa',
              'Jujuy',
              'La Pampa',
              'La Rioja',
              'Mendoza',
              'Misiones',
              'Neuquén',
              'Río Negro',
              'Salta',
              'San Juan',
              'San Luis',
              'Santa Cruz',
              'Santa Fe',
              'Santiago del Estero',
              'Tucumán',
              'Tierra del Fuego',
            ], textEditingController: controllerTextEdit_provincia),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              enabled: false,
              decoration: InputDecoration(labelText: "Provincia"),
              controller: controllerTextEdit_provincia,
              onChanged: (value) => perfilNegocio.provincia = value,
            ),
          ),
          InkWell(
            onTap: () => _buildBottomPicker(listItems: [
              'Argentina',
            ], textEditingController: controllerTextEdit_pais),
            child: TextField(
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              enabled: false,
              decoration: InputDecoration(labelText: "Pais"),
              controller: controllerTextEdit_pais,
              onChanged: (value) => perfilNegocio.pais = value,
            ),
          ),
        ],
      ),
    );
  }

  void _buildBottomPicker(
      {@required TextEditingController textEditingController,
      @required List<String> listItems}) {
    int _index = 0;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CupertinoButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: CupertinoPicker(
                      scrollController: new FixedExtentScrollController(
                        initialItem: 0,
                      ),
                      itemExtent: 32.0,
                      backgroundColor: Colors.white,
                      onSelectedItemChanged: (int index) {
                        _index = index;
                      },
                      children: new List<Widget>.generate(listItems.length,
                          (int index) {
                        return new Center(
                          child: new Text(listItems[index]),
                        );
                      })),
                ),
                CupertinoButton(
                  child: Text("Ok"),
                  onPressed: () {
                    setState(() {
                      textEditingController.text = listItems[_index];
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void guardar(
      {@required BuildContext contextBuilder,
      @required BuildContext context}) async {

    perfilNegocio.provincia=controllerTextEdit_provincia.text;
    perfilNegocio.pais=controllerTextEdit_pais.text;
    if (perfilNegocio.id != "") {
      if (perfilNegocio.nombre_negocio != "") {
        if (perfilNegocio.username != "") {
          if (perfilNegocio.ciudad != "") {
            if (perfilNegocio.provincia!= "") {
              if (perfilNegocio.pais != "") {
                setState(() {
                  saveIndicador = true;
                });

                // Si la "PickedFile" es distinto nulo procede a guardar la imagen en la base de dato de almacenamiento
                if (_imageFile != null) {
                  StorageReference ref = FirebaseStorage.instance
                      .ref()
                      .child("NEGOCIOS")
                      .child(perfilNegocio.id)
                      .child("PERFIL")
                      .child("imagen_perfil");
                  StorageUploadTask uploadTask =ref.putFile(File(_imageFile.path));
                  // obtenemos la url de la imagen guardada
                  urlIamgen =await (await uploadTask.onComplete).ref.getDownloadURL();
                  // TODO: Por el momento los datos del producto se guarda junto a la referencia de la cuenta del negocio
                  perfilNegocio.imagen_perfil = urlIamgen;
                }

                // Cuando se crea una cuenta , se copia referencias del id de usuario de la cuenta
                if (this.createCuenta) {
                  // guarda un documento con la referencia del id de la cuenta en una lista en los datos del usuario
                  await Global.getDataReferenceCuentaUsuarioAministrador(
                          idNegocio: perfilNegocio.id,
                          idUsuario: firebaseUser.uid)
                      .upSetDocument({'id': perfilNegocio.id});
                  // Guarda datos del usuario y la referencia del id de la cuenta
                  await Global.getDataUsuario(idUsuario: firebaseUser.uid)
                      .upSetDocument(new Usuario(
                              email: firebaseUser.email,
                              id: firebaseUser.uid,
                              id_cuenta_negocio: firebaseUser.uid,
                              nombre: firebaseUser.displayName,
                              urlfotoPerfil: firebaseUser.photoURL,
                              timestamp_creation:
                                  Timestamp.fromDate(new DateTime.now()))
                          .toJson());
                  // guarda un documento con la referencia del usuario, en la lista de administradores de la cuenta
                  await Global.getDataAsuarioAdministrador(
                          idNegocio: perfilNegocio.id,
                          idUsuario: firebaseUser.uid)
                      .upSetDocument(new AsuarioAdministrador(
                              id_usuario: firebaseUser.uid, tipocuenta: 0)
                          .toJson());
                  Global.actualizarPerfilNegocio(perfilNegocio: perfilNegocio);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/page_principal', (Route<dynamic> route) => false);
                } else {
                  // guarda los datos de la cuenta
                  await Global.getNegocio(idNegocio: perfilNegocio.id)
                      .upSetPerfilNegocio(perfilNegocio.toJson());
                  Navigator.pop(context);
                }
              } else {
                showSnackBar(
                    context: contextBuilder,
                    message: 'Debe proporcionar un pais de origen');
              }
            } else {
              showSnackBar(
                  context: contextBuilder,
                  message: 'Debe proporcionar una provincia');
            }
          } else {
            showSnackBar(
                context: contextBuilder,
                message: 'Debe proporcionar una ciudad');
          }
        } else {
          showSnackBar(
              context: contextBuilder,
              message: 'Debe proporcionar un nombre de usuario');
        }
      } else {
        showSnackBar(
            context: contextBuilder, message: 'Debe proporcionar un nombre');
      }
    } else {
      showSnackBar(
          context: contextBuilder,
          message: 'El ID del usuario de proveedor es NULO');
    }
  }
}
