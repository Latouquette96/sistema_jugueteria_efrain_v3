///Clase SubCategoryMySQL: Sirve como contenedor temporal de la información obtenida del archivo JSON.
class SubCategoryMySQL {
  late int _subcatId;
  late String _subcatName;

  ///Constructor de SubCategoryMySQL
  SubCategoryMySQL({required Map<String, dynamic> values}){
    _subcatId = values['sub_id'];
    _subcatName = values['sub_name'];
  }

  SubCategoryMySQL.clean(){
    _subcatId = 0;
    _subcatName = "";
  }

  ///SubCategoryMySQL: Devuelve el ID de la subcategoria.
  int getSubCategoryMySQLID(){
    return _subcatId;
  }

  ///SubCategoryMySQL: Devuelve el nombre de la subcategoria.
  String getSubCategoryMySQLName(){
    return _subcatName;
  }
}