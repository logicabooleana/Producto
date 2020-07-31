import "package:unorm_dart/unorm_dart.dart" as unorm;

class Buscardor {

    //---Algoritmo de busqueda
    static bool buscar(String value, String valueSeach){
        bool resultado = false;
        if(value !=null){
            //Convierte los valores String en minuscula para facilitar la busqueda
            try {
                value=value.toLowerCase();
                valueSeach=valueSeach.toLowerCase();
            }catch (exception){
                valueSeach=valueSeach;
                value=value;
            }

            // TODO: Todavia no se normalizaron las valores de busqueda
            //valueSeach=unorm.nfc( valueSeach );
            //value=unorm.nfc( value );

            dynamic stringsArrayValueBuscador;
            int rdsultado2;
            //------------------   Algoritbo de busqueda --------------------------------------
            stringsArrayValueBuscador=valueSeach.split(" ");
            if( valueSeach != ""){
                for (int i = 0; i < stringsArrayValueBuscador.length; i++){
                    // aqui se puede referir al objeto con arreglo[i];
                    rdsultado2 = value.indexOf(stringsArrayValueBuscador[i]);
                    if(rdsultado2 != -1) {
                        resultado=true;
                    }else{
                        resultado=false;
                        break;
                    }
                }
            }
        }
        return resultado;
    }
  
}