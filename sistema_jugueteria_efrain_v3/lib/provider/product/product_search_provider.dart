import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager_provider.dart';

///Clase ProductSearchProvider: Proveedor de servicios para almacenar el estado de un producto.
class ProductSearchProvider extends StateNotifier<List<Product>> {
  //Atributos de clase
  final StateNotifierProviderRef<ProductSearchProvider, List<Product>> ref;

  //Constructor de ProductSearchProvider
  ProductSearchProvider(this.ref): super([]);

  ///ProductSearchProvider: Inicializa el arreglo de producto.
  Future<void> initialize() async{
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlLoginProvider);
    //Obtiene la respuesta a la solicitud http.
    try{
      final content = await http.get(Uri.http(url, '/products'));
      List<dynamic> map = jsonDecode(content.body);
      List<Product> list = map.map((e) => Product.fromJSON(e)).toList();
      state = [...list];
      //Notifica al catalogo.
      ref.read(stateManagerProductProvider)!.insertRows(0, state.map((e) => e.getPlutoRow()).toList());
    }
    catch(e){
      state = [];
    }
  }

  ///ProductSearchProvider: Refrezca el listado de productos.
  Future<void> refresh() async {
    //Limpia el catalogo de todas las filas.
    ref.read(stateManagerProductProvider)!.removeAllRows();
    //Limpia el estado actual.
    state = [];
    //Limpia los productos seleccionados.
    ref.read(productSharingProvider.notifier).clear();
    //Inicializa el catalogo.
    await initialize();
  }

  ///ProductSearchProvider: Inserta un nuevo producto a la lista.
  void insert(Product p){
    state = [...state, p];
    //Notifica al catalogo.
    ref.read(stateManagerProductProvider)!.appendRows([p.getPlutoRow()]);
  }

  ///ProductSearchProvider: Remueve el producto de la lista.
  void remove(Product p){
    state.remove(p);
  }
}


///productCatalogProvider es un proveedor que almacena la lista de productos.
final productCatalogProvider = StateNotifierProvider<ProductSearchProvider, List<Product>>((ref) => ProductSearchProvider(ref));