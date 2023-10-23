import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';

///Proveedor para crear un producto en particular.
final statisticsEstimatedTotalProvider = FutureProvider<ResponseAPI>((ref) async {

  final url = ref.watch(urlAPIProvider);
  ref.watch(productCatalogProvider);

  //Realiza la petición POST para insertar el producto.
  ResponseAPI responseAPI = await APICall.get(
      url: url,
      route: '/statistics/estimated_total'
  );

  return responseAPI;
});