import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';

///Clase CategoryUtil: Utilidades para el manejo de las categorias.
class CategoryUtil {

  ///CategoryUtil: Devuelve el ID de categoria.
  ///
  ///[category] Identificador de categoria.
  ///[subcategory] Identificador de subcategoria.
  static int getFinalID(int category, int subcategory){
    return category*100 + subcategory;
  }

  ///CategoryUtil: Decodifica el ID de categoria y devuelve un Pair con el identificador de categoria y subcategoria.
  ///
  ///[categoryID] Identificador de categoria.
  static Pair<int, int> getDecodeID(int categoryID){
    String value = categoryID.toString();
    String catID = value.substring(0,2);
    String subcatID = value.substring(2, 4);

    return Pair<int,int>(v1: int.parse(catID), v2: int.parse(subcatID));
  }

}