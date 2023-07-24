import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

String _url = "127.0.0.1:3000";

///Proveedor que almacena la ultima fecha de actualización del catálogo.
final lastUpdateProvider = StateProvider<String>((ref) => DatetimeCustom.getDatetimeStringNow());

///Proveedor para recuperar TODAS las distribuidoras existentes.
final catalogDistributorProvider = FutureProvider<Pair<String, List<Distributor>>>((ref) async {
  final lastUpdate = ref.watch(lastUpdateProvider.notifier).state;
  final content = await http.get(Uri.http(_url, '/distributors'));

  List<dynamic> map = convert.jsonDecode(content.body);
  List<Distributor> list = map.map((e) => Distributor.fromJSON(e)).toList();
  return Pair<String, List<Distributor>>(v1: lastUpdate, v2: list);
});


///Proveedor para crear una distribuidora en particular.
final newDistributorWithAPIProvider = FutureProvider<Response>((ref) async {

  final distributor = ref.watch(distributorProvider);

  final response = await http.post(
    Uri.http(_url, '/distributors'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(distributor!.getJSON()), 
  );

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

  return response;  
});

///Proveedor para eliminar una distribuidora en particular.
final removeDistributorWithAPIProvider = FutureProvider<Response>((ref) async {

  final distributor = ref.watch(distributorRemoveProvider);

  final response = await http.delete(
    Uri.http(_url, '/distributors/${distributor!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  return response;  
});