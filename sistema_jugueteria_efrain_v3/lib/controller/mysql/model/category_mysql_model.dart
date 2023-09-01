import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/subcategory_mysql_model.dart';

///Clase CategoryMySQL: Sirve como contenedor temporal de la información obtenida del archivo JSON.
class CategoryMySQL {
  late int _catId, _catNewID;
  late String _catName;
  late List<SubCategoryMySQL> _catSubCategoryMySQL;

  ///Constructor de CategoryMySQL
  CategoryMySQL(Map<String, dynamic> values){
    _catNewID = values['id_new'];
    _catId = values['cat_name'];
    _catName = values['cat_id'];
    _catSubCategoryMySQL = [];

    for (var subcat in values['cat_subcat']){
      _catSubCategoryMySQL.add(SubCategoryMySQL(values: subcat));
    }
  }

  ///Constructor de CategoryMySQL
  CategoryMySQL.clean(){
    _catNewID = -1;
    _catId = -1;
    _catName = "";
    _catSubCategoryMySQL = [];
  }

  ///CategoryMySQL: Devuelve el ID de la categoria.
  int getCategoryMySQLID(){
    return _catId;
  }

  ///CategoryMySQL: Devuelve el ID de la categoria nueva (esto es, a la categoria del sistema).
  int getCategoryMySQLNewID(){
    return _catNewID;
  }


  ///CategoryMySQL: Devuelve el nombre de la categoria.
  String getCategoryMySQLName(){
    return _catName;
  }

  List<SubCategoryMySQL> getListSubCategoryMySQL() {
    return _catSubCategoryMySQL;
  }
}