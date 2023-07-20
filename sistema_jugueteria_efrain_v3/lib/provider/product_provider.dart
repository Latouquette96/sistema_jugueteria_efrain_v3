import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

final productProvider = StateNotifierProvider<ProductProvider, Product?>(
    (ref) => ProductProvider());

///Clase ProductProvider: Proveedor de estado de Producto.
class ProductProvider extends StateNotifier<Product?> {
  //Constructor de ProductProvider.
  ProductProvider() : super(null);

  ///ProductProvider: Carga un producto existente como estado.
  loadProduct(Product p) {
    state = p;
  }

  ///ProductProvider: Construye un nuevo producto.
  newProduct() {
    state = Product.clean();
  }
}
