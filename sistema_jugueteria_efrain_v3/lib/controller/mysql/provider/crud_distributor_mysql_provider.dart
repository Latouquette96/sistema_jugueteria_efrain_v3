import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_distributor_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_distributor_mysql.dart';

///Proveedor para crear un Distributoro en particular.
final importDistributorWithAPIProvider = FutureProvider<ResponseAPI>((ref) async {
  ResponseAPI toReturn;

  try{
    final url = ref.watch(urlAPIProvider);
    final List<Distributor> listImport = ref.watch(importDistributorMySQLProvider);

    int errors = 0;

    for (Distributor d in listImport){
      //Realiza la petición POST para insertar el Distributoro.
      final response = await APICall.post(
        url: url, route: '/distributors',
        body: d.getJSON(),
      );

      //List<dynamic> json = jsonDecode(response.body);
      if (response.isResponseSuccess()==false){
        errors++;
      }
    }

    toReturn = ResponseAPI.manual(
        status: (errors==0) ? 200 : 501,
        value: null,
        title: (errors==0) ? "Importación exitosa" : "Error 501",
        message: (errors==0)
            ? "La importación de distribuidoras del Sistema v2 fue realizada con éxito."
            : "Error: ${ (errors<listImport.length) ? "Se importaron ${listImport.length-errors} distribuidoras." : "No se importó ninguna distribuidora del Sistema v2."}"
    );
  }
  catch(e){
    toReturn = ResponseAPI.manual(
        status: 404,
        value: null,
        title: "Error 404",
        message: "Error: No se pudo llevar a cabo la importación de distribuidoras del Sistema v2."
    );
  }

  return toReturn;  
});

///notifyImportsProvider: Provider que se utiliza para notificar las importaciones realizadas.
final notifyImportsProvider = FutureProvider((ref) async{
  await Future.delayed(const Duration(seconds: 1));
  final List<Distributor> listImport = ref.watch(importDistributorMySQLProvider);

  if (StateManagerDistributorMySQL.getInstance().getStateManager()!=null){
    StateManagerDistributorMySQL.getInstance().getStateManager()!.removeRows(
        listImport.map((e) => e.getPlutoRow()).toList()
    );

    for (Distributor d in ref.read(importDistributorMySQLProvider)){
      ref.read(importDistributorMySQLProvider.notifier).remove(d);
    }

    ref.read(importDistributorMySQLProvider.notifier).removeAll();
  }
});