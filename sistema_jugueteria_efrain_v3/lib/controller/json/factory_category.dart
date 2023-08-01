
import 'dart:convert';
import 'package:sistema_jugueteria_efrain_v3/controller/json/mixin_factory_json.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';

///Clase FactoryCategory: Permite construir las posibles categorias que podran ser utilizadas en el sistema.
class FactoryCategory with MixinFactoryJSONDefault<Category, Pair<Category?, SubCategory?>>{
  static final FactoryCategory _instance = FactoryCategory._();

  ///Constructor de FactoryCategory
  FactoryCategory._();

  @override
  Future<void> builder() async {
    await loadAsset("product_categories.json");

    var value = jsonDecode(super.getJSONString());
    for (var score in value['categories']){
      Category cat = Category(score);
      super.getList().add(cat);
    }
  }

  ///FactoryCategory: Devuelve la instancia en ejecucion
  static FactoryCategory getInstance(){
    return _instance;
  }

  @override
  Pair<Category?, SubCategory?> search(int id){
    Pair<Category?, SubCategory?> pair;
    
    if (id==0){
      pair = Pair<Category?, SubCategory?>(v1: getList()[0], v2: getList()[0].getListSubcategory()[0]);
    }
    else{
      String valueStr = (id>999) ? id.toString() : "0${id.toString()}";
      int categoryID = int.parse(valueStr.substring(0,2));
      int subcategoryID = int.parse(valueStr.substring(2, 4));

      Category cat = getList().firstWhere((element) => element.getCategoryID()==categoryID);
      SubCategory subCategory = cat.getListSubcategory().firstWhere((element) => element.getSubCategoryID()==subcategoryID);

      pair = Pair<Category?, SubCategory?>(v1: cat, v2: subCategory);
    }

    return pair;
  }
}