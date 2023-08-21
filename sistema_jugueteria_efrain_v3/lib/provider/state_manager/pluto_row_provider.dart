import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';

///Clase PlutoRowProvider: Proveedor de servicios para almacenar el estado de un PlutoRow.
class PlutoRowProvider extends StateNotifier<PlutoRow?> {
  PlutoRowProvider(): super(null);

  ///PlutoRowProvider: Carga un PlutoRow nuevo.
  void load(PlutoRow d){
    state = d;
  }

  ///PlutoRowProvider: Libera el PlutoRow actual.
  void free(){
    state = null;
  }  
}

///productProvider es un proveedor que sirve para almacenar el estado de un PlutoRow que será actualizado o creado.
final plutoRowProvider = StateNotifierProvider<PlutoRowProvider, PlutoRow?>((ref) => PlutoRowProvider());
