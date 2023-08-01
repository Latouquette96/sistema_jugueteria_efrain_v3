///Clase SubCategory: Sirve como contenedor temporal de la información obtenida del archivo JSON.
class SubCategory {
  late int _subcatId;
  late String _subcatName;

  ///Constructor de SubCategory
  SubCategory({required Map<String, dynamic> values}){
    _subcatId = values['idcat'];
    _subcatName = values['name'];
  }

  ///SubCategory: Devuelve el ID de la subcategoria.
  int getSubCategoryID(){
    return _subcatId;
  }

  ///SubCategory: Devuelve el nombre de la subcategoria.
  String getSubCategoryName(){
    return _subcatName;
  }
}