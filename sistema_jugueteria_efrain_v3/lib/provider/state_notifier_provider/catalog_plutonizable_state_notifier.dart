import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/selected_items_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase abstracta CatalogStateNotifier: Modela un catálogo de elementos con interacción de un StateManagerProvider y PlutoGridStateManager.
abstract class CatalogPlutonizableStateNotifier<E extends JSONalizable<E>> extends StateNotifier<List<E>> {
  late final StateNotifierProviderRef _ref; 
  late final String _path;
  late final List<E> Function(List<dynamic>) _buildElement;
  late final StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>? _stateProvider;
  late final StateNotifierProvider<SelectedItemsProvider<E>, List<E>>? _sharingProvider;
  
  ///Constructor CatalogStateNotifier.
  ///
  ///[ref] Referencia al provider que notifica el estado.
  ///
  ///[path] Directorio donde está ubicado el catalogo en la API.
  ///
  ///[buildElement] Function que permite recuperar una lista de elementos de tipo [E] a partir de un mapeo.
  ///
  ///[stateProvider] Provider que controla la grilla donde se mostrará los elementos.
  ///
  ///[sharingProvider] Provider para controlar los elementos seleccionados.
  CatalogPlutonizableStateNotifier(
    super.state, 
    {
      required StateNotifierProviderRef ref, 
      required String path, 
      required List<E> Function(List<dynamic>) buildElement,
      StateNotifierProvider<PlutoGridStateManagerProvider, PlutoGridStateManager?>? stateProvider,
      StateNotifierProvider<SelectedItemsProvider<E>, List<E>>? sharingProvider
    }
  ){
    _ref = ref;
    _path = path;
    _buildElement = buildElement;
    _stateProvider = stateProvider;
    _sharingProvider = sharingProvider;
  }

  ///CatalogStateNotifier: Inicializa el catalogo.
  Future<void> initialize() async{
    state = [];
    //Obtiene la direccion del servidor.
    final url = _ref.watch(urlAPIProvider);
    //Obtiene la respuesta a la solicitud http.
    try{
      final content = await http.get(Uri.http(url, _path));
      List<dynamic> map = jsonDecode(content.body);
      List<E> list = _buildElement(map);
      state = [...list];
      //Notifica al catalogo.
      if (_stateProvider!=null){
        _ref.read(_stateProvider!)!.insertRows(0, state.map((e) => e.getPlutoRow()!).toList());
      }
    }
    catch(e){
      state = [];
    }
  }

  ///CatalogStateNotifier: Recarga los cambios en el catalogo.
  Future<void> refresh() async {
    //Limpia el catalogo de todas las filas.
    if (_stateProvider!=null) {
      if (_ref.read(_stateProvider!)!=null){
        _ref.read(_stateProvider!)!.removeAllRows();
      }
    }
    //Si se asignó un provider para seleccionar elementos
    if (_sharingProvider!=null){
      //Limpia los productos seleccionados.
      _ref.read(_sharingProvider!.notifier).clear();
    }
    //Inicializa el catalogo.
    await initialize();
  }

  ///CatalogStateNotifier: Inserta un nuevo elemento.
  void insert(E element){
    state = [...state, element];
  }

  ///CatalogStateNotifier: Remueve el elemento del catálogo.
  void remove(E element){
    state.remove(element);
  }

  ///CatalogStateNotifier: Devuelve la url a la API REST.
  String getURLAPI(){
    return _ref.watch(urlAPIProvider);
  }
}