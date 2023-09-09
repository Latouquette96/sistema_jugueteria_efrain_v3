import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/catalog_state_simple_notifier.dart';

///filterOfLoadedBrandsWithAPIProvider es un proveedor que permite mantener actualizado el listado de marcas de productos utilizadas.
final filterOfLoadedBrandsWithAPIProvider = StateNotifierProvider<CatalogStateSimpleNotifier<String>, List<String>>((ref) => CatalogStateSimpleNotifier<String>(
  [],
  ref: ref, 
  path: '/filter/brands', 
  byInserting: (Map<String, dynamic> map) { 
    return map['p_brand'].toString();
  }, 
  secureValue: Product.getBrandDefect(),
  
));