import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para crear una distribuidora en particular.
final newDistributorWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final distributor = ref.watch(distributorStateProvider);
  final url = ref.watch(urlAPIProvider);

  ResponseAPI response = await APICall.post(
    url: url,
    route: '/distributors',
    body: distributor!.getJSON(),
  );

  if (response.isResponseSuccess()){
    //Refrezca el listado de distribuidoras.
    await ref.read(catalogDistributorProvider.notifier).refresh();
  }

  return response;
});

///Proveedor para actualizar una distribuidora en particular.
final updateDistributorWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final distributor = ref.watch(distributorStateProvider);
  final url = ref.watch(urlAPIProvider);

  ResponseAPI response = await APICall.put(
    url: url,
    route: '/distributors/${distributor!.getID()}',
    body: distributor.getJSON(), 
  );
  
  if (response.isResponseSuccess()){
    //Refrezca el listado de distribuidoras.
    await ref.read(catalogDistributorProvider.notifier).refresh();
  }

  return response;
});

///Proveedor para eliminar una distribuidora en particular.
final removeDistributorWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {

  final distributor = ref.watch(distributorStateRemoveProvider);
  final url = ref.watch(urlAPIProvider);

  ResponseAPI response = await APICall.delete(
    url: url,
    route: '/distributors/${distributor!.getID()}',
  );

  if (response.isResponseSuccess()){
    //Refrezca el listado de distribuidoras.
    await ref.read(catalogDistributorProvider.notifier).refresh();
  }

  return response;
});