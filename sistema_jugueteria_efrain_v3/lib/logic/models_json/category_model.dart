
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/subcategory_model.dart';

///Clase Category: Sirve como contenedor temporal de la información obtenida del archivo JSON.
class Category {
  late int _catId;
  late String _catName;
  late List<SubCategory> _catSubcategory;

  ///Constructor de Category
  Category(Map<String, dynamic> values){
    _catId = values['cat_id'];
    _catName = values['cat_name'];
    _catSubcategory = [];

    for (var subcat in values['cat_subcat']){
      _catSubcategory.add(SubCategory(values: subcat));
    }
  }

  ///Category: Devuelve el ID de la categoria.
  int getCategoryID(){
    return _catId;
  }

  ///Category: Devuelve el nombre de la categoria.
  String getCategoryName(){
    return _catName;
  }

  List<SubCategory> getListSubcategory() {
    return _catSubcategory;
  }
}