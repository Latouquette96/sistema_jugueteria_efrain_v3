import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

///Clase StateManagerMySQL: Permite modelar el comportamiento de una manejador de estado de pluto_grid.
abstract class StateManagerMySQL<E, T> {
  late List<E> _listElements;
  late final String _path;
  late PlutoGridStateManager? _stateManager;
  late bool _showFilter;

  ///Constructor de StateManagerMySQL
  StateManagerMySQL({required String path}){
    _listElements = [];
    _path = path;
    _showFilter = false;
    _stateManager = null;
  }

  ///StateManagerMySQL: Reemplaza la lista de elementos.
  void loadElements(List<E> list){
    _listElements = list;
  }

  ///StateManagerMySQL: Carga el administrador de estado.
  void loadStateManager(PlutoGridStateManager stateManager){
    _stateManager = stateManager;
    _showFilter = false;
  }

  ///StateManagerMySQL: Devuelve el administrador de estado definido o null en caso de no estarlo.
  PlutoGridStateManager? getStateManager(){
    return _stateManager;
  }

  ///StateManagerMySQL: Inicializa el manejador.
  Future<ResponseAPI> initialize(String url);

  ///StateManagerMySQL: Refrezca el manejador
  Future<ResponseAPI> refresh(String url) async {
    _listElements = [];
    if (_stateManager!=null) _stateManager!.removeAllRows();
    return await initialize(url);
  }

  ///StateManagerMySQL: Carga el administrador de estado.
  void loadStateManagerMySQL(PlutoGridStateManager stateManager){
    _stateManager = stateManager;
    _stateManager!.setShowColumnFilter(_showFilter);
    _showFilter = false;
  }

  ///StateManagerMySQL: True si se muestra el filtro, de lo contrario, false.
  bool isShowFilter(){
    return _showFilter;
  }

  ///StateManagerMySQL: Muestra/oculta el filtro de las columnas.
  void toggleShowFilter(){
    _showFilter = !_showFilter;
    _stateManager!.setShowColumnFilter(_showFilter);
  }

  ///StateManagerMySQL: Devuelve el administrador de estado.
  PlutoGridStateManager? getStateManagerMySQL(){
    return _stateManager;
  }

  ///StateManagerMySQL: Realiza la importación de los elementos.
  Future<ResponseAPI> import(String url, List<E> imports);

  ///StateManagerMySQL: Retorna una lista de elementos.
  List<E> getElements(){
    return _listElements;
  }

  ///StateManagerMySQL: Devuelve la dirección.
  String getPath(){
    return _path;
  }

  ///StateManagerMySQL: Construye el elemento de acuerdo a los datos recibidos en el mapeo.
  T buildElement(Map<String, dynamic> data);
}