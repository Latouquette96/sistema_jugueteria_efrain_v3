import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase abstracta CatalogStateSimpleNotifier: Modela un catálogo de elementos con interacción de un StateManagerProvider y PlutoGridStateManager.
class CatalogStateSimpleNotifier<E> extends StateNotifier<List<E>> {
  late final StateNotifierProviderRef _ref; 
  late final String _path;
  late final E Function(Map<String, dynamic> map) _byInserting;
  late final E _secureValue;
  
  ///Constructor CatalogStateSimpleNotifier.
  ///
  ///[ref] Referencia al provider que notifica el estado.
  ///
  ///[path] Directorio donde está ubicado el catalogo en la API.
  ///
  ///[byInserting] Function (opcional) para realizar a la hora de insertar un elemento en el catálogo.
  ///
  ///[secureValue] Valor fijo que siempre debe estar.
  CatalogStateSimpleNotifier(
    super.state, 
    {
      required StateNotifierProviderRef ref, 
      required String path,
      required E Function (Map<String, dynamic> map) byInserting,
      required E secureValue
    }
  ){
    _ref = ref;
    _path = path;
    _byInserting = byInserting;
    _secureValue = secureValue;
  }


  ///CatalogStateSimpleNotifier: Recarga los cambios en el catalogo.
  Future<void> refresh() async {
    //Obtiene la URL a la API.
    String url = _ref.read(urlAPIProvider);

    //Si hay elementos, entonces se remueven todos.
    if (state.isNotEmpty){
      state.clear();
    }

    final content = await http.get(Uri.http(url, _path));
    //Convierte los datos obtenidos en una lista de objetos json (mapeos).
    List<dynamic> map = jsonDecode(content.body);
    //Para cada elemento del mapeo, se lo inserta en la lista.
    for (var e in map) {
      E element = _byInserting(e);
      state.add(element);
    }

    //Si la lista está vacia, entonces ingresa el valor seguro.
    if (state.isEmpty){
      state.add(_secureValue);
    }
    //Si la lista tiene elementos, comprueba la existencia de dicho valor seguro.
    else{
      if (!state.contains(_secureValue)){
        state.add(_secureValue);
      }
    }
  }

  ///CatalogStateSimpleNotifier: Inserta un nuevo elemento.
  void insert(E element){
    state = [...state, element];
  }

  ///CatalogStateSimpleNotifier: Remueve el elemento del catálogo.
  void remove(E element){
    state.remove(element);
  }

  ///CatalogStateSimpleNotifier: Devuelve la url a la API REST.
  String getURLAPI(){
    return _ref.watch(urlAPIProvider);
  }
}