import 'package:catalogo/screens/app_preferences/page_theme_preference.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:provider/provider.dart';
import 'services/services.dart';
import 'screens/screens.dart';
import 'package:catalogo/utils/dynamicTheme_lb.dart';
import 'package:catalogo/services/preferencias_usuario.dart';
import 'package:catalogo/screens/page_profile_negocio.dart';

void main() async {
  // convertimos esta funcion en asincronica para que cargue la app despues que cargue los datos de sharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(
    MultiProvider(
       providers: [
        ChangeNotifierProvider(create: (_) => ProviderPerfilNegocio()),
      ],
      child:MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();
    Global.prefs=prefs;

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
              StreamProvider<FirebaseUser>.value(value: AuthService().user),
            ],
            child: MaterialApp(
              theme: theme,
              debugShowCheckedModeBanner: false,
              // Firebase Analytics
              navigatorObservers: [
                FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
              ],
              // Named Routes
              routes: {
                '/': (context) => LoginScreen(),
                '/page_catalogo': (context) => PageProfile(), // CatalogoNegocio(),
                '/profile': (context) => ProfileScreen(),
                '/about': (context) => AboutScreen(),
                '/page_themeApp': (context) => PageThemePreferences(),
              },
            ),
          );
        });

    /* return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // Firebase Analytics
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        ],
        // Named Routes
        routes: {
          '/': (context) => LoginScreen(),
          '/page_catalogo': (context) => CatalogoNegocio(),
          '/profile': (context) => ProfileScreen(),
          '/about': (context) => AboutScreen(),
          '/page_themeApp': (context) => DynamicTheme(),
        },

        // Theme
        theme: ThemeData(
          fontFamily: 'Nunito',
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.black87,
          ),
          brightness: Brightness.dark,
          textTheme: TextTheme(
            body1: TextStyle(fontSize: 18),
            body2: TextStyle(fontSize: 16),
            button: TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.bold),
            headline: TextStyle(fontWeight: FontWeight.bold),
            subhead: TextStyle(color: Colors.grey),
          ),
          buttonTheme: ButtonThemeData(),
        ),
      ),
    ); */
  }
}
