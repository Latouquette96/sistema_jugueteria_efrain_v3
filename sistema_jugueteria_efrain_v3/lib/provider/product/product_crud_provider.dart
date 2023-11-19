import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/filter/state_manager_brands.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_sharing_provider.dart';

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
      //ref.read(productCatalogProvider.notifier).remove(product);
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
    await StateManagerBrands.getInstance().refresh(ref.watch(urlAPIProvider));
    //Refrezca el catalogo de productos.
    //await ref.read(productCatalogProvider.notifier).refresh();
  }

  return responseAPI;
});