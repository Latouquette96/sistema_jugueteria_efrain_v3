import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_search_provider.dart';

String _url = "127.0.0.1:3000";

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para crear una distribuidora en particular.
final newDistributorWithAPIProvider = FutureProvider<Response>((ref) async {

  final distributor = ref.watch(distributorProvider);

  final response = await http.post(
    Uri.http(_url, '/distributors'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(distributor!.getJSON()), 
  );
  
  //Refrezca el listado de distribuidoras.
  await ref.read(distributorCatalogProvider.notifier).refresh();

  return response;  
});

///Proveedor para actualizar una distribuidora en particular.
final updateDistributorWithAPIProvider = FutureProvider<Response>((ref) async {

  final distributor = ref.watch(distributorProvider);

  final response = await http.put(
    Uri.http(_url, '/distributors/${distributor!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(distributor.getJSON()), 
  );

  //Refrezca el listado de distribuidoras.
  await ref.read(distributorCatalogProvider.notifier).refresh();

  return response;  
});

///Proveedor para eliminar una distribuidora en particular.
final removeDistributorWithAPIProvider = FutureProvider<Response>((ref) async {

  final distributor = ref.watch(distributorRemoveProvider);

  final response = await http.delete(
    Uri.http(_url, '/distributors/${distributor!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );
  
  //Refrezca el listado de distribuidoras.
  await ref.read(distributorCatalogProvider.notifier).refresh();

  return response;  
});