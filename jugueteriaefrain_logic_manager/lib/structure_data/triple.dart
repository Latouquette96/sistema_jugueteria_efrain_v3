import 'package:jugueteriaefrain_logic_manager/structure_data/pair.dart';

///Clase Triple: Modela una tripla de elementos (V1, V2, V3), donde V2 y V3 pueden ser valores nulos.
class Triple<V1, V2, V3> extends Pair<V1, V2> {
  //Atributos de instancia
  late V3? _value3;

  Triple({required super.v1, super.v2, V3? v3}) {
    _value3 = v3;
  }

  ///Pair: Devuelve el valor 3.
  V3? getValue3() {
    return _value3;
  }

  ///Pair: Establece un nuevo valor 3.
  void setValue3(V3 value) {
    _value3 = value;
  }
}
