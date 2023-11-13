import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_products_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/fourfold.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/code_generated/generated_code_controller.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/selected_items_provider.dart';

final catalogProductsImportProvider = StateNotifierProvider<SelectedItemsProvider<Fourfold<Product, Distributor, double, String>>, List<Fourfold<Product, Distributor, double, String>>>((ref) => SelectedItemsProvider(ref, ref.read(importProductMySQLProvider)));

///Proveedor para crear un producto en particular.
final importProductWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  ResponseAPI toReturn;

  try{
    final url = ref.watch(urlAPIProvider);
    final List<Fourfold<Product, Distributor, double, String>> listImport = ref.watch(catalogProductsImportProvider);
    int i=0;
    int errors = 0;

    while(i<listImport.length){
      Fourfold<Product, Distributor, double, String> fourfold = listImport[i];

      //Realiza la petición POST para insertar el producto.
      final response = (fourfold.getValue1().getID()==0)
        ? await APICall.post(
            url: url,
            route: '/products',
            body: fourfold.getValue1().getJSON(),
          )
        : await APICall.put(
            url: url,
            route: '/products/${fourfold.getValue1().getID()}',
            body: fourfold.getValue1().getJSON(),
          );

      //Si la respuesta fue exitosa
      if (response.isResponseSuccess()){
        //Si ademas el producto en cuestion se trataba de un producto nuevo, entonces se carga su respectivo
        if (fourfold.getValue1().getID()==0){
          //Establece el id obtenido del producto insertado
          fourfold.getValue1().setID(response.getValue()['p_id']);

          //Comprueba si es un código generado.
          if (GeneratedCodeController.isGenerateCode(fourfold.getValue1().getBarcode())){
            GeneratedCodeController.reserveGeneratedCode(url, fourfold.getValue1(), fourfold.getValue1().getBarcode());
          }

          final productPrice = ProductPrice(
              id: 0,
              internalCode: fourfold.getValue4(),
              p: fourfold.getValue1().getID(),
              d: fourfold.getValue2()!.getID(),
              price: fourfold.getValue3() ?? 0,
              date: DatetimeCustom.parseStringDatetime(fourfold.getValue1().getDateUpdate())
          );

          //Envio la solicitud POST para cargar
          await APICall.post(
            url: url, route: '/products/prices_products',
            body: productPrice.getJSON(),
          );
        }
      }
      else{
        errors++;
      }
      i++;
    }

    toReturn = ResponseAPI.manual(
        status: (errors==0) ? 200 : 501,
        value: null,
        title: (errors==0) ? "Importación exitosa" : "Error 501",
        message: (errors==0)
            ? "La importación de productos del Sistema v2 fue realizada con éxito."
            : "Error: ${ (errors<listImport.length) ? "Se importaron ${listImport.length-errors} productos." : "No se importó ningún producto del Sistema v2."}"
    );
  }
  catch(e){
    toReturn = ResponseAPI.manual(
        status: 404,
        value: null,
        title: "Error 404",
        message: "Error: No se pudo llevar a cabo la importación de productos del Sistema v2."
    );
  }

  return toReturn;  
});

///notifyImportsProvider: Provider que se utiliza para notificar las importaciones realizadas.
final notifyImportsProvider = FutureProvider((ref) async{
  await Future.delayed(const Duration(seconds: 1));
  final List<Fourfold<Product, Distributor, double, String>> listImport = ref.watch(catalogProductsImportProvider);

  if (StateManagerProductMySQL.getInstance().getStateManager()!=null){
    StateManagerProductMySQL.getInstance().getStateManager()!.removeRows(
        listImport.map((e) => e.getValue1().getPlutoRow()).toList()
    );

    for (Fourfold<Product, Distributor, double, String> fourfold in ref.read(catalogProductsImportProvider)){
      ref.read(importProductMySQLProvider.notifier).remove(fourfold);
    }

    ref.read(catalogProductsImportProvider.notifier).removeAll();
  }
});