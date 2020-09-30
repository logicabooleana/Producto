import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginScreen extends StatefulWidget {
  createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  /* Declarar variables */
  PageController _controller = PageController(initialPage: 0);
  AuthService auth = AuthService();
  Size screenSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    //TODO: Verificar metodo de authenticacion
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
      } else {
        Navigator.pushReplacementNamed(context, '/page_principal');
      }
    });
    return scaffold();
    //return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget scaffold() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /* Image.asset(
              'assets/barcode.png',
              width: 100.0,
              height: 100.0,
              color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
            ),
            Text(
              'Producto',
              style: TextStyle(fontStyle: FontStyle.normal,fontSize: 30.0,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
              textAlign: TextAlign.center,
            ),
            Text('👋'), */
            onboading(),
            SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect( dotColor: Theme.of(context).brightness == Brightness.dark?Colors.white24:Colors.black26, activeDotColor: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,)),
            LoginButton(
              text: 'INICIAR SESIÓN CON GOOGLE',
              icon: FontAwesomeIcons.google,
              color: Colors.white,
              colorbutton: Theme.of(context).primaryColor,
              loginMethod: auth.googleSignIn,
            ),
            Row(
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
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget onboading() {
    return Container(
      width: screenSize.width,
      height: screenSize.height / 2,
      child: PageView(
        /* Una lista desplazable que funciona página por página. */
        controller: _controller,
        /*  El initialPageparámetro establecido en 0 significa que el primer elemento secundario del widget PageViewse mostrará primero (ya que es un índice basado en cero) */
        pageSnapping: true,
        /* Deslizaiento automatico */
        scrollDirection: Axis.horizontal,
        /* Dirección de deslizamiento */
        children: <Widget>[
          Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                      color:Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,
                      height: 100.0,
                      width: 100.0,
                      image: AssetImage('assets/barcode.png'),
                      fit: BoxFit.contain),
                      SizedBox(height: 12.0),
                      Text("Escanea un producto",style: TextStyle(fontSize: 24.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on,size: 100.0),
                      SizedBox(height: 12.0),
                      Text("Compara precios",style: TextStyle(fontSize: 24.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category,size: 100.0),
                      SizedBox(height: 12.0),
                      Text("crea tu catalogo",style: TextStyle(fontSize: 24.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final Color colorbutton;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {Key key,
      this.text,
      this.icon,
      this.color,
      this.colorbutton,
      this.loginMethod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: FlatButton.icon(
        padding: EdgeInsets.all(30),
        icon: Icon(icon, color: color),
        color: colorbutton,
        onPressed: () async {
          var user = await loginMethod();
          if (user != null) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/page_principal', (Route<dynamic> route) => false);
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
    );
  }
}
