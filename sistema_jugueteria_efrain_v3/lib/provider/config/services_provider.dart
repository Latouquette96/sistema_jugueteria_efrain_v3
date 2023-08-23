import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_search_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_search_provider.dart';

final serviceProvider = Provider<ServiceProvider>((ref) => ServiceProvider(ref));

///Clase ServiceProvider: Modela las service del sistema empleando un SharedPreferences para almacenar los datos.
class ServiceProvider {

  final ProviderRef<ServiceProvider> ref;

  ///Constructor de ServiceProvider.
  ServiceProvider(this.ref): super();

  ///ServiceProvider: Inicializa las service del sistema.
  Future<void> run() async {
    //Inicializa los servicios.
    await ref.watch(productCatalogProvider.notifier).initialize();
    await ref.watch(productCatalogPDFProvider.notifier).initialize();
    await ref.watch(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    await ref.watch(distributorCatalogProvider.notifier).refresh();
  }

  ///ServiceProvider: Detiene todos los servicios ene ejcución.
  void stop() {
    //Inicializa los servicios.
    ref.watch(productCatalogPDFProvider.notifier).dispose();
    ref.watch(productCatalogProvider.notifier).dispose();
    ref.watch(filterOfLoadedBrandsWithAPIProvider.notifier).dispose();
    ref.watch(distributorCatalogProvider.notifier).dispose();
  }
}