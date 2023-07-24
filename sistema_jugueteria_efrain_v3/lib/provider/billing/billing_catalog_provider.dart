import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

String _url = "127.0.0.1:3000";

///Proveedor para recuperar TODAS las distribuidoras existentes.
final billingsProvider = FutureProvider<List<DistributorBilling>>((ref) async {
  final content = await http.get(Uri.http(_url, '/distributors/billings'));

  List<dynamic> map = convert.jsonDecode(content.body);
  List<DistributorBilling> list = map.map((e) => DistributorBilling.fromJSON(e)).toList();
  return list;
});

///Proveedor para recuperar TODAS las distribuidoras existentes.
final billingsByDistributorProvider = FutureProvider<List<DistributorBilling>>((ref) async {
  final distributor = ref.watch(distributorBillingProvider);
  final content = await http.get(Uri.http(_url, '/distributors/billings/distributor/${distributor!.getID()}'));

  List<dynamic> map = convert.jsonDecode(content.body);
  List<DistributorBilling> list = map.map((e) => DistributorBilling.fromJSON(e)).toList();
  return list;
});

///Proveedor para recuperar la factura con identificador.
final billingsByIDProvider = FutureProvider<Uint8List>((ref) async {
  final billing = ref.watch(billingProvider);
  final content = await http.get(Uri.http(_url, '/distributors/billings/${billing!.getID()}'));

  dynamic map = convert.jsonDecode(content.body);
  Uint8List file = const Base64Codec().decode(map['db_billing']);
  return file;
});


///Proveedor para crear una distribuidora en particular.
final newBillingWithAPIProvider = FutureProvider<Response>((ref) async {

  final billing = ref.watch(billingProvider);

  final response = await http.post(
    Uri.http(_url, '/distributors/billings'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(billing!.getJSON()), 
  );

  return response;  
});