
import 'dart:convert';
import 'package:sistema_jugueteria_efrain_v3/controller/json/mixin_factory_json.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';

///Clase FactoryCategory: Permite construir las posibles categorias que podran ser utilizadas en el sistema.
class FactoryCategory with MixinFactoryJSONDefault<Category, Pair<Category?, SubCategory?>>{
  //Atributos de instancia
  late final String _resource;

  static final FactoryCategory _instance = FactoryCategory._("product_categories.json");
  
  ///Constructor de FactoryCategory
  FactoryCategory._(String resource){
    _resource = resource;
  }

  @override
  Future<void> builder() async {
    await loadAsset(_resource);

    var value = jsonDecode(super.getJSONString());
    for (var score in value){
      Category cat = Category(score);
      super.getList().add(cat);
    }
  }

  ///FactoryCategory: Devuelve la instancia en ejecucion
  static FactoryCategory getInstance(){
    return _instance;
  }

  @override
  Pair<Category?, SubCategory?> search(int v1, {int? v2, int? v3}){
    Pair<Category?, SubCategory?> pair;
    
    if (v1==0){
      pair = Pair<Category?, SubCategory?>(v1: getList()[0], v2: getList()[0].getListSubcategory()[0]);
    }
    else{
      String valueStr = (v1>999) ? v1.toString() : "0${v1.toString()}";
      int categoryID = int.parse(valueStr.substring(0,2));
      int subcategoryID = int.parse(valueStr.substring(2, 4));

      Category cat = getList().firstWhere((element) => element.getCategoryID()==categoryID);
      SubCategory subCategory = cat.getListSubcategory().firstWhere((element) => element.getSubCategoryID()==subcategoryID);

      pair = Pair<Category?, SubCategory?>(v1: cat, v2: subCategory);
    }

    return pair;
  }

  Category getCategory(int id){
    return getList().firstWhere((element) => element.getCategoryID().compareTo(id)==0, orElse: () => getList().firstWhere((element1) => element1.getCategoryID()==0));
  }
  
  @override
  Category searchKeyForID(int id) {
    Category? category;
    
    for (int i=0; i<getList().length && category==null; i++){
      if (getList()[i].getCategoryID()==id){
        category = getList()[i];
      }
    }

    //Control para verificar si se encontró la categoria o no.
    category ??= getList().firstWhere((element) => element.getCategoryID()==0);

    return category;
  }
}