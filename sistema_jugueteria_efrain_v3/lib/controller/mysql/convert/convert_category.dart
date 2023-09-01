import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/factory/factory_category_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/category_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/subcategory_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/category_util.dart';

///Clase ConvertCategory: Permite realizar conversiones de una CategoryMySQL a Category.
class ConvertCategory {

  ///ConvertCategory: Devuelve el ID de categoria.
  ///
  ///[categoryID] Identificador de categoria MySQL.
  ///[subcategoryID] Identificador de subcategoria MySQL.
  static int getIDCategory(int categoryID, int subcategoryID){
    //Recupera la instancia de cada fábrica de categorias.
    FactoryCategory factoryCategory = FactoryCategory.getInstance();
    FactoryCategoryMySQL factoryCategoryMySQL = FactoryCategoryMySQL.getInstance();
      
    CategoryMySQL categoryMySQL = factoryCategoryMySQL.searchKeyForID(categoryID);
    SubCategoryMySQL subCategoryMySQL = categoryMySQL.getListSubCategoryMySQL().firstWhere(
      (element) => element.getID()==subcategoryID,
      orElse: () => categoryMySQL.getListSubCategoryMySQL().first, 
    );

    Category category = factoryCategory.searchKeyForID(categoryMySQL.getCategoryMySQLNewID());
    SubCategory subCategory = category.getListSubcategory().firstWhere(
      (element) => element.getSubCategoryIDGoogle()==subCategoryMySQL.getNewID(),
      orElse: () => category.getListSubcategory().first,
    );
    
    return CategoryUtil.getFinalID(category.getCategoryID(), subCategory.getSubCategoryID());
  }
}