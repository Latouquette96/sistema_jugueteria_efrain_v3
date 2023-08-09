import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';

///Clase ProductPriceProvider: Proveedor de servicios para almacenar el estado de un producto.
class ProductPriceProvider extends StateNotifier<ProductPrice?> {
  ProductPriceProvider(): super(null);

  ///ProductPriceProvider: Carga un precio de producto nuevo.
  void load(ProductPrice pp){
    state = pp;
  }

  ///ProductPriceProvider: Libera el precio producto actual.
  void free(WidgetRef ref){
    state = null;
  }
}

///productPriceProvider es un proveedor que sirve para almacenar el estado de un precio de producto que será actualizado o creado.
final productPriceProvider = StateNotifierProvider<ProductPriceProvider, ProductPrice?>((ref) => ProductPriceProvider());

///productPriceRemoveProvider es un proveedor que sirve para almacenar el estado de un precio de producto que será eliminado.
final productPriceRemoveProvider = StateNotifierProvider<ProductPriceProvider, ProductPrice?>((ref) => ProductPriceProvider());