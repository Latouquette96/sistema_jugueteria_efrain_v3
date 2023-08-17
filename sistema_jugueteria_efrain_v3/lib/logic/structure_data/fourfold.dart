import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';

class Fourfold<V1, V2, V3, V4> extends Triple<V1, V2, V3> {
  //Atributos de instancia
  late V4? _value4;

  ///Constructor de Fourfold.
  Fourfold({required super.v1, required super.v2, required super.v3, V4? v4}){
    _value4 = v4;
  }

  ///Fourfold: Devuelve el valor 4.
  V4? getValue4(){
    return _value4;
  }

  ///Fourfold: Establece el valor 4.
  void setValue4(V4 value){
    _value4 = value;
  }
}