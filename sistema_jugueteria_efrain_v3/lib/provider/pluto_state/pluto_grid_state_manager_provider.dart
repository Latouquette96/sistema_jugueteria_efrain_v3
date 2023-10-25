import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/mixin_plutonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_row_provider.dart';

final stateManagerProvider = StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>(
    (ref) => PlutoGridStateManagerProvider(ref)
);

final stateManagerProductProvider = StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>(
    (ref) => PlutoGridStateManagerProvider(ref)
);

final stateManagerDistributorProvider = StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>(
    (ref) => PlutoGridStateManagerProvider(ref)
);

final stateManagerProductPricePDFProvider = StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>(
    (ref) => PlutoGridStateManagerProvider(ref)
);

final stateManagerProductMySQLProvider = StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>(
    (ref) => PlutoGridStateManagerProvider(ref)
);

final stateManagerDistributorMySQLProvider = StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>(
        (ref) => PlutoGridStateManagerProvider(ref)
);

///Clase PlutoGridStateManagerProvider: Proveedor de estado de PlutoGridStateManager.
class PlutoGridStateManagerProvider extends StateNotifier<PlutoGridStateManager?> {
  final StateNotifierProviderRef<PlutoGridStateManagerProvider, PlutoGridStateManager?> ref;

  //Constructor de PlutoGridStateManagerProvider.
  PlutoGridStateManagerProvider(this.ref) : super(null);

  ///PlutoGridStateManagerProvider: Carga un PlutoGridStateManager como estado.
  load(PlutoGridStateManager p) {
    state = p;
    state!.setShowColumnFilter(true);
  }

  ///PlutoGridStateManagerProvider: Muestra/oculta el filtro.
  void toggleShowColumnFilter() {
    state!.setShowColumnFilter(!state!.showColumnFilter);
  }

  ///PlutoGridStateManagerProvider: Comprueba si el filtro se está mostrando o no.
  bool isShowColumnFilter(){
    return (state==null) ? false : state!.showColumnFilter;
  }

  ///PlutoGridStateManagerProvider: Inserta un elemento al PlutoGridStateManager
  void insert(StateNotifierProvider<StateNotifier<MixinPlutonizable?>, MixinPlutonizable?> elementProvider){
    state!.insertRows(0, [ref.read(elementProvider)!.buildPlutoRow()!]);
  } 

  ///PlutoGridStateManagerProvider: Actualiza una fila del PlutoGridStateManager de acuerdo al elemento.
  void update(StateNotifierProvider<StateNotifier<MixinPlutonizable?>, MixinPlutonizable?>  elementProvider){
    //Recupero la posición del registro del producto.
    int index = state!.rows.indexOf(ref.read(plutoRowProvider)!);
    //Si está dentro del arreglo.
    if (index>-1){
      //Reemplaza el registro por el actualizado.
      state!.refRows.setAll(index, [ref.read(elementProvider)!.buildPlutoRow()!]);
    }
  }
}
