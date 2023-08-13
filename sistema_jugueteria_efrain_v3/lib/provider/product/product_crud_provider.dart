import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_search_provider.dart';

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para crear un producto en particular.
final newProductWithAPIProvider = FutureProvider<Response>((ref) async {

  final product = ref.watch(productProvider);
  final url = ref.watch(urlLoginProvider);

  //Realiza la petición POST para insertar el producto.
  final response = await http.post(
    Uri.http(url, '/products'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(product!.getJSON()), 
  );

  //Refrezca las marcas cargadas.
  await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
  //Refrezca el catalogo de productos.
  await ref.read(productCatalogProvider.notifier).refresh();

  return response;  
});

///Proveedor para actualizar un producto en particular.
final updateProductWithAPIProvider = FutureProvider<Response>((ref) async {

  final product = ref.watch(productProvider);
  final url = ref.watch(urlLoginProvider);

  final response = await http.put(
    Uri.http(url, '/products/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(product.getJSON()), 
  );

  //Refrezca las marcas cargadas.
  await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
  //Refrezca el catalogo de productos.
  await ref.read(productCatalogProvider.notifier).refresh();

  return response;  
});

///Proveedor para eliminar un producto en particular.
final removeProductWithAPIProvider = FutureProvider<Response>((ref) async {

  final product = ref.watch(productRemoveProvider);
  final url = ref.watch(urlLoginProvider);

  final response = await http.delete(
    Uri.http(url, '/products/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  //Refrezca las marcas cargadas.
  await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
  //Refrezca el catalogo de productos.
  await ref.read(productCatalogProvider.notifier).refresh();

  return response;  
});