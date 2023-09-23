import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/controller/services/export_to_drive.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/enum/response_status_code.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para crear un producto en particular.
final newProductWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final product = ref.watch(productProvider);
  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  final response = await http.post(
    Uri.http(url, '/products'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(product!.getJSON()), 
  );

  ResponseStatusCode result = response.statusCode==201
  ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
      List<dynamic> json = jsonDecode(response.body);
      product.setID(json[0]['p_id']);

      //Refrezca las marcas cargadas.
      await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
      //Refrezca el catalogo de productos.
      //await ref.read(productCatalogProvider.notifier).refresh();
      //Actualiza el catalogo de Google Drive
      ExportToDrive.getInstance().updateSheets(product);
      //Inserta el nuevo producto
      ref.read(productCatalogProvider.notifier).insert(ref.read(productProvider)!);
    }

    return result;
});

///Proveedor para actualizar un producto en particular.
final updateProductWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final product = ref.watch(productProvider);
  final url = ref.watch(urlAPIProvider);

  final response = await http.put(
    Uri.http(url, '/products/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(product.getJSON()), 
  );

  ResponseStatusCode result = response.statusCode==200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Actualiza el catalogo de Google Drive
    ExportToDrive.getInstance().updateSheets(product);
    //Refrezca las marcas cargadas.
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    //Refrezca el catalogo de productos.
    //await ref.read(productCatalogProvider.notifier).refresh();
  }

  return result;
});

///Proveedor para modificar un precio de producto en particular.
final updatePricePublicWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Recupero el producto.
  final product = ref.watch(productProvider);
  //Envio la solicitud POST para cargar
  final response = await http.put(
    Uri.http(url, '/products/price_public/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({Product.getKeyPricePublic(): product.getPricePublic()}),
  );

  ResponseStatusCode result = response.statusCode == 200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Actualiza el catalogo de Google Drive
    ExportToDrive.getInstance().updateSheets(product);
  }

  return result;
});

///Proveedor para eliminar un producto en particular.
final removeProductWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final product = ref.watch(productRemoveProvider);
  final url = ref.watch(urlAPIProvider);

  final response = await http.delete(
    Uri.http(url, '/products/${product!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  ResponseStatusCode result = response.statusCode == 200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result==ResponseStatusCode.statusCodeOK){
    //Elimino del archivo de Google Drive
    await ExportToDrive.getInstance().removeSheets(product);

    product.setBarcode("-1");

    //Refrezca las marcas cargadas.
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    //Refrezca el catalogo de productos.
    //await ref.read(productCatalogProvider.notifier).refresh();

    //Remueve el producto de la lista
    ref.read(productCatalogProvider.notifier).remove(product);
  }

  return result;
});

///Proveedor para eliminar un producto en particular.
final removeSelectedProductWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final url = ref.watch(urlAPIProvider);
  final List<Product> products = ref.watch(productSharingProvider);
  ResponseStatusCode responseStatusCode = ResponseStatusCode.statusCodeOK;
  int errors = 0;

  for (Product product in products){
    http.Response response = await http.delete(
      Uri.http(url, '/products/${product.getID()}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode==200){
      //Elimino del archivo de Google Drive
      await ExportToDrive.getInstance().removeSheets(product);

      product.setBarcode("-1");
      //Remueve el producto de la lista
      ref.read(productCatalogProvider.notifier).remove(product);
    }
    else{
      errors++;
    }
  }

  //Status a devolver de acuerdo al contador de errores.
  if (errors==products.length){
    responseStatusCode = ResponseStatusCode.statusCodeFailded;
  }
  else{
    if (errors>0){
      responseStatusCode = ResponseStatusCode.statusCodeWithError;
    }
  }

  //Si por lo menos se actualizó un elemento, entonces...
  if (responseStatusCode!=ResponseStatusCode.statusCodeWithError){
    //Refrezca las marcas cargadas.
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    //Refrezca el catalogo de productos.
    await ref.read(productCatalogProvider.notifier).refresh();
  }

  return responseStatusCode;
});