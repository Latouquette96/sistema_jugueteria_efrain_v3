import 'package:flutter_riverpod/flutter_riverpod.dart';
//TODO: import 'package:sistema_jugueteria_efrain_v3/controller/services/export_to_drive.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/code_generated/code_generated_state_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para crear un producto en particular.
final newProductWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final product = ref.watch(productProvider);
  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  ResponseAPI responseAPI = await APICall.post(
      url: url,
      route: '/products',
      body: product!.getJSON()
  );

  if (responseAPI.isResponseSuccess()){
      List<dynamic> json = responseAPI.getValue();
      product.setID(json[0]['p_id']);

      //Refrezca las marcas cargadas.
      await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
      //Refrezca el catalogo de productos.
      //TODO: await ref.read(productCatalogProvider.notifier).refresh();
      //Actualiza el catalogo de Google Drive
      //TODO: ExportToDrive.getInstance().updateSheets(product);
      //Inserta el nuevo producto
      ref.read(productCatalogProvider.notifier).insert(ref.read(productProvider)!);

      //Si hay un código que fue generado.
      if (ref.watch(generatedCodeProvider)!=null){
        if (GeneratedCodeNotifier.isGenerateCode(product.getBarcode())){
          await ref.read(generatedCodeProvider.notifier).reserveCode();
        }
      }
    }

    return responseAPI;
});

///Proveedor para actualizar un producto en particular.
final updateProductWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final product = ref.watch(productProvider);
  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  ResponseAPI responseAPI = await APICall.put(
      url: url,
      route: '/products/${product!.getID()}',
      body: product.getJSON()
  );

  if (responseAPI.isResponseSuccess()){

    //Si hay un código que fue generado.
    if (ref.watch(generatedCodeProvider)!=null){
      if (GeneratedCodeNotifier.isGenerateCode(product.getBarcode())){
        await ref.read(generatedCodeProvider.notifier).reserveCode();
      }
    }

    //Actualiza el catalogo de Google Drive
    //TODO: ExportToDrive.getInstance().updateSheets(product);
    //Refrezca las marcas cargadas.
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    //Refrezca el catalogo de productos.
    //await ref.read(productCatalogProvider.notifier).refresh();
  }

  return responseAPI;
});

///Proveedor para modificar un precio de producto en particular.
final updatePricePublicWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  String url = ref.watch(urlAPIProvider);
  //Recupero el producto.
  final product = ref.watch(productProvider);

  //Realiza la petición POST para insertar el producto.
  ResponseAPI responseAPI = await APICall.put(
      url: url,
      route: '/products/price_public/${product!.getID()}',
      body: {Product.getKeyPricePublic(): product.getPricePublic()}
  );

  if (responseAPI.isResponseSuccess()){
    //Actualiza el catalogo de Google Drive
    //TODO: ExportToDrive.getInstance().updateSheets(product);
  }

  return responseAPI;
});

///Proveedor para eliminar un producto en particular.
final removeProductWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final product = ref.watch(productRemoveProvider);
  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  ResponseAPI responseAPI = await APICall.delete(
      url: url,
      route: '/products/${product!.getID()}',
  );

  if (responseAPI.isResponseSuccess()){
    //Elimino del archivo de Google Drive
    //TODO: await //ExportToDrive.getInstance().removeSheets(product);
    product.setBarcode("-1");

    //Refrezca las marcas cargadas.
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    //Refrezca el catalogo de productos.
    //await ref.read(productCatalogProvider.notifier).refresh();

    //Remueve el producto de la lista
    ref.read(productCatalogProvider.notifier).remove(product);
  }

  return responseAPI;
});

///Proveedor para eliminar una lista de productos seleccionados.
final removeSelectedProductWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final url = ref.watch(urlAPIProvider);
  final List<Product> products = ref.watch(productSharingProvider);
  int errors = 0;

  for (Product product in products){
    //Realiza la petición POST para insertar el producto.
    ResponseAPI responseAPI = await APICall.delete(
        url: url,
        route: '/products/${product.getID()}',
    );

    if (responseAPI.isResponseSuccess()){
      //Elimino del archivo de Google Drive
      //TODO: await //ExportToDrive.getInstance().removeSheets(product);

      product.setBarcode("-1");
      //Remueve el producto de la lista
      ref.read(productCatalogProvider.notifier).remove(product);
    }
    else{
      errors++;
    }
  }

  ResponseAPI responseAPI;
  //Status a devolver de acuerdo al contador de errores.
  if (errors==products.length){
    responseAPI = ResponseAPI.manual(
        status: 404,
        value: null,
        title: "Error 404",
        message: "Error: No se pudo eliminar de la base de datos ningún producto."
    );
  }
  else{
    if (errors>0){
      responseAPI = ResponseAPI.manual(
          status: 404,
          value: null,
          title: "Error 404",
          message: "Error: Se eliminaron de la base de datos solo ${products.length - errors} productos."
      );
    }
    else{
      responseAPI = ResponseAPI.manual(
          status: 200,
          value: null,
          title: "Operación exitosa",
          message: "Se ha eliminado de la base de datos los ${products.length} seleccionados."
      );
    }
  }

  //Si por lo menos se actualizó un elemento, entonces...
  if (responseAPI.isResponseSuccess()){
    //Refrezca las marcas cargadas.
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
    //Refrezca el catalogo de productos.
    await ref.read(productCatalogProvider.notifier).refresh();
  }

  return responseAPI;
});