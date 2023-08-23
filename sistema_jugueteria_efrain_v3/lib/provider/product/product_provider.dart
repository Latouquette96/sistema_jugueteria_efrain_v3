import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

///Clase ProductProvider: Proveedor de servicios para almacenar el estado de un producto.
class ProductProvider extends StateNotifier<Product?> {
  ProductProvider(): super(null);

  ///ProductProvider: Carga un producto nuevo.
  void load(Product d){
    state = d;
  }

  ///ProductProvider: Libera el producto actual.
  void free(){
    state = null;
  }  
}

///productProvider es un proveedor que sirve para almacenar el estado de un producto que será actualizado o creado.
final productProvider = StateNotifierProvider<ProductProvider, Product?>((ref) => ProductProvider());

///productRemoveProvider es un proveedor que sirve para almacenar el estado de un producto que será eliminado.
final productRemoveProvider = StateNotifierProvider<ProductProvider, Product?>((ref) => ProductProvider());

///productBillingProvider es un proveedor que sirve para almacenar el estado de un producto que será utilizada para recuperar facturas.
final productBillingProvider = StateNotifierProvider<ProductProvider, Product?>((ref) => ProductProvider());

///productSearchPriceProvider es un proveedor que sirve para almacenar el estado de un producto que será utilizada para recuperar facturas.
final productSearchPriceProvider = StateNotifierProvider<ProductProvider, Product?>((ref) => ProductProvider());

///productSearchPDFPriceProvider es un proveedor que sirve para almacenar el estado de un producto que será utilizada para recuperar facturas.
final productSearchPDFPriceProvider = StateNotifierProvider<ProductProvider, Product?>((ref) => ProductProvider());