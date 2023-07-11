///Clase Pair<V1, V2>: Modela un par de elementos (V1,V2), donde V2 puede ser o no nulo.
class Pair<V1, V2> {
  //Atributos de instancia
  late V1 _value1;
  late V2? _value2;

  ///Constructor de Pair.
  Pair({required V1 v1, V2? v2}) {
    _value1 = v1;
    _value2 = v2;
  }

  ///Pair: Devuelve el valor 1.
  V1 getValue1() {
    return _value1;
  }

  ///Pair: Establece un nuevo valor 1.
  void setValue1(V1 value) {
    _value1 = value;
  }

  ///Pair: Devuelve el valor 2.
  V2? getValue2() {
    return _value2;
  }

  ///Pair: Establece un nuevo valor 2.
  void setValue2(V2 value) {
    _value2 = value;
  }
}
