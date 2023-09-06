import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';

///Clase ProductSearchProvider: Proveedor de servicios para almacenar el estado de un producto.
class ProductSearchProvider extends StateNotifier<List<Product>> {
  //Atributos de clase
  final StateNotifierProviderRef<ProductSearchProvider, List<Product>> ref;
  final StateNotifierProvider<StateManagerProvider, PlutoGridStateManager?> stateProvider;

  //Constructor de ProductSearchProvider
  ProductSearchProvider(this.ref, this.stateProvider): super([]);

  ///ProductSearchProvider: Inicializa el arreglo de producto.
  Future<void> initialize() async{
    //Limpia el estado actual.
    state = [];
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlAPIProvider);
    //Obtiene la respuesta a la solicitud http.
    try{
      final content = await http.get(Uri.http(url, '/products'));
      List<dynamic> map = jsonDecode(content.body);
      List<Product> list = map.map((e) => Product.fromJSON(e)).toList();
      state = [...list];
      //Notifica al catalogo.
      ref.read(stateProvider)!.insertRows(0, state.map((e) => e.getPlutoRow()).toList());
    }
    catch(e){
      state = [];
    }
  }

  ///ProductSearchProvider: Refrezca el listado de productos.
  Future<void> refresh() async {
    //Limpia el catalogo de todas las filas.
    ref.read(stateProvider)!.removeAllRows();
    //Limpia los productos seleccionados.
    ref.read(productSharingProvider.notifier).clear();
    //Inicializa el catalogo.
    await initialize();
  }

  ///ProductSearchProvider: Inserta un nuevo producto a la lista.
  void insert(Product p){
    state = [...state, p];
  }

  ///ProductSearchProvider: Remueve el producto de la lista.
  void remove(Product p){
    state.remove(p);
  }
}


///productCatalogProvider es un proveedor que almacena la lista de productos.
final productCatalogProvider = StateNotifierProvider<ProductSearchProvider, List<Product>>((ref) => ProductSearchProvider(ref, stateManagerProductProvider));

///productCatalogPDFProvider es un proveedor que almacena la lista de productos.
final productCatalogPDFProvider = StateNotifierProvider<ProductSearchProvider, List<Product>>((ref) => ProductSearchProvider(ref, stateManagerProductPricePDFProvider));