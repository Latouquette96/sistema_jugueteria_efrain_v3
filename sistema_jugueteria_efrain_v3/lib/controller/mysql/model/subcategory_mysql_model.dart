///Clase SubCategoryMySQL: Sirve como contenedor temporal de la información obtenida del archivo JSON.
class SubCategoryMySQL {
  late int _subcatId;
  late int _subNewID;
  late String _subcatName;

  ///Constructor de SubCategoryMySQL
  SubCategoryMySQL({required Map<String, dynamic> values}){
    _subcatId = values['sub_cat'] ?? 0;
    _subcatName = values['sub_name'];
    _subNewID = values['sub_new_id'];
  }

  SubCategoryMySQL.clean(){
    _subcatId = 0;
    _subcatName = "";
  }

  ///SubCategoryMySQL: Devuelve el ID de la subcategoria.
  int getID(){
    return _subcatId;
  }

  ///SubCategoryMySQL: Devuelve el ID de la subcategoria.
  int getNewID(){
    return _subNewID;
  }

  ///SubCategoryMySQL: Devuelve el nombre de la subcategoria.
  String getName(){
    return _subcatName;
  }
}