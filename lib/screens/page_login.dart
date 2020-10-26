import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class PageLogin extends StatefulWidget {
  createState() => PageLoginState();
}

class PageLoginState extends State<PageLogin> {
  /* Declarar variables */
  int page = 0; /* Posición de la página */
  bool enableSlideIcon =
      true; /* Controla el estado de la visibilidad de iconButton para deslizar la pantalla del lado izquierdo */
  bool isDarkGlobal = false; /* Controla el brillo de la barra de estado */
  AuthService auth = AuthService();
  Size screenSize;
  bool authState = false;
  bool loadAuth = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return scaffold();
  }

  Widget scaffold() {
    return Scaffold(
      body: LiquidSwipe(
        initialPage: 0,
        fullTransitionValue: 500,
        /* Establece la distancia de desplazamiento o la sensibilidad para un deslizamiento completo. */
        enableSlideIcon: enableSlideIcon,
        /* Se usa para habilitar el ícono de diapositiva a la derecha de dónde se originaría la onda */
        enableLoop: false,
        /* Habilitar o deshabilitar la recurrencia de páginas. */
        positionSlideIcon: 0.00,
        /* Coloque su icono en el eje y en el lado derecho de la pantalla */
        slideIconWidget: Icon(Icons.arrow_back_ios,
            color: isDarkGlobal ? Colors.black : Colors.white),
        pages: [
          componentePersonado(
              color: Colors.purple[600],
              iconData: Icons.search,
              texto: "ESCANEAR",
              descripcion:
                  "Solo tenes que enfocar el producto y obtenes la información en el acto",
              brightness: Brightness.light),
          componente(
              color: Colors.orange[600],
              iconData: Icons.monetization_on,
              texto: "¿QUERES SABER EL PRECIO?",
              descripcion:
                  "Compara el precios de diferentes comerciantes o compartir tu precio",
              brightness: Brightness.light),
          componente(
              color: Colors.lightBlue[600],
              iconData: Icons.category,
              texto: "Crea tu catálogo",
              descripcion: "Arma tu catalogo de productos",
              brightness: Brightness.light),
        ],
        /* Establecer las páginas / vistas / contenedores */
        onPageChangeCallback: onPageChangeCallback,
        /* Pase su método como devolución de llamada, devolverá un número de página. */
        waveType: WaveType
            .liquidReveal, /* Seleccione el tipo de revelación que desea. */
      ),
    );
  }

  Widget componente(
      {@required IconData iconData,
      @required String texto,
      @required String descripcion,
      @required Color color,
      Brightness brightness = Brightness.light}) {
    Color colorPrimary =
        brightness != Brightness.light ? Colors.black : Colors.white;
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconData, size: 100.0, color: colorPrimary),
                        SizedBox(height: 12.0),
                        Text(texto,
                            style:
                                TextStyle(fontSize: 24.0, color: colorPrimary),
                            textAlign: TextAlign.center),
                        descripcion != ""
                            ? Text(
                                descripcion,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: colorPrimary,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: loadAuth == false
                ? loginButton(
                    text: 'INICIAR SESIÓN CON GOOGLE',
                    icon: FontAwesomeIcons.google,
                    color: colorPrimary,
                    colorbutton: Colors.transparent,
                    loginMethod: auth.googleSignIn,
                  )
                : Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white)),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/ic_launcher_commer.png',
                    width: 30.0, height: 30.0),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Commer",
                  style: TextStyle(fontSize: 18.0, color: colorPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget componentePersonado(
      {@required IconData iconData,
      @required String texto,
      @required String descripcion,
      @required Color color,
      Brightness brightness = Brightness.light}) {
    Color colorPrimary =
        brightness != Brightness.light ? Colors.black : Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            color: colorPrimary,
                            height: 100.0,
                            width: 100.0,
                            image: AssetImage('assets/barcode.png'),
                            fit: BoxFit.contain),
                        SizedBox(height: 12.0),
                        Text(texto,
                            style:
                                TextStyle(fontSize: 24.0, color: colorPrimary),
                            textAlign: TextAlign.center),
                        descripcion != ""
                            ? Text(
                                descripcion,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: colorPrimary,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: loadAuth == false
                ? loginButton(
                    text: 'INICIAR SESIÓN CON GOOGLE',
                    icon: FontAwesomeIcons.google,
                    color: colorPrimary,
                    colorbutton: Colors.transparent,
                    loginMethod: auth.googleSignIn,
                  )
                : Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white)),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/ic_launcher_commer.png',
                    width: 30.0, height: 30.0),
                SizedBox(
                  width: 8.0,
                ),
                Text(
                  "Commer",
                  style: TextStyle(fontSize: 18.0, color: colorPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /* liquid_swipe / Pase su método como devolución de llamada, devolverá un número de página. */
  onPageChangeCallback(int lpage) {
    setState(
        // Controla el estado de la visibilidad de iconButton para deslizar la pantalla del lado izquierdo
        () {
      page = lpage;
      if (2 == page) {
        /* Esconde el iconButton de desplazamiento */
        enableSlideIcon = false;
        /* Aplicar color oscuro al iconButton de deslizamiento */
        isDarkGlobal = true;
      } else {
        /* Muestra el iconButton de desplazamiento */
        enableSlideIcon = true;
        /* Por default aplica el brillo al iconButton */
        isDarkGlobal = false;
      }
    });
  }

  Widget loginButton(
      {String text,
      IconData icon,
      Color color,
      Color colorbutton,
      var loginMethod}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: FlatButton.icon(
          shape: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: color)),
          padding: EdgeInsets.all(30),
          icon: Icon(icon, color: color),
          color: colorbutton,
          onPressed: () async {
            setState(() {loadAuth = true;});
            var user = await loginMethod();
            if (user != null) {
              Navigator.of(context).pushNamedAndRemoveUntil('/page_principal', (Route<dynamic> route) => false);
            }else{
              setState(() { loadAuth = false; });
            }
          },
          label: Expanded(
            child: Text(
              '$text',
              textAlign: TextAlign.center,
              style: TextStyle(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
