///Clase SubCategory: Sirve como contenedor temporal de la información obtenida del archivo JSON.
class SubCategory {
  late int _subcatId;
  late String _subcatName;
  late int _subcatIDGoogle;

  ///Constructor de SubCategory
  SubCategory({required Map<String, dynamic> values}){
    _subcatId = values['sub_id'];
    _subcatName = values['sub_name'] ?? "-";
    _subcatIDGoogle = values['id_google'];
  }

  ///SubCategory: Devuelve el ID de la subcategoria.
  int getSubCategoryID(){
    return _subcatId;
  }

  ///SubCategory: Devuelve el nombre de la subcategoria.
  String getSubCategoryName(){
    return _subcatName;
  }

  ///SubCategory: Devuelve el ID de categoria según Google.
  int getSubCategoryIDGoogle(){
    return _subcatIDGoogle;
  }
}