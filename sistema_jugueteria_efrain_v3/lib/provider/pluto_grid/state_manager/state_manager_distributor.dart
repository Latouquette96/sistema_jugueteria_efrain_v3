import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_generic.dart';

///Clase StateManagerDistributor: Sirve para administrar (sin provider) el catalogo de elementos.
class StateManagerDistributor extends StateManager<Distributor>{
  //Atributos de clases
  static final StateManagerDistributor _instance = StateManagerDistributor._(path: "/distributors");

  ///Constructor de StateManagerDistributor.
  StateManagerDistributor._({required super.path});

  ///StateManagerDistributor: Devuelve la instancia.
  static StateManagerDistributor getInstance(){
    return _instance;
  }

  @override
  Future<ResponseAPI> initialize(String url) async {
    //Elimina la lista de elementos.
    loadElements([]);
    //Respuesta a retornar.
    ResponseAPI response;

    try{
      //Obtiene la respuesta a la solicitud http.
      response = await APICall.get(url: url, route: getPath());
      
      if (response.isResponseSuccess()){
        List<Distributor> elements = buildElement(response.getValue());
        loadElements(elements);
        
        //Notifica al catalogo.
        if (getStateManager()!=null){
          getStateManager()!.insertRows(0, getElements().map((e) => e.getPlutoRow()).toList());
        }
      }
    }
    catch(e){
      response = ResponseAPI.manual(
          status: 404, 
          value: null, 
          title: "Error 404", 
          message: "Error: No se pudo recuperar los datos del servidor."
      );
    }

    return response;
  }

  @override
  Future<ResponseAPI> insert(String url, Distributor element) async {
    //Realiza la petición POST para insertar el distribuidor.
    ResponseAPI responseAPI = await APICall.post(
        url: url,
        route: '/distributors',
        body: element.getJSON()
    );

    if (responseAPI.isResponseSuccess()){
      Map<String, dynamic> json = responseAPI.getValue();
      element.fromJSON(json);
      element.buildPlutoRow();
      //Inserta el nuevo registro por el actualizado.
      getStateManager()!.insertRows(0, [element.getPlutoRow()]);
      insertElement(element);
    }

    return responseAPI;
  }

  @override
  Future<ResponseAPI> remove(String url, Distributor element) async {
    final distributor = element;

    //Realiza la petición POST para insertar el distribuidor.
    ResponseAPI responseAPI = await APICall.delete(
      url: url,
      route: '/distributors/${distributor.getID()}',
    );

    if (responseAPI.isResponseSuccess()){
      //Remueve el distribuidor de la lista
      getStateManager()!.removeRows([distributor.getPlutoRow()]);
      removeElement(distributor);
    }

    return responseAPI;
  }

  @override
  Future<ResponseAPI> update(String url, Distributor element) async {
    //Realiza la petición POST para insertar el distribuidor.
    ResponseAPI responseAPI = await APICall.put(
        url: url,
        route: '/distributors/${element.getID()}',
        body: element.getJSON()
    );

    if (responseAPI.isResponseSuccess()){
      getStateManager()!.setShowLoading(true);

      Future.delayed(const Duration(milliseconds: 500), () {
        element.updatePlutoRow();
        getStateManager()!.setShowLoading(false);
      });
    }

    return responseAPI;
  }

  @override
  List<Distributor> buildElement(List<dynamic> list) {
    return list.map((e) => Distributor.fromJSON(e)).toList();
  }
}