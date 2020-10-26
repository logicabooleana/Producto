import 'package:producto/screens/app_preferences/page_theme_preference.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:provider/provider.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:producto/utils/dynamicTheme_lb.dart';
import 'package:producto/services/preferencias_usuario.dart';
import 'package:producto/screens/page_principal.dart';
import 'package:producto/screens/page_welcome.dart';
import 'package:producto/screens/page_login.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // convertimos esta funcion en asincronica para que cargue la app despues que cargue los datos de sharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ProviderPerfilNegocio()),
      ChangeNotifierProvider(create: (_) => ProviderMarcasProductos()),
      ChangeNotifierProvider(create: (_) => ProviderCatalogo()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Create the initilization Future outside of `build`:
    final Future<FirebaseApp> _initializationFirebase = Firebase.initializeApp();

    final prefs = new PreferenciasUsuario();
    Global.prefs = prefs;

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initializationFirebase,
      builder: (context, snapshot) {
        
        // Check for errors
        if (snapshot.hasError) {
          return Center(child: Text("error",textDirection: TextDirection.rtl));
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return WidgetMaterialApp();
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: Text("Producto",textDirection: TextDirection.rtl));
      },
    );
  }
}

class WidgetMaterialApp extends StatelessWidget {
  const WidgetMaterialApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //return Center(child: Text("Hola",textDirection: TextDirection.rtl),);
    return DynamicTheme(
        // Este paquete gestiona el cambio de su tema durante el tiempo de ejecución y su persistencia.
        defaultBrightness:Global.prefs.getThemeIsDart ? Brightness.dark : Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.purple,
              primaryColorDark: Colors.purple,
              primaryColor: Colors.purple,
              brightness: brightness,
              accentColor: Colors.purple,
            ),
        themedWidgetBuilder: (context, theme) {
          return MultiProvider(
            providers: [
              StreamProvider<User>.value(value: AuthService().user),
            ],
            child: MaterialApp(
              theme: theme,
              debugShowCheckedModeBanner: false,
              initialRoute: "/",
              // Firebase Analytics
              navigatorObservers: [ FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
              ],
              // Named Routes
              routes: {
                '/': (context) => SplashScreen(),
                'init': (context) => MyApp(),
                '/login': (context) => PageLogin(),
                '/page_principal': (context) =>PagePrincipal(), // CatalogoNegocio(),
                '/profile': (context) => ProfileScreen(),
                '/about': (context) => AboutScreen(),
                '/page_themeApp': (context) => PageThemePreferences(),
              },
            ),
          );
        });
  }
}

class ScreenLogin {
}
