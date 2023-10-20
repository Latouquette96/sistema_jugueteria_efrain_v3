
import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_comparable.dart';

///Clase MinimumAge: Modela la edad minima recomendada de un producto.
class MinimumAge with MixinComparable<MinimumAge>{

  //Atributos de instancia
  late int _id;
  late String _value;

  ///Constructor de MinimumAge
  MinimumAge(){
    _id = 0;
    _value = "";
  }

  ///Constructor de MinimumAge
  MinimumAge.build(int id, String value){
    _id = id;
    _value = value;
  }

  ///MinimumAge: Devuelve el ID.
  int getMinimumAgeID() {
    return _id;
  }

  ///MinimumAge: Devuelve el valor.
  String getMinimumAgeValue() {
    return _value;
  }

  @override
  bool compare(MinimumAge e1, MinimumAge e2) {
    return e1.getMinimumAgeID()==e2.getMinimumAgeID();
  }

  @override
  String itemAsString() {
    return _value;
  }
}