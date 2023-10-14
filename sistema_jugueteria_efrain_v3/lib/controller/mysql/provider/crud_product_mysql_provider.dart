import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_products_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/filter/filter_brands_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/selected_items_provider.dart';

final catalogProductsImportProvider = StateNotifierProvider<SelectedItemsProvider<Triple<Product, Distributor, double>>, List<Triple<Product, Distributor, double>>>((ref) => SelectedItemsProvider(ref, importProductMySQLProvider));

///Proveedor para crear un producto en particular.
final importProductWithAPIProvider = FutureProvider<bool>((ref) async {
  bool toReturn = true;

  try{
    final url = ref.watch(urlAPIProvider);
    final List<Triple<Product, Distributor, double>> listImport = ref.watch(catalogProductsImportProvider);

    for (Triple<Product, Distributor, double> triple in listImport){
      //Realiza la petición POST para insertar el producto.
      final response = await http.post(
        Uri.http(url, '/products'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(triple.getValue1().getJSON()), 
      );
      Map<String, dynamic> json = jsonDecode(response.body);
      triple.getValue1().setID(json['p_id']);

      final productPrice = ProductPrice(
        id: 0,
        p: triple.getValue1().getID(),
        d: triple.getValue2()!.getID(),
        price: triple.getValue3() ?? 0,
        date: DatetimeCustom.parseStringDatetime(triple.getValue1().getDateUpdate())
      );

      //Envio la solicitud POST para cargar
      await http.post(
        Uri.http(url, '/products/prices_products'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(productPrice.getJSON()),
      );
    }

    await ref.read(productCatalogProvider.notifier).refresh();
    ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
    await ref.read(importProductMySQLProvider.notifier).refresh();
    await ref.read(filterOfLoadedBrandsWithAPIProvider.notifier).refresh();
  }
  catch(e){
    toReturn = false;
  }

  return toReturn;  
});

///notifyImportsProvider: Provider que se utiliza para notificar las importaciones realizadas.
final notifyImportsProvider = FutureProvider((ref) async{
  await Future.delayed(const Duration(seconds: 1));
  final List<Triple<Product, Distributor, double>> listImport = ref.watch(catalogProductsImportProvider);

  if (ref.read(stateManagerProductMySQLProvider)!=null){
    ref.read(stateManagerProductMySQLProvider)!.removeRows(
        listImport.map((e) => e.getValue1().getPlutoRow()!).toList()
    );

    for (Triple<Product, Distributor, double> triple in ref.read(catalogProductsImportProvider)){
      ref.read(importProductMySQLProvider.notifier).remove(triple);
    }

    ref.read(catalogProductsImportProvider.notifier).removeAll();
  }
});