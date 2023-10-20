import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Proveedor para recuperar TODAS las distribuidoras existentes.
final billingsByDistributorProvider = FutureProvider<List<DistributorBilling>>((ref) async {
  final url = ref.watch(urlAPIProvider);
  final distributor = ref.watch(distributorStateBillingProvider);
  List<DistributorBilling> list = [];

  if (distributor!=null){
    final content = await APICall.get(url: url, route: '/distributors/billings/distributor/${distributor.getID()}');

    if (content.isResponseSuccess()){
      List<dynamic> map = content.getValue() as List<dynamic>;
      list.addAll(map.map((e) => DistributorBilling.fromJSON(e)).toList());
    }
  }

  return list;
});

///Proveedor para recuperar la factura con identificador.
final downloadBillingsProvider = FutureProvider<ResponseAPI>((ref) async {
  final url = ref.watch(urlAPIProvider);
  final billing = ref.watch(billingSearchProvider);
  ResponseAPI content = await APICall.get(
    url: url, route: '/distributors/billings/${billing!.getID()}',
  );
  
  return content;
});

///Proveedor para recuperar la factura con identificador.
final removeBillingsProvider = FutureProvider<ResponseAPI>((ref) async {
  final url = ref.watch(urlAPIProvider);
  final billing = ref.watch(billingInformationProvider);
  final content = await APICall.delete(
    url: url, route: '/distributors/billings/${billing!.getID()}');

  return content;
});

///Proveedor para crear una distribuidora en particular.
final newBillingWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  final url = ref.watch(urlAPIProvider);
  //Recupero la factura que fue creada desde el formulario.
  final billing = ref.watch(billingInformationProvider);
  //Envio la solicitud POST para cargar
  final response = await APICall.post(
    url: url, route: '/distributors/billings',
    body: billing!.getJSON(),
  );

  return response;
});