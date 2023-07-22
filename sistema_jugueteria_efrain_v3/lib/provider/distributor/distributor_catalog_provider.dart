import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

String _url = "127.0.0.1:3000";

///Proveedor para obtener una lista de distribuidoras disponibles.
final providerDistributorCatalog = FutureProvider<List<Distributor>>((ref) async {
  final content = await http.get(Uri.http(_url, '/distributors'));

  List<dynamic> map = convert.jsonDecode(content.body);
  return map.map((e) => Distributor.fromJSON(e)).toList();
});


///Proveedor para obtener una lista de distribuidoras disponibles.
final providerUpdateDistributor = FutureProvider<Response>((ref) async {

  final distributor = ref.watch(distributorProvider);

  final response = await http.put(
    Uri.http(_url, '/distributors'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(distributor?.getJSON()), 
  );

  return response;  
});