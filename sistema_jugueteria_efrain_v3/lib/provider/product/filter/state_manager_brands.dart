import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

class StateManagerBrands {
  //Atributos de instancia
  late List<String> _brands;

  //Atributos de clase
  static final StateManagerBrands _instance = StateManagerBrands._();

  StateManagerBrands._(){
    _brands = [];
  }

  Future<ResponseAPI> initialize(String url) async {
    return await refresh(url);
  }

  Future<ResponseAPI> refresh(String url) async {
    //Obtiene la URL a la API.
    ResponseAPI content;

    //Si hay elementos, entonces se remueven todos.
    if (_brands.isNotEmpty){
      _brands.clear();
    }

    try{
      content = await APICall.get(url: url, route: "/filter/brands");
      if (content.isResponseSuccess()){
        //Convierte los datos obtenidos en una lista de objetos json (mapeos).
        List<dynamic> map = content.getValue();
        //Para cada elemento del mapeo, se lo inserta en la lista.
        for (var e in map) {
          String element = e['p_brand'].toString();
          _brands.add(element);
        }
      }

      //Si la lista está vacia, entonces ingresa el valor seguro.
      if (_brands.isEmpty) {
        _brands = ["IMPORT."];
      }
      //Si la lista tiene elementos, comprueba la existencia de dicho valor seguro.
      else {
        if (!_brands.contains("IMPORT.")){
          _brands = ["IMPORT."];
        }
      }
    }
    catch(e){
      content = ResponseAPI.manual(status: 404, value: null, title: "Error 404", message: "Error: No fue posible recuperar los datos del servidor.");
      _brands = ["IMPORT."];
    }

    return content;
  }

  Iterable<String> getBrands(){
    return _brands;
  }

  static StateManagerBrands getInstance(){
    return _instance;
  }
}