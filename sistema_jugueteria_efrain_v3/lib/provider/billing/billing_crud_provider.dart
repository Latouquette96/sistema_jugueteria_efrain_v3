import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

String _url = "127.0.0.1:3000";

///Proveedor para recuperar TODAS las distribuidoras existentes.
final billingsByDistributorProvider = FutureProvider<List<DistributorBilling>>((ref) async {
  final distributor = ref.watch(distributorStateBillingProvider);
  if (distributor!=null){
    final content = await http.get(Uri.http(_url, '/distributors/billings/distributor/${distributor.getID()}'));

    List<dynamic> map = convert.jsonDecode(content.body);
    List<DistributorBilling> list = map.map((e) => DistributorBilling.fromJSON(e)).toList();
    return list;
  }
  else{
    return [];
  }
});


///Proveedor para recuperar la factura con identificador.
final downloadBillingsProvider = FutureProvider<Response>((ref) async {
  final billing = ref.watch(billingSearchProvider);
  final content = await http.get(
    Uri.http(_url, '/distributors/billings/${billing!.getID()}'),
    //headers: {'Content-Type': 'application/json; charset=UTF-8'},  
  );
  
  return content;
});


///Proveedor para crear una distribuidora en particular.
final newBillingWithAPIProvider = FutureProvider<Response>((ref) async {
  //Recupero la factura que fue creada desde el formulario.
  final billing = ref.watch(billingInformationProvider);
  //Envio la solicitud POST para cargar
  final response = await http.post(
    Uri.http(_url, '/distributors/billings'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(billing!.getJSON()), 
  );

  return response;  
});