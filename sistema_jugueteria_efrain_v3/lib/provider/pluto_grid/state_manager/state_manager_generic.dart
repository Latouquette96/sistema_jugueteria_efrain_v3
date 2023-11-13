import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

///Clase StateManager: Permite modelar el comportamiento de una manejador de estado de pluto_grid.
abstract class StateManager<E extends JSONalizable<E>> {
  late List<E> _listElements;
  late final String _path;
  late PlutoGridStateManager? _stateManager;
  late bool _showFilter;

  ///Constructor de StateManager
  StateManager({required String path}){
    _listElements = [];
    _path = path;
    _showFilter = false;
    _stateManager = null;
  }

  ///StateManager: Reemplaza la lista de elementos.
  void loadElements(List<E> list){
    _listElements = list;
  }

  ///StateManager: Inicializa el manejador.
  Future<ResponseAPI> initialize(String url);

  ///StateManager: Refrezca el manejador
  Future<ResponseAPI> refresh(String url) async {
    _listElements = [];
    if (_stateManager!=null) _stateManager!.removeAllRows();
    return await initialize(url);
  }

  ///StateManager: Carga el administrador de estado.
  void loadStateManager(PlutoGridStateManager stateManager){
    _stateManager = stateManager;
    _stateManager!.setShowColumnFilter(_showFilter);
    _showFilter = false;
  }

  ///StateManager: True si se muestra el filtro, de lo contrario, false.
  bool isShowFilter(){
    return _showFilter;
  }

  ///StateManager: Muestra/oculta el filtro de las columnas.
  void toggleShowFilter(){
    _showFilter = !_showFilter;
    _stateManager!.setShowColumnFilter(_showFilter);
  }

  ///StateManager: Devuelve el administrador de estado.
  PlutoGridStateManager? getStateManager(){
    return _stateManager;
  }

  ///StateManager: Inserta un elemento en la lista de elementos.
  void insertElement(E element){
    _listElements.add(element);
  }

  ///StateManager: Actualiza un elemento en la lista de elementos.
  void updateElement(E element){
    int index = _listElements.indexWhere((e) => e.getPlutoRow()==element.getPlutoRow());
    if (index>-1){
      _listElements[index].updatePlutoRow();
    }
  }

  ///StateManager: Remueve el elemento de la lista de elementos.
  void removeElement(E element){
    _listElements.remove(element);
  }

  ///StateManager: Inserta un nuevo elemento al administrador de datos.
  Future<ResponseAPI> insert(String url, E element);

  ///StateManager: Remueve un elemento del administrador de datos.
  Future<ResponseAPI> remove(String url, E element);

  ///StateManager: Actualiza los datos de un elemento.
  Future<ResponseAPI> update(String url, E element);

  ///StateManager: Retorna una lista de elementos.
  List<E> getElements(){
    return _listElements;
  }

  ///StateManager: Devuelve la dirección.
  String getPath(){
    return _path;
  }

  ///StateManager: Construye listado de elementos.
  List<E> buildElement(List<dynamic> list);
}