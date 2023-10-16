import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Clase abstracta CatalogStateNotifier: Modela un catálogo de elementos con interacción de un StateManagerProvider y PlutoGridStateManager.
abstract class CatalogStateNotifier<E> extends StateNotifier<List<E>> {
  late final StateNotifierProviderRef _ref; 
  late final String _path;
  late final List<E> Function(List<dynamic>) _buildElement;
  
  ///Constructor CatalogStateNotifier.
  ///
  ///[ref] Referencia al provider que notifica el estado.
  ///[path] Directorio donde está ubicado el catalogo en la API.
  ///[buildElement] Function que permite recuperar una lista de elementos de tipo [E] a partir de un mapeo.
  ///[stateProvider] Provider que controla la grilla donde se mostrará los elementos.
  ///[sharingProvider] Provider para controlar los elementos seleccionados.
  CatalogStateNotifier(
    super.state, 
    {
      required StateNotifierProviderRef ref, 
      required String path, 
      required List<E> Function(List<dynamic>) buildElement
    }
  ){
    _ref = ref;
    _path = path;
    _buildElement = buildElement;
  }

  ///CatalogStateNotifier: Inicializa el catalogo.
  Future<ResponseAPI> initialize() async{
    state = [];
    //Obtiene la direccion del servidor.
    final url = _ref.watch(urlAPIProvider);
    ResponseAPI content;
    //Obtiene la respuesta a la solicitud http.
    try{
      content = await APICall.get(url: url, route: _path);
      if (content.isResponseSuccess()){
        List<dynamic> map = content.getValue();
        List<E> list = _buildElement(map);
        state = [...list];
      }
      else{
        state = [];
      }
    }
    catch(e){
      content = ResponseAPI.manual(status: 404, value: null, title: "Error 404", message: "Error: No fue posible recuperar los datos del servidor.");
      state = [];
    }

    return content;
  }

  ///CatalogStateNotifier: Recarga los cambios en el catalogo.
  Future<ResponseAPI> refresh() async {
    //Inicializa el catalogo.
    return await initialize();
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