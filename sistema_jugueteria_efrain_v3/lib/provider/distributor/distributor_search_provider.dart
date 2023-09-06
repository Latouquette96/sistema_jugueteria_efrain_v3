import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase DistributorSearchProvider: Proveedor de servicios para almacenar el estado de una distribuidora.
class DistributorSearchProvider extends StateNotifier<List<Distributor>> {
  //Atributos de clase
  final StateNotifierProviderRef<DistributorSearchProvider, List<Distributor>> ref;

  //Constructor de DistributorSearchProvider
  DistributorSearchProvider(this.ref): super([]);

  ///DistributorSearchProvider: Inicializa el arreglo de distribuidora.
  Future<void> initialize() async{
    state = [];
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlAPIProvider);
    //Obtiene la respuesta a la solicitud http.
    try{
      final content = await http.get(Uri.http(url, '/distributors'));

      List<dynamic> map = jsonDecode(content.body);
      List<Distributor> list = map.map((e) => Distributor.fromJSON(e)).toList();
      state = [...list];
    }
    catch(e){
      state = [];
    }
  }

  ///DistributorSearchProvider: Refrezca el listado de distribuidoras.
  Future<void> refresh() async {
    state.clear();
    await initialize();
  }
}


///distributorCatalogProvider es un proveedor que almacena la lista de distribuidoras.
final distributorCatalogProvider = StateNotifierProvider<DistributorSearchProvider, List<Distributor>>((ref) => DistributorSearchProvider(ref));