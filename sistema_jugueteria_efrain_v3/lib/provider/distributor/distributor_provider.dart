import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';

///Clase DistributorProvider: Proveedor de servicios para almacenar el estado de una distribuidora.
class DistributorProvider extends StateNotifier<Distributor?> {
  DistributorProvider(): super(null);

  ///DistributorProvider: Carga una distribuidora nueva.
  void loadDistributor(Distributor d){
    state = d;
  }

  ///DistributorProvider: Libera la distribuidora actual.
  void freeDistributor(WidgetRef ref){
    state = null;
  }
}

///distributorProvider es un proveedor que sirve para almacenar el estado de una distribuidora que será actualizado o creado.
final distributorProvider = StateNotifierProvider<DistributorProvider, Distributor?>((ref) => DistributorProvider());

///distributorRemoveProvider es un proveedor que sirve para almacenar el estado de una distribuidora que será eliminado.
final distributorRemoveProvider = StateNotifierProvider<DistributorProvider, Distributor?>((ref) => DistributorProvider());

///distributorBillingProvider es un proveedor que sirve para almacenar el estado de una distribuidora que será utilizada para recuperar facturas.
final distributorBillingProvider = StateNotifierProvider<DistributorProvider, Distributor?>((ref) => DistributorProvider());