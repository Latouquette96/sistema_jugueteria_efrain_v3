import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';

String _url = "127.0.0.1:3000";

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para recuperar TODAS los productos existentes.
final catalogProductProvider = FutureProvider<Pair<String, List<Product>>>((ref) async {
  final lastUpdate = ref.watch(lastUpdateProvider.notifier).state;
  final content = await http.get(Uri.http(_url, '/products'));

  List<dynamic> map = jsonDecode(content.body);
  List<Product> list = map.map((e) => Product.fromJSON(e)).toList();
  return Pair<String, List<Product>>(v1: lastUpdate, v2: list);
});


///Proveedor para crear un producto en particular.
final newProductWithAPIProvider = FutureProvider<Response>((ref) async {

  final product = ref.watch(productProvider);

  final response = await http.post(
    Uri.http(_url, '/products'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(product!.getJSON()), 
  );

  return response;  
});

///Proveedor para actualizar un producto en particular.
final updateProductWithAPIProvider = FutureProvider<Response>((ref) async {

  final product = ref.watch(productProvider);

  final response = await http.put(
    Uri.http(_url, '/products/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(product.getJSON()), 
  );

  return response;  
});

///Proveedor para eliminar un producto en particular.
final removeProductWithAPIProvider = FutureProvider<Response>((ref) async {

  final product = ref.watch(productRemoveProvider);

  final response = await http.delete(
    Uri.http(_url, '/products/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  return response;  
});