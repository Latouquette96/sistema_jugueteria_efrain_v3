import 'package:pluto_grid/pluto_grid.dart';

///mixin MixinPlutonizable: Modela la construccion y devolución de un PlutoRow para una clase de elementos genérica.
mixin MixinPlutonizable {
  //Atributos de instancia
  late PlutoRow? plutoRow;
  final String _keyOptions = "key_options";

  ///MixinPlutonizable: Devuelve la clave para los botones de opción.
  String getKeyOptions(){
    return _keyOptions;
  }

  ///MixinPlutonizable: Construye un nuevo objeto PlutoRow.
  PlutoRow? buildPlutoRow();

  ///MixinPlutonizable: Devuelve el objeto PlutoRow.
  PlutoRow getPlutoRow(){
    plutoRow ??= buildPlutoRow();
    return plutoRow!;
  }

  ///MixinPlutonizable: Actualiza las celdas del objeto PlutoRow con los valores del elemento.
  void updatePlutoRow();
}