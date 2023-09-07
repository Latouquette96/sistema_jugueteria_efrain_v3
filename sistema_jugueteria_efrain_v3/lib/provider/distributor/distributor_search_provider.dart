import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/catalog_state_notifier.dart';

///Clase CatalogDistributorProvider: Provider para almacenar una lista de Distribuidoras.
class CatalogDistributorProvider extends CatalogStateNotifier<Distributor> {
  //Atributos de clase
  final StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?> stateProvider;

  //Constructor de CatalogDistributorProvider
  CatalogDistributorProvider(StateNotifierProviderRef ref, this.stateProvider): 
    super(
      [], 
      ref: ref, 
      path: "/distributors", 
      stateProvider: stateProvider,
      buildElement: (List<dynamic> list){
        return list.map((e) => Distributor.fromJSON(e)).toList();
      }
    );
}

///distributorCatalogProvider es un proveedor que almacena la lista de distribuidoras.
final distributorCatalogProvider = StateNotifierProvider<CatalogDistributorProvider, List<Distributor>>((ref) => CatalogDistributorProvider(ref, stateManagerDistributorProvider));