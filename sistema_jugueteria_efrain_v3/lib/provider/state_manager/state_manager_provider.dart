import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_row_provider.dart';

final stateManagerProductProvider = StateNotifierProvider<StateManagerProductProvider, PlutoGridStateManager?>(
    (ref) => StateManagerProductProvider(ref)
);

///Clase ProductProvider: Proveedor de estado de Producto.
class StateManagerProductProvider extends StateNotifier<PlutoGridStateManager?> {
  final StateNotifierProviderRef<StateManagerProductProvider, PlutoGridStateManager?> ref;

  //Constructor de ProductProvider.
  StateManagerProductProvider(this.ref) : super(null);

  ///ProductProvider: Carga un producto existente como estado.
  load(PlutoGridStateManager p) {
    state = p;
  }

  void insert(StateNotifierProvider<ProductProvider, Product?> provider){
    state!.insertRows(0, [ref.read(provider)!.buildPlutoRow()]);
  }

  void update(StateNotifierProvider<ProductProvider, Product?> provider){
    //Recupero la posición del registro del producto.
    int index = state!.rows.indexOf(ref.read(plutoRowProvider)!);
    //Si está dentro del arreglo.
    if (index>-1){
      //Reemplaza el registro por el actualizado.
      state!.refRows.setAll(index, [ref.read(provider)!.buildPlutoRow()]);
    }
  }

  void remove(){

  }
}
