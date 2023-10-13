import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/import_distributor_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Proveedor para crear un Distributoro en particular.
final importDistributorWithAPIProvider = FutureProvider<bool>((ref) async {
  bool toReturn = true;

  try{
    final url = ref.watch(urlAPIProvider);
    final List<Distributor> listImport = ref.watch(importDistributorMySQLProvider);

    for (Distributor d in listImport){
      //Realiza la petición POST para insertar el Distributoro.
      final response = await http.post(
        Uri.http(url, '/distributors'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(d.getJSON()), 
      );

      //List<dynamic> json = jsonDecode(response.body);
      if (response.statusCode>=200 && response.statusCode<300){
        toReturn = false;
        break;
      }
    }
  }
  catch(e){
    toReturn = false;
  }

  return toReturn;  
});

///notifyImportsProvider: Provider que se utiliza para notificar las importaciones realizadas.
final notifyImportsProvider = FutureProvider((ref) async{
  await Future.delayed(const Duration(seconds: 1));
  final List<Distributor> listImport = ref.watch(importDistributorMySQLProvider);

  if (ref.read(stateManagerDistributorMySQLProvider)!=null){
    ref.read(stateManagerDistributorMySQLProvider)!.removeRows(
        listImport.map((e) => e.getPlutoRow()!).toList()
    );

    for (Distributor d in ref.read(importDistributorMySQLProvider)){
      ref.read(importDistributorMySQLProvider.notifier).remove(d);
    }

    ref.read(importDistributorMySQLProvider.notifier).removeAll();
  }
});