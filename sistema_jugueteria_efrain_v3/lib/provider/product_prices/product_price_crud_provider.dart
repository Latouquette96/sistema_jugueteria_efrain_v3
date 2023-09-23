import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/enum/response_status_code.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

///Proveedor para crear un precio de producto en particular.
final newProductPriceWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceProvider);
  //Envio la solicitud POST para cargar
  final response = await http.post(
    Uri.http(url, '/products/prices_products/'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(productPrice!.getJSON()), 
  );

  ResponseStatusCode result = response.statusCode==201
  ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Refrezca el catalogo de precios de un producto.
    await ref.read(productPricesByIDProvider.notifier).refresh();
  }

  return result;
});

///Proveedor para modificar un precio de producto en particular.
final updateProductPriceWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceProvider);
  //Envio la solicitud POST para cargar
  final response = await http.put(
    Uri.http(url, '/products/prices_products/${productPrice!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(productPrice.getJSON()), 
  );

  ResponseStatusCode result = response.statusCode==200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Refrezca el catalogo de precios de un producto.
    await ref.read(productPricesByIDProvider.notifier).refresh();
  }

  return result;
});

///Proveedor para remover un precio de producto en particular.
final removeProductPriceWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceRemoveProvider);
  //Envio la solicitud POST para cargar
  final response = await http.delete(
    Uri.http(url, '/products/prices_products/${productPrice!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'}
  );

  ResponseStatusCode result = response.statusCode==200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Refrezca el catalogo de precios de un producto.
    await ref.read(productPricesByIDProvider.notifier).refresh();
  }

  return result;
});