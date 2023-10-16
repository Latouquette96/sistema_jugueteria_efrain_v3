import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_search_provider.dart';

///Proveedor para crear un precio de producto en particular.
final newProductPriceWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceProvider);
  //Envio la solicitud POST para cargar
  final response = await APICall.post(
    url: url,
    route: '/products/prices_products/',
    body: productPrice!.getJSON()
  );

  if (response.isResponseSuccess()){
    //Refrezca el listado de distribuidoras.
    await ref.read(productPricesByIDProvider.notifier).refresh();
  }

  return response;
});

///Proveedor para modificar un precio de producto en particular.
final updateProductPriceWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceProvider);
  //Envio la solicitud POST para cargar
  final response = await APICall.put(
    url: url,
    route: '/products/prices_products/${productPrice!.getID()}',
    body: productPrice.getJSON(),
  );

  if (response.isResponseSuccess()){
    //Refrezca el listado de distribuidoras.
    await ref.read(productPricesByIDProvider.notifier).refresh();
  }

  return response;
});

///Proveedor para remover un precio de producto en particular.
final removeProductPriceWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceRemoveProvider);
  //Envio la solicitud POST para cargar
  final response = await APICall.delete(
    url: url, 
    route: '/products/prices_products/${productPrice!.getID()}');

  if (response.isResponseSuccess()){
    //Refrezca el listado de distribuidoras.
    await ref.read(productPricesByIDProvider.notifier).refresh();
  }

  return response;
});