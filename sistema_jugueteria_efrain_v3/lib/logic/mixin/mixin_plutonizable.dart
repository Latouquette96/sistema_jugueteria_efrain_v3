import 'package:pluto_grid/pluto_grid.dart';

///mixin MixinPlutonizable: Operaciones para construir un PlutoRow de un modelo de datos
mixin MixinPlutonizable {
  //Atributos de instancia
  late PlutoRow? plutoRow;
  final String _keyOptions = "key_options";

  ///MixinPlutonizable: Devuelve la clave para los botones de opción.
  String getKeyOptions(){
    return _keyOptions;
  }

  ///MixinPlutonizable: Construye un nuevo objeto PlutoRow.
  PlutoRow buildPlutoRow();

  ///MixinPlutonizable: Devuelve el objeto PlutoRow.
  PlutoRow getPlutoRow(){
    plutoRow ??= buildPlutoRow();
    return plutoRow!;
  }
}