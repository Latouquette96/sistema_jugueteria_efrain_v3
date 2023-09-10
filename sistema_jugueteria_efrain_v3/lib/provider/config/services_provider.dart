import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///serviceProvider: Provider que permite controlar los servicios.
final serviceProvider = StateNotifierProvider<ElementStateProvider<ServiceProvider>, ServiceProvider?>(
    (ref) => ElementStateProvider<ServiceProvider>.initialize(ServiceProvider(ref))
);

///Clase ServiceProvider: Modela las service del sistema empleando un SharedPreferences para almacenar los datos.
class ServiceProvider {

  final StateNotifierProviderRef<ElementStateProvider<ServiceProvider>, ServiceProvider?> ref;

  ///Constructor de ServiceProvider.
  ServiceProvider(this.ref): super();

  ///ServiceProvider: Inicializa las service del sistema.
  Future<void> run() async {
    try{
      //Inicializa los servicios.
      await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
      await ref.read(productCatalogProvider.notifier).initialize();
      await ref.read(productCatalogPDFProvider.notifier).initialize();
      await ref.read(catalogDistributorProvider.notifier).initialize();
      await ref.read(catalogDistributorProvider.notifier).refresh();
      await ref.read(importProductMySQLProvider.notifier).initialize();
    }
    catch(e){}
  }

  ///ServiceProvider: Detiene todos los servicios ene ejcución.
  void stop() {
    //Inicializa los servicios.
    ref.watch(productCatalogPDFProvider.notifier).dispose();
    ref.watch(productCatalogProvider.notifier).dispose();
    ref.watch(filterOfLoadedBrandsWithAPIProvider.notifier).dispose();
    ref.watch(catalogDistributorProvider.notifier).dispose();
  }
}