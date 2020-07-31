///
//  El uso principal de Shared Preferences es guardar las preferencias de los usuarios, 
// configuraciones, tal vez datos (si no es muy grande) para que la próxima vez que la aplicación sea lanzada, 
// estas piezas de información podrían ser recibidas y usadas.
///
// Utilizaremos el patrón de diseño Singleton para guardar el estado

//** En el archivo pubspec.yaml, añada el shared_preferences a la lista de dependencias **/
//  dependencies: shared_preferences: "<versión más nueva>"

//  Importaciones
import 'package:shared_preferences/shared_preferences.dart';


class PreferenciasUsuario{


  /*
  * * START [ PATRON SINGLETON ]
  * La idea principal de este patrón es hacer que una clase sea responsable de realizar un seguimiento de su única instancia.
  */
  // instancia de propiedad estática que es una referencia a la instancia de clase en sí (esta relación se representa como un enlace de asociación de la clase Singleton a sí misma)
  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();
  // Esta instancia solo es accesible a través del método
  factory PreferenciasUsuario(){return _instancia;}
  // El constructor de la clase está marcado como privado (podría protegerse en otras implementaciones) para garantizar que la clase no se pueda instanciar desde fuera de la clase.
  PreferenciasUsuario._internal();
  ///
  // FINISH [ PATRON SINGLETON ]
  ///
  
  // Instanciacion de la libreria SharedPreferences
  SharedPreferences _prefs ;
  static const String _sharedPreference_page = "page";
  static const String _sharedPreference_isDark = "isDark";
  static const String _sharedPreferencesColorPrimaryOption = "color_primario";
  static const String _sharedPreferencesonboadingStart = "onboadingStart";
  static const String _idNegocio = "idNegocio";
  
  // Inicializamos la instancia de las SharedPreferebces
  Future initPrefs()async{
    this._prefs = await SharedPreferences.getInstance();
  }

  // Getters
  get getPage{ return _prefs.getString( _sharedPreference_page ) ?? "home";}
  get getThemeIsDart{return _prefs.getBool( _sharedPreference_isDark ) ?? false;}// Getters Preferences del Theme
  get getThemeColorPrimary{return _prefs.getInt( _sharedPreferencesColorPrimaryOption ) ?? 0;}// Getters Preferences del ThemeColorPrimary
  get getOnboadingStart{return _prefs.getBool( _sharedPreferencesonboadingStart ) ?? true;}
  get getIdNegocio{return _prefs.getString( _idNegocio ) ?? "";}

  // Setters
  set setPage( String value ){  _prefs.setString( _sharedPreference_page , value); }
  set setThemeIsDart( bool value ){_prefs.setBool( _sharedPreference_isDark , value);}// Setters Preferences del Theme
  set setThemeColorPrimary( int value ){_prefs.setInt( _sharedPreferencesColorPrimaryOption , value);}// Setters Preferences del ThemeColorPrimary
  set setOnboadingStart( bool value ){_prefs.setBool( _sharedPreferencesonboadingStart , value);}
  set setIdNegocio( String value ){_prefs.setString( _idNegocio , value??"");}

  //!
  //!  Tenga en cuenta que los Shared Preferences no están cifrados, por lo tanto, no se recomienda colocar datos confidenciales, como una contraseña, por ejemplo.
  //!


}