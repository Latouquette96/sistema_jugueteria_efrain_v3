import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';

String _url = "127.0.0.1:3000";

final providerDistributorCatalog = FutureProvider<List<Distributor>>((ref) async {
final content = await http.get(Uri.http(_url, '/distributors'));

  List<dynamic> map = convert.jsonDecode(content.body);
  return map.map((e) => Distributor.fromJSON(e)).toList();
});
