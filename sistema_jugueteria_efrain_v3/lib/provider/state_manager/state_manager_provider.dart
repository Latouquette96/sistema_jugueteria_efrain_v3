import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_plutonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_row_provider.dart';

final stateManagerProvider = StateNotifierProvider<StateManagerProvider, PlutoGridStateManager?>(
    (ref) => StateManagerProvider(ref)
);

final stateManagerProductProvider = StateNotifierProvider<StateManagerProvider, PlutoGridStateManager?>(
    (ref) => StateManagerProvider(ref)
);

final stateManagerDistributorProvider = StateNotifierProvider<StateManagerProvider, PlutoGridStateManager?>(
    (ref) => StateManagerProvider(ref)
);


///Clase StateManagerProvider: Proveedor de estado de StateManager.
class StateManagerProvider extends StateNotifier<PlutoGridStateManager?> {
  final StateNotifierProviderRef<StateManagerProvider, PlutoGridStateManager?> ref;

  //Constructor de StateManagerProvider.
  StateManagerProvider(this.ref) : super(null);

  ///StateManagerProvider: Carga un producto existente como estado.
  load(PlutoGridStateManager p) {
    state = p;
  }

  void insert(StateNotifierProvider<StateNotifier<MixinPlutonizable?>, MixinPlutonizable?> provider){
    state!.insertRows(0, [ref.read(provider)!.buildPlutoRow()]);
  }

  void update(StateNotifierProvider<StateNotifier<MixinPlutonizable?>, MixinPlutonizable?>  provider){
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
