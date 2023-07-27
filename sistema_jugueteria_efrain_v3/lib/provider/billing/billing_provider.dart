import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';

///Clase BillingProvider: Proveedor de servicios para almacenar el estado de una distribuidora.
class BillingProvider extends StateNotifier<DistributorBilling?> {
  BillingProvider(): super(null);

  ///BillingProvider: Carga una factura nueva.
  void loadBilling(DistributorBilling d){
    state = d;
  }

  ///BillingProvider: Libera la factura actual.
  void freeBilling(){
    state = null;
  }
}

///BillingProvider es un proveedor que sirve para almacenar el estado de una factura de distribuidora que será actualizado o creado.
final billingProvider = StateNotifierProvider<BillingProvider, DistributorBilling?>((ref) => BillingProvider());

final billingSearchProvider = StateNotifierProvider<BillingProvider, DistributorBilling?>((ref) => BillingProvider());
