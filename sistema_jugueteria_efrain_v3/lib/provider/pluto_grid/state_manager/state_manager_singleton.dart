import 'package:pluto_grid/pluto_grid.dart';

///Clase StateManagerSingleton: Sirve para administrar (sin provider) el catalogo de elementos.
class StateManagerSingleton{
  //Atributos de clases
  static final StateManagerSingleton _instance = StateManagerSingleton._();

  //Atributos de instancia
  late PlutoGridStateManager? _stateManager;

  StateManagerSingleton._(){
    _stateManager = null;
  }

  load(PlutoGridStateManager stateManager){
    _stateManager = stateManager;
  }

  PlutoGridStateManager? getStateManager(){
    return _stateManager;
  }

  static StateManagerSingleton getInstance(){
    return _instance;
  }
}