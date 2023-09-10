import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///productProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final productProvider = StateNotifierProvider<ElementStateProvider<Product>, Product?>((ref) => ElementStateProvider<Product>());

///productRemoveProvider es un proveedor que sirve para almacenar el estado de un producto que será eliminado.
final productRemoveProvider = StateNotifierProvider<ElementStateProvider<Product>, Product?>((ref) => ElementStateProvider<Product>());

///productBillingProvider es un proveedor que sirve para almacenar el estado de un producto que será utilizada para recuperar facturas.
final productBillingProvider = StateNotifierProvider<ElementStateProvider<Product>, Product?>((ref) => ElementStateProvider<Product>());

///productSearchPriceProvider es un proveedor que sirve para almacenar el estado de un producto que será utilizada para recuperar facturas.
final productSearchPriceProvider = StateNotifierProvider<ElementStateProvider<Product>, Product?>((ref) => ElementStateProvider<Product>());

///productSearchPDFPriceProvider es un proveedor que sirve para almacenar el estado de un producto que será utilizada para recuperar facturas.
final productSearchPDFPriceProvider = StateNotifierProvider<ElementStateProvider<Product>, Product?>((ref) => ElementStateProvider<Product>());