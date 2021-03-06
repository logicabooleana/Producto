import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import '../services/services.dart';
import 'package:Producto/services/globals.dart';
import 'package:Producto/models/models_profile.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Producto/screens/widgets/widgets_notify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Producto/shared/progress_bar.dart';

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
  final ImagePicker _picker = ImagePicker();
  User firebaseUser;
  bool createCuenta;
  String titleAppBar = "Crear cuenta";

  // VAriables
  bool saveIndicador = false;
  PerfilNegocio perfilNegocio;
  TextEditingController controllerTextEdit_nombre;
  TextEditingController controllerTextEdit_descripcion;
  TextEditingController controllerTextEdit_categoria_nombre;
  TextEditingController controllerTextEdit_direccion;
  TextEditingController controllerTextEdit_ciudad;
  TextEditingController controllerTextEdit_provincia;
  TextEditingController controllerTextEdit_pais;
  TextEditingController controllerTextEdit_signo_moneda;

  final FocusNode _focus_TextEdit_nombre = FocusNode();
  final FocusNode _focus_TextEdit_descripcion = FocusNode();
  final FocusNode _focus_TextEdit_categoria_nombre = FocusNode();
  final FocusNode _focus_TextEdit_direccion = FocusNode();
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
    controllerTextEdit_ciudad =
        TextEditingController(text: perfilNegocio.ciudad);
    controllerTextEdit_categoria_nombre =
        TextEditingController();
    controllerTextEdit_direccion =
        TextEditingController(text: perfilNegocio.direccion);
    controllerTextEdit_provincia =
        TextEditingController(text: perfilNegocio.provincia);
    controllerTextEdit_pais = TextEditingController(text: perfilNegocio.pais);
    controllerTextEdit_signo_moneda = TextEditingController(text:"\$");
  }

  @override
  void dispose() {
    super.dispose();
    controllerTextEdit_nombre.dispose();
    controllerTextEdit_descripcion.dispose();
    controllerTextEdit_categoria_nombre.dispose();
    controllerTextEdit_ciudad.dispose();
    controllerTextEdit_direccion.dispose();
    controllerTextEdit_signo_moneda.dispose();
    controllerTextEdit_pais.dispose();
    controllerTextEdit_provincia.dispose();
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
          body: ListView(
            padding: EdgeInsets.all(12.0),
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
                  title: new Text('Seleccionar desde la galer??a de fotos'),
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
              labelText: "Descripci??n",
            ),
            controller: controllerTextEdit_descripcion,
            textInputAction: TextInputAction.next,
            focusNode: _focus_TextEdit_descripcion,
            onSubmitted: (term) {
              _fieldFocusChange(context, _focus_TextEdit_descripcion, _focus_TextEdit_direccion);
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
          Text("Ubicaci??n", style: TextStyle(fontSize: 24.0)),
          TextField(
            enabled: !saveIndicador,
            onChanged: (value) => perfilNegocio.direccion = value,
            decoration: InputDecoration(
              labelText: "Direcci??n (ocional)" ,
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
              'C??rdoba',
              'Corrientes',
              'Entre R??os',
              'Formosa',
              'Jujuy',
              'La Pampa',
              'La Rioja',
              'Mendoza',
              'Misiones',
              'Neuqu??n',
              'R??o Negro',
              'Salta',
              'San Juan',
              'San Luis',
              'Santa Cruz',
              'Santa Fe',
              'Santiago del Estero',
              'Tucum??n',
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
          SizedBox(width: 50.0, height: 50.0),
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
        if (perfilNegocio.ciudad != "") {
            if (perfilNegocio.provincia!= "") {
              if (perfilNegocio.pais != "") {
                perfilNegocio.direccion=controllerTextEdit_direccion.text;
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
                  // guarda los datos de la cuenta
                  await Global.getNegocio(idNegocio: perfilNegocio.id).upSetPerfilNegocio(perfilNegocio.toJson());
                  context.read<ProviderPerfilNegocio>().setCuentaNegocio=perfilNegocio;
                  Navigator.of(context).pushNamedAndRemoveUntil('/page_principal', (Route<dynamic> route) => false);
                } else {
                  // guarda los datos de la cuenta
                  await Global.getNegocio(idNegocio: perfilNegocio.id).upSetPerfilNegocio(perfilNegocio.toJson());
                  context.read<ProviderPerfilNegocio>().setCuentaNegocio=perfilNegocio;
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
            context: contextBuilder, message: 'Debe proporcionar un nombre');
      }
    } else {
      showSnackBar(
          context: contextBuilder,
          message: 'El ID del usuario de proveedor es NULO');
    }
  }
}
