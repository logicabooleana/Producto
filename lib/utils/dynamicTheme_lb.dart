/* Este paquete gestiona el cambio de su tema durante el tiempo de ejecución y su persistencia. */
/* Hace uso de SharedPreferences */

/* FUNCIONES */
/* 1 * Cambia el brillo del tema actual (oscuro/luz) */
/* getViewSelectTheme() - Devuelve una vista para que el usuario pueuda cambia el brillo del tema actual */
/* Selecciona el color del tema principal */
/* getViewSelectTheme() - Devuelve una vista para que el usuario pueuda cambiar el color principal de tema actual */

/* USO DE PAQUETES EXTERNOS */
/* animate_do: ^x.x.x ( Un paquete de animación inspirado en Animate.css , creado utilizando solo animaciones Flutter, sin paquetes adicionales. ) */
/* shared_preferences: ^0.5.7+3 ( Envuelve NSUserDefaults (en iOS) y SharedPreferences (en Android), proporcionando un almacén persistente para datos simples. Los datos se conservan en el disco de forma asincrónica. ) */

/* Paquetes internos */
import 'package:flutter/services.Dart';
import 'package:flutter/material.dart';
import 'dart:async';
/* Paquetes externos */
import 'package:animate_do/animate_do.dart'; /* paquete externo // animate_do: ^[version] */
import 'package:shared_preferences/shared_preferences.dart'; /* paquete externo // shared_preferences: ^[version] */
export 'package:animate_do/animate_do.dart';


typedef ThemedWidgetBuilder = Widget Function(BuildContext context, ThemeData data);
typedef ThemeDataWithBrightnessBuilder = ThemeData Function(Brightness brightness);

class DynamicTheme extends StatefulWidget {
  const DynamicTheme({Key key, this.data, this.themedWidgetBuilder, this.defaultBrightness}): super(key: key);
  final ThemedWidgetBuilder themedWidgetBuilder;
  final ThemeDataWithBrightnessBuilder data;
  final Brightness defaultBrightness;

  @override
  DynamicThemeState createState() => DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<DynamicThemeState>();
  }
}

class DynamicThemeState extends State<DynamicTheme> {

  /* Declarar variables */
  Color colorBlack=Color.fromARGB(255, 20, 20, 20);
  Color colorLight=Color.fromARGB(255, 238, 238, 238);
  ThemeData _themeData;
  Brightness _brightness=Brightness.light;
  /* ids */
  static const String _sharedPreferencesKey = 'isDark';

  ThemeData get data => _themeData;
  Brightness get brightness => _brightness;

  @override
  void initState() {
    super.initState();
    _brightness = widget.defaultBrightness;
    setBrightness(_brightness);
    /* Carga el brillo del tema de las preferecias del usuario */
    loadBrightness().then((bool dark) {
      setBrightness(dark ? Brightness.dark : Brightness.light);
      /* Carga el color primario de tema */

      /* Barra de navegación del sistema ( personalización ) */
      SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.dark.copyWith( 
            systemNavigationBarColor: _brightness == Brightness.dark?Colors.black:Colors.white,
            systemNavigationBarIconBrightness: _brightness == Brightness.dark?Brightness.light:Brightness.dark,
            statusBarBrightness: Theme.of(context).brightness == Brightness.dark?Brightness.light:Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            );
      SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _themeData = widget.data(_brightness);
  }
  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _themeData = widget.data(_brightness);

    

  }

  /* SET ( Birrlo del tema ) */
  Future<void> setBrightness(Brightness brightness) async {
    
    setState(() {
      _themeData = widget.data(brightness).copyWith(primaryColor: _themeData.primaryColor,accentColor: _themeData.accentColor,scaffoldBackgroundColor: brightness==Brightness.dark?colorBlack:colorLight,canvasColor: brightness==Brightness.dark?colorBlack:colorLight);
      _brightness = brightness;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sharedPreferencesKey, brightness == Brightness.dark ? true : false);
  }

  /* Cambia a un tema pasado por parametro */
  void setThemeData(ThemeData data) {
    setState(() {_themeData = data;});
  }

  /* SharedP */
  Future<bool> loadBrightness() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sharedPreferencesKey) ?? widget.defaultBrightness == Brightness.dark;
  }
  @override
  Widget build(BuildContext context) { return widget.themedWidgetBuilder(context, _themeData);}


