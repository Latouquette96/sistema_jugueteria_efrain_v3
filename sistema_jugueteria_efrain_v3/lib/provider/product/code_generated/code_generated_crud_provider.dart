import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Proveedor para crear bloques de códigos generados (100 códigos).
final generatedCodeBlockProvider = FutureProvider<bool>((ref) async {
  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  ResponseAPI responseAPI = await APICall.post(
      url: url,
      route: '/code_generated/generate_code_block'
  );

  return responseAPI.isResponseSuccess();
});

