
import 'dart:convert';
import 'package:sistema_jugueteria_efrain_v3/controller/json/mixin_factory_json.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/category_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/subcategory_mysql_model.dart';

///Clase FactoryCategoryMySQL: Permite construir las posibles categorias que podran ser utilizadas en el sistema.
class FactoryCategoryMySQL with MixinFactoryJSONDefault<CategoryMySQL, SubCategoryMySQL>{
  //Atributos de instancia
  late final String _resource;

  static final FactoryCategoryMySQL _instance = FactoryCategoryMySQL._("mysql_product_categories.json");
  
  ///Constructor de FactoryCategoryMySQL
  FactoryCategoryMySQL._(String resource){
    _resource = resource;
  }

  @override
  Future<void> builder() async {
    await loadAsset(_resource);

    List<dynamic> value = jsonDecode(super.getJSONString());
    for (var score in value){
      CategoryMySQL cat = CategoryMySQL(score);
      super.getList().add(cat);
    }
  }

  ///FactoryCategoryMySQL: Devuelve la instancia en ejecucion
  static FactoryCategoryMySQL getInstance(){
    return _instance;
  }
  
  @override
  SubCategoryMySQL search(int v1, {int? v2, int? v3}) {
    CategoryMySQL cat = getList().firstWhere((element) => element.getCategoryMySQLID()==v1, orElse: () => CategoryMySQL.clean() ,);
    SubCategoryMySQL subcat;

    if (cat.getCategoryMySQLNewID()>-1){
      subcat = cat.getListSubCategoryMySQL().firstWhere((element) => element.getID()==(v2 ?? 0));
    }
    else{
      subcat = SubCategoryMySQL.clean();
    }
    
    return subcat;
  }
  
  @override
  CategoryMySQL searchKeyForID(int id) {
    CategoryMySQL? categoryMySQL;
    
    for (int i=0; i<getList().length && categoryMySQL==null; i++){
      if (getList()[i].getCategoryMySQLID()==id){
        categoryMySQL = getList()[i];
      }
    }

    //Control para verificar si se encontró la categoria o no.
    categoryMySQL ??= getList().firstWhere((element) => element.getCategoryMySQLID()==0);

    return categoryMySQL;
  }
}