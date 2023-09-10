import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/catalog_plutonizable_state_notifier.dart';

///Clase CatalogProductProvider: Proveedor de servicios para almacenar una lista de Productos.
class CatalogProductProvider extends CatalogPlutonizableStateNotifier<Product> {
  //Atributos de clase
  final StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?> stateProvider;

  //Constructor de CatalogProductProvider
  CatalogProductProvider(StateNotifierProviderRef ref, this.stateProvider): 
    super(
      [], 
      ref: ref, 
      path: "/products", 
      stateProvider: stateProvider,
      buildElement: (List<dynamic> list){
        return list.map((e) => Product.fromJSON(e)).toList();
      }
    );
}

///productCatalogProvider es un proveedor que almacena la lista de productos.
final productCatalogProvider = StateNotifierProvider<CatalogProductProvider, List<Product>>((ref) => CatalogProductProvider(ref, stateManagerProductProvider));

///productCatalogPDFProvider es un proveedor que almacena la lista de productos.
final productCatalogPDFProvider = StateNotifierProvider<CatalogProductProvider, List<Product>>((ref) => CatalogProductProvider(ref, stateManagerProductPricePDFProvider));