import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

/*
 * Los siguientes providers permiten almacenar a lo sumo una Distribuidora.
 * Puede estar o no vacio dichos contenedores.
 */

///distributorStateProvider es un proveedor que sirve para almacenar el estado de una distribuidora que será actualizado o creado.
final distributorStateProvider = StateNotifierProvider<ElementStateProvider<Distributor>, Distributor?>((ref) => ElementStateProvider());

///distributorRemoveProvider es un proveedor que sirve para almacenar el estado de una distribuidora que será eliminado.
final distributorStateRemoveProvider = StateNotifierProvider<ElementStateProvider<Distributor>, Distributor?>((ref) => ElementStateProvider());

///distributorBillingProvider es un proveedor que sirve para almacenar el estado de una distribuidora que será utilizada para recuperar facturas.
final distributorStateBillingProvider = StateNotifierProvider<ElementStateProvider<Distributor>, Distributor?>((ref) => ElementStateProvider());