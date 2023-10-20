import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

///Clase DataFragment: Permite modela la relación de un fragmento de texto con aquellos productos que tengan algún dato en dicho fragmento.
class DataFragment {
  //Atributos de instancia
  late final String  _fragment;
  late List<Product> _matchBarcode; //Si se encontró algún producto por código de barra
  //late List<Product> _matchInternalCode; //Productos con un determinado código interno (puede ser mas de uno).
  late List<Product> _matchTitle; //Productos encontrados por el algún fragmento del título.

  ///Constructor de DataFragment
  DataFragment({required String fragment}){
    _fragment = fragment;
    _matchBarcode = [];
    //_matchInternalCode = [];
    _matchTitle = [];
  }

  ///DataFragment: Devuelve el producto que tiene su código de barra en el fragmento de texto (null si no hay tal producto).
  List<Product> getMatchBarcode(){
    return _matchBarcode;
  }

  ///DataFragment: Agrega un producto que tiene su código de barra en el fragmento de texto.
  void insertMatchBarcode(Product p){
    _matchBarcode.add(p);
  }

  ///DataFragment:Remueve todos los productos que tienen alguna palabra de su nombre en el fragmento de texto.
  void removeAllMatchBarcode(){
    _matchBarcode.clear();
  }

  ///DataFragment: Devuelve una lista con los productos que tienen alguna palabra de su nombre en el fragmento de texto.
  /*Iterable<Product> getMatchInternalCode(){
    return _matchInternalCode;
  }

  ///DataFragment: Inserta un producto que tiene su código interno en el fragmento de texto.
  void insertMatchInternalCode(Product p){
    _matchInternalCode.add(p);
  }

  ///DataFragment:Remueve todos los productos que tienen su código interno en el fragmento de texto.
  void removeAllMatchInternalCode(){
    _matchInternalCode.clear();
  }*/

  ///DataFragment: Devuelve una lista con los productos que tienen su código interno en el fragmento de texto.
  Iterable<Product> getMatchTitle(){
    return _matchTitle;
  }

  ///DataFragment: Inserta un producto que tiene alguna palabra de su nombre en el fragmento de texto.
  void insertMatchTitle(Product p){
    _matchTitle.add(p);
  }

  ///DataFragment:Remueve todos los productos que tienen alguna palabra de su nombre en el fragmento de texto.
  void removeAllMatchTitle(){
    _matchTitle.clear();
  }

  ///DataFragment: Devuelve el fragmento de texto.
  String getFragment(){
    return _fragment;
  }

  ///DataFragment: Devuelve true si el DataFragment no tiene productos asociados.
  bool isWithoutProducts(){
    return (_matchBarcode.isEmpty && _matchTitle.isEmpty);
  }
}