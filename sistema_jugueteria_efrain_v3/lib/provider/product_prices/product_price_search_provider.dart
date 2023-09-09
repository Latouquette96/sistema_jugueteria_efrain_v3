import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';

///Clase ProductPriceSearchProvider: Proveedor de servicios para almacenar el estado de un producto.
class ProductPriceSearchProvider extends StateNotifier<List<Pair<Distributor, ProductPrice>>> {
  //Atributos de clase
  final StateNotifierProviderRef<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> ref;
  final StateNotifierProvider<ProductProvider, Product?> providerSearch;


  //Constructor de ProductPriceSearchProvider
  ProductPriceSearchProvider(this.ref, this.providerSearch): super([]);

  ///ProductPriceSearchProvider: Inicializa el arreglo de precios del producto.
  Future<void> initialize() async{
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlLoginProvider);
    //Obtiene la respuesta a la solicitud http.
    try{
      //Producto sobre el cual se busca los precios de producto.
      final product = ref.watch(providerSearch);

      //Obtiene todas las distribuidoras existentes.
      List<Distributor> listDistributor = (await ref.read(catalogDistributorProvider));

      //Obtiene todos los precios de producto
      //Peticion GET para obtener los precios de producto.
      final content = await http.get(Uri.http(url, '/products/prices_products/${product!.getID()}'));
      List<dynamic> map = jsonDecode(content.body);
      List<ProductPrice> list = map.map((e) => ProductPrice.fromJSON(e)).toList();

      //Computa ambas listas (ditribuidora y precios en una sola)
      List<Pair<Distributor, ProductPrice>> listProduct = list.map((e){
        Distributor d = listDistributor.firstWhere((element) => element.getID()==e.getDistributor());
          return Pair(v1: d, v2: e);
        }).toList();
        
      //Establece las distribuidoras libres para un determinado producto.
      ref.read(distributorFreeProductPriceProvider.notifier).load(listDistributor, listProduct);

      state = listProduct;
    }
    catch(e){
      if (mounted){
        state = [];
      }
    }
  }

  ///ProductPriceSearchProvider: Refrezca el listado de precios del producto.
  Future<void> refresh() async {
    state.clear();
    await initialize();
  }
}

///productPricesByIDProvider es un proveedor que almacena la lista de productos.
final productPricesByIDProvider = StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>>((ref) => ProductPriceSearchProvider(ref, productSearchPriceProvider));

///productPricesPDFByIDProvider es un proveedor que almacena la lista de productos.
final productPricesPDFByIDProvider = StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>>((ref) => ProductPriceSearchProvider(ref, productSearchPDFPriceProvider));