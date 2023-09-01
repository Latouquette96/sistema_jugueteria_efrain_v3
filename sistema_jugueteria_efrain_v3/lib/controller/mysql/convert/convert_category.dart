import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/factory/factory_category_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/category_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/category_util.dart';

///Clase ConvertCategory: Permite realizar conversiones de una CategoryMySQL a Category.
class ConvertCategory {

  ///ConvertCategory: Devuelve el ID de categoria.
  ///
  ///[category] Identificador de categoria MySQL.
  ///[subcategory] Identificador de subcategoria MySQL.
  static int getIDCategory(int category, int subcategory){
    //Recupera la instancia de cada fábrica de categorias.
    FactoryCategory factoryCategory = FactoryCategory.getInstance();
    FactoryCategoryMySQL factoryCategoryMySQL = FactoryCategoryMySQL.getInstance();
    //Busca la categoria mysql dentro de la fabrica de categorias.
    CategoryMySQL categoryMySQL = factoryCategoryMySQL.getList().firstWhere((element) => element.getCategoryMySQLID()==category);
    //Recupera las correspondientes categoria y subcategoria.
    Category cat = factoryCategory.getList().firstWhere((element) => element.getCategoryID()==categoryMySQL.getCategoryMySQLNewID()); 
    SubCategory subCategory = cat.getListSubcategory().firstWhere((element) => element.getSubCategoryIDGoogle()==subcategory);
    //Devuelve el identificador equivalente en el sistema.
    return CategoryUtil.getFinalID(cat.getCategoryID(), subCategory.getSubCategoryID());
  }
}