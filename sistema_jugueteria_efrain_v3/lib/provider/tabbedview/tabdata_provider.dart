import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabbed_view/tabbed_view.dart';

///Clase TabDataProvider: Permite almacenar un TabData en el provider.
class TabDataProvider extends StateNotifier<TabData?>{
  TabDataProvider() : super(null);

  ///TabDataProvider: Construye y almacena un TabData.
  void load(TabData tab){
    state = tab;
  }

  ///TabDataProvider: Vacia el estado del provider.
  void clear(){
    state = null;
  }
}

final tabProductCatalogProvider = StateNotifierProvider<TabDataProvider, TabData?>((ref) => TabDataProvider());

final tabProductCatalogPDFProvider = StateNotifierProvider<TabDataProvider, TabData?>((ref) => TabDataProvider());

final tabDistributorCatalogProvider = StateNotifierProvider<TabDataProvider, TabData?>((ref) => TabDataProvider());

final tabDistributorBillingCatalogProvider = StateNotifierProvider<TabDataProvider, TabData?>((ref) => TabDataProvider());

final tabConfigurationProvider = StateNotifierProvider<TabDataProvider, TabData?>((ref) => TabDataProvider());

final tabImportMySQLCatalog = StateNotifierProvider<TabDataProvider, TabData?>((ref) => TabDataProvider());