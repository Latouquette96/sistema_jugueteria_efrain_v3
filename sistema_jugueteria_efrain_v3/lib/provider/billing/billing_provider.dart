import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///BillingProvider es un proveedor que sirve para almacenar el estado de una factura de distribuidora que será actualizado o creado.
final billingProvider = StateNotifierProvider<ElementStateProvider<DistributorBilling>, DistributorBilling?>((ref) => ElementStateProvider<DistributorBilling>());

final billingSearchProvider = StateNotifierProvider<ElementStateProvider<DistributorBilling>, DistributorBilling?>((ref) => ElementStateProvider<DistributorBilling>());
