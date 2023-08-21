import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';

final stateManagerProductProvider = StateNotifierProvider<StateManagerProductProvider, PlutoGridStateManager?>(
    (ref) => StateManagerProductProvider()
);

///Clase ProductProvider: Proveedor de estado de Producto.
class StateManagerProductProvider extends StateNotifier<PlutoGridStateManager?> {
  //Constructor de ProductProvider.
  StateManagerProductProvider() : super(null);

  ///ProductProvider: Carga un producto existente como estado.
  load(PlutoGridStateManager p) {
    state = p;
  }

  void insert(){

  }

  void update(){

  }

  void remove(){
    
  }
}