  /* [ START - Vista seleccion de tema ] */
  /* Vista : Muesta un Icono,Titulo,Descripción y un SwitchListTile */
  /* Acción : Cambia el brillo del tema a oscuro o luz */
  AnimationController animateController_icon_title;
  AnimationController animateController_icon_isDark;
  String _infoThemeOscuro ="Un tema oscuro es una IU con poca luz que muestra principalmente superficies oscuras.";
  String _infoThemeLuz ="Un tema claro es una IU con mucha luz que muestra principalmente superficies blanca o clara.";
 
  Widget getViewSelectTheme(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(    
        children: <Widget>[
          /* Icono y titulo con animacion  */
          ElasticIn(
            manualTrigger: false, /*  (opcional) si es verdadero, no activará la animación al cargar */
            controller: (controller) => animateController_icon_title = controller, /* (opcional, pero obligatorio si usa manualTrigger: true) Esta devolución de llamada expone el AnimationController utilizado para la animación seleccionada. Luego puede llamar a animationController.forward () para activar la animación donde quiera manualmente. */
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.color_lens, size: 30.0),
                SizedBox(width: 12.0),
                Text((brightness == Brightness.dark)? "Tema oscuro": "Tema luz",style:TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              ],
            ),
          ),
          SizedBox(height: 12.0),
          /* Texto ( Descripcion ) */
          Container(height: 100.0,child: Text((brightness == Brightness.dark) ? _infoThemeOscuro : _infoThemeLuz,style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center)),
          /* Un ListTile con un interruptor . En otras palabras, un interruptor con una etiqueta. */
          SwitchListTile(
            contentPadding: EdgeInsets.all(0.0),
            title:(brightness == Brightness.dark) ? Text("Oscuro") : Text("Brillo"),
            activeColor: _themeData.accentColor,
            inactiveThumbColor:_themeData.accentColor,
            value: brightness == Brightness.dark ? true : false,
            onChanged: (bool value) {
              setState(() {
                animateController_icon_title.repeat();
                animateController_icon_isDark.repeat();
                setBrightness(brightness==Brightness.dark?Brightness.light:Brightness.dark);
              });
            },
            secondary:  FadeInLeft( 
              controller: (controller) => animateController_icon_isDark = controller,
              child:      (brightness == Brightness.dark)
                ? const Icon(Icons.brightness_3, size: 30.0)
                : const Icon(Icons.brightness_7,size: 36.0, color: Colors.yellow),
          )),
        ],
      ),
    );
  }
  /* [ FINISH - Vista seleccion de tema ] */



  /* [ START - Vista ButtonIcon ] */
  Widget getIConButton(BuildContext context) {
    return  IconButton(
      icon: brightness == Brightness.dark? const Icon(Icons.brightness_3, size: 24.0): const Icon(Icons.brightness_7,size: 24.0), 
      onPressed: (){ 
        setBrightness(Theme.of(context).brightness==Brightness.dark?Brightness.light:Brightness.dark ); 
          /* Barra de navegación del sistema ( personalización ) */
          SystemUiOverlayStyle mySystemTheme = SystemUiOverlayStyle.dark.copyWith( 
            systemNavigationBarColor: _brightness == Brightness.dark?Colors.black:Colors.white,
            systemNavigationBarIconBrightness: _brightness == Brightness.dark?Brightness.light:Brightness.dark,
            statusBarBrightness: Theme.of(context).brightness == Brightness.dark?Brightness.light:Brightness.dark,
            statusBarIconBrightness: Brightness.light,
            );
          SystemChrome.setSystemUIOverlayStyle(mySystemTheme);
      });
  }
  /* [FINISH . Vista ButtonIcon ] */
}
