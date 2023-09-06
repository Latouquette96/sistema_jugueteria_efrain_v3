import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase ProductProvider: Proveedor de servicios para almacenar el estado de un producto.
class FilterBrandsProvider extends StateNotifier<List<String>> {
  ///Atributos de instancia
  final String url;

  FilterBrandsProvider(this.url): super([]);

  ///FilterBrandsProvider: Recarga la lista de marcas/importadoras utilizadas por los productos.
  Future<void> refresh() async{
    //Si hay elementos, entonces se remueven todos.
    if (state.isNotEmpty){
      state.clear();
    }

    final content = await http.get(Uri.http(url, '/filter/brands'));
    //Convierte los datos obtenidos en una lista de objetos json (mapeos).
    List<dynamic> map = jsonDecode(content.body);
    //Para cada elemento del mapeo, se lo inserta en la lista.
    for (var e in map) {
      state.add(e['p_brand'].toString());
     }
    

    if (!state.contains(Product.getBrandDefect())){
      state.add(Product.getBrandDefect());
    }
  }
  
}

///filterOfLoadedBrandsWithAPIProvider es un proveedor que permite mantener actualizado el listado de marcas de productos utilizadas.
final filterOfLoadedBrandsWithAPIProvider = StateNotifierProvider<FilterBrandsProvider, List<String>>((ref) => FilterBrandsProvider(ref.watch(urlAPIProvider)));