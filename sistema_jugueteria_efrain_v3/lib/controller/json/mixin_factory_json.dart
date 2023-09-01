import 'package:flutter/services.dart';

///Clase MixinFactoryJSONDefault: Modela una fabrica abstracta de distintos archivos JSON.
mixin MixinFactoryJSONDefault<E, S> {
  late List<E> _list = [];
  late String _jsonString = "";

  ///MixinFactoryJSONDefault: Inicializa los parametros.
  void initialize(){
    _list = [];
    _jsonString = "";
  }

  ///FactoryDefault: Construye el listado de entidades.
  Future<void> builder();

  ///FactoryDefault: Carga el contenido del archivo dado.
  Future<void> loadAsset(String nameArchi) async {
    _jsonString = await rootBundle.loadString('json/$nameArchi');
  }

  ///MixinFactoryJSONDefault: Devuelve la lista de entidades
  List<E> getList(){
    return _list;
  }

  ///MixinFactoryJSONDefault: Devuelve el string del json.
  String getJSONString(){
    return _jsonString;
  }

  ///MixinFactoryJSONDefault: Realiza la busqueda de acuerdo al identificador dado.
  S search(int v1, {int? v2, int? v3});

  E searchKeyForID(int id);
}