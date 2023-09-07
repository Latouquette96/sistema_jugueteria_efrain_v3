import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/mixin_plutonizable.dart';

///JSONalizable: Modela operaciones para leer y crear mapeos de elementos de tipo E.
abstract class JSONalizable<E> with MixinPlutonizable{
  ///JSONalizable: Devuelve un mapeo del estado interno del elemento.
  Map<String, dynamic> getJSON();

  ///JSONalizable: Carga al elemento con el contenido del mapeo.
  void fromJSON(Map<String, dynamic> map);
}
