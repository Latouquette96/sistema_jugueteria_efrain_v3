import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///productPriceProvider es un proveedor que sirve para almacenar el estado de un precio de producto que será actualizado o creado.
final productPriceProvider = StateNotifierProvider<ElementStateProvider<ProductPrice>, ProductPrice?>((ref) => ElementStateProvider<ProductPrice>());

///productPriceRemoveProvider es un proveedor que sirve para almacenar el estado de un precio de producto que será eliminado.
final productPriceRemoveProvider = StateNotifierProvider<ElementStateProvider<ProductPrice>, ProductPrice?>((ref) => ElementStateProvider<ProductPrice>());