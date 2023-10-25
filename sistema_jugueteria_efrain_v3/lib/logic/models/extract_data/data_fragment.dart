///Clase DataFragment: Permite modela la relación de un fragmento de texto con aquellos productos que tengan algún dato en dicho fragmento.
class DataFragment {
  //Atributos de instancia
  late final String  _fragment;

  ///Constructor de DataFragment
  DataFragment({required String fragment}){
    _fragment = fragment;
  }

  ///DataFragment: Devuelve el fragmento de texto.
  String getFragment(){
    return _fragment;
  }

  ///DataFragment: Devuelve true si contiene a str.
  bool isContains(String str){
    return _fragment.contains(str);
  }
}