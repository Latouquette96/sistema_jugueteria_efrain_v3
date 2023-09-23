import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/enum/response_status_code.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para crear una distribuidora en particular.
final newDistributorWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final distributor = ref.watch(distributorStateProvider);
  final url = ref.watch(urlAPIProvider);

  final response = await http.post(
    Uri.http(url, '/distributors'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(distributor!.getJSON()), 
  );

  ResponseStatusCode result = response.statusCode==201
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Refrezca el listado de distribuidoras.
    await ref.read(catalogDistributorProvider.notifier).refresh();
  }

  return result;
});

///Proveedor para actualizar una distribuidora en particular.
final updateDistributorWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final distributor = ref.watch(distributorStateProvider);
  final url = ref.watch(urlAPIProvider);

  final response = await http.put(
    Uri.http(url, '/distributors/${distributor!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(distributor.getJSON()), 
  );

  ResponseStatusCode result = response.statusCode==200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Refrezca el listado de distribuidoras.
    await ref.read(catalogDistributorProvider.notifier).refresh();
  }

  return result;
});

///Proveedor para eliminar una distribuidora en particular.
final removeDistributorWithAPIProvider = FutureProvider<ResponseStatusCode>((ref) async {

  final distributor = ref.watch(distributorStateRemoveProvider);
  final url = ref.watch(urlAPIProvider);

  final response = await http.delete(
    Uri.http(url, '/distributors/${distributor!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  ResponseStatusCode result = response.statusCode==200
      ? ResponseStatusCode.statusCodeOK
      : ResponseStatusCode.statusCodeFailded;

  if (result == ResponseStatusCode.statusCodeOK){
    //Refrezca el listado de distribuidoras.
    await ref.read(catalogDistributorProvider.notifier).refresh();
  }

  return result;
});