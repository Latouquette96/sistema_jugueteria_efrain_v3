import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_distributor.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/distributor_free_product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase ProductPriceSearchProvider: Proveedor de servicios para almacenar el estado de un producto.
class ProductPriceSearchProvider extends StateNotifier<List<Pair<Distributor, ProductPrice>>> {
  //Atributos de clase
  final StateNotifierProviderRef<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>> ref;
  final StateNotifierProvider<ElementStateProvider<Product>, Product?> providerSearch;

  ///Constructor de ProductPriceSearchProvider
  ProductPriceSearchProvider(this.ref, this.providerSearch): super([]);

  ///ProductPriceSearchProvider: Inicializa el arreglo de precios del producto.
  Future<ResponseAPI> initialize() async{
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlAPIProvider);
    ResponseAPI content;
    
    //Obtiene la respuesta a la solicitud http.
    try{
      //Producto sobre el cual se busca los precios de producto.
      final product = ref.watch(providerSearch);

      //Obtiene todas las distribuidoras existentes.
      List<Distributor> listDistributor = StateManagerDistributor.getInstance().getElements();
      List<Pair<Distributor, ProductPrice>> listProduct = [];

      //Obtiene todos los precios de producto
      //Peticion GET para obtener los precios de producto.
      content = await APICall.get(url: url, route: '/products/prices_products/${product!.getID()}');

      if (content.isResponseSuccess()){
        List<dynamic> map = content.getValue();
        List<ProductPrice> list = map.map((e) => ProductPrice.fromJSON(e)).toList();

        //Computa ambas listas (ditribuidora y precios en una sola)
        listProduct = list.map((e){
          Distributor d = listDistributor.firstWhere((element) => element.getID()==e.getDistributor());
          return Pair(v1: d, v2: e);
        }).toList();

        //Establece las distribuidoras libres para un determinado producto.
        ref.read(distributorFreeProductPriceProvider.notifier).load(listDistributor, listProduct);
      }

      state = listProduct;
    }
    catch(e){
      if (mounted){
        state = [];
      }
      content = ResponseAPI.manual(status: 404, value: null, title: "Error 404", message: "Error: No fue posible recuperar los precios del producto.");
    }

    return content;
  }

  ///ProductPriceSearchProvider: Refrezca el listado de precios del producto.
  Future<ResponseAPI> refresh() async {
    state.clear();
    return await initialize();
  }
}

///productPricesByIDProvider es un proveedor que almacena la lista de productos.
final productPricesByIDProvider = StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>>((ref) => ProductPriceSearchProvider(ref, productProvider));

///productPricesPDFByIDProvider es un proveedor que almacena la lista de productos.
final productPricesPDFByIDProvider = StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>>((ref) => ProductPriceSearchProvider(ref, productSearchPDFPriceProvider));

///productPricesPDFByIDProvider es un proveedor que almacena la lista de productos.
final productPricesExtractTextPDFProvider = StateNotifierProvider<ProductPriceSearchProvider, List<Pair<Distributor, ProductPrice>>>((ref) => ProductPriceSearchProvider(ref, productExtractTextProvider));