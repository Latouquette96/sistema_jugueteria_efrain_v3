import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_products_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/selected_items_provider.dart';

final catalogProductsImportProvider = StateNotifierProvider<SelectedItemsProvider<Triple<Product, Distributor, double>>, List<Triple<Product, Distributor, double>>>((ref) => SelectedItemsProvider(ref, importProductMySQLProvider));

///Proveedor para crear un producto en particular.
final importProductWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  ResponseAPI toReturn;

  try{
    final url = ref.watch(urlAPIProvider);
    final List<Triple<Product, Distributor, double>> listImport = ref.watch(catalogProductsImportProvider);
    int i=0;
    int errors = 0;

    while(i<listImport.length){
      Triple<Product, Distributor, double> triple = listImport[i];

      //Realiza la petición POST para insertar el producto.
      final response = await APICall.post(
        url: url, route: '/products',
        body: triple.getValue1().getJSON(),
      );

      if (response.isResponseSuccess()){
        triple.getValue1().setID(response.getValue()['p_id']);

        final productPrice = ProductPrice(
            id: 0,
            p: triple.getValue1().getID(),
            d: triple.getValue2()!.getID(),
            price: triple.getValue3() ?? 0,
            date: DatetimeCustom.parseStringDatetime(triple.getValue1().getDateUpdate())
        );

        //Envio la solicitud POST para cargar
        await APICall.post(
          url: url, route: '/products/prices_products',
          body: productPrice.getJSON(),
        );
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
  final List<Triple<Product, Distributor, double>> listImport = ref.watch(catalogProductsImportProvider);

  if (ref.watch(stateManagerProductMySQLProvider)!=null){
    ref.read(stateManagerProductMySQLProvider)!.removeRows(
        listImport.map((e) => e.getValue1().getPlutoRow()!).toList()
    );

    for (Triple<Product, Distributor, double> triple in ref.read(catalogProductsImportProvider)){
      ref.read(importProductMySQLProvider.notifier).remove(triple);
    }

    ref.read(catalogProductsImportProvider.notifier).removeAll();
  }
});