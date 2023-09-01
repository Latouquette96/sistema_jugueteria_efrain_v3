import 'dart:convert';
import 'package:sistema_jugueteria_efrain_v3/controller/json/mixin_factory_json.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/minimum_age.dart';

///Clase FactoryMinimumAge: Permite construir las posibles edades minimas que podran ser utilizadas en el sistema.
class FactoryMinimumAge with MixinFactoryJSONDefault<MinimumAge, MinimumAge>{

  static final FactoryMinimumAge _instance = FactoryMinimumAge._();

  ///Constructor de FactoryMinimumAge
  FactoryMinimumAge._();

  ///FactoryMinimumAge: Devuelve la instancia en ejecucion
  static FactoryMinimumAge getInstance(){
    return _instance;
  }

  @override
  Future<void> builder() async {
    await loadAsset("product_minimum_age.json");

    var value = jsonDecode(super.getJSONString());
    for (var score in value){
      MinimumAge minimumAge = MinimumAge.build(score['ma_id'], score['ma_description']);
      super.getList().add(minimumAge);
    }
  }
  
  @override
  MinimumAge search(int v1, {int? v2, int? v3}) {
    return getList().firstWhere((element) => element.getMinimumAgeID()==v1);
  }
  
  @override
  MinimumAge searchKeyForID(int id) {
    MinimumAge? categoryMySQL;
    
    for (int i=0; i<getList().length && categoryMySQL==null; i++){
      if (getList()[i].getMinimumAgeID()==id){
        categoryMySQL = getList()[i];
      }
    }

    //Control para verificar si se encontró la categoria o no.
    categoryMySQL ??= getList().firstWhere((element) => element.getMinimumAgeID()==0);

    return categoryMySQL;
  }
}