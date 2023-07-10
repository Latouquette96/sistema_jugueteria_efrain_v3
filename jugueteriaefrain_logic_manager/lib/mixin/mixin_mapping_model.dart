///MixinMappingModel: Modela un mixin para leer y crear mapeos de elementos de tipo E.
mixin MixinMappingModel<E> {
  ///MixinMappingModel: Devuelve un mapeo del estado interno del elemento.
  Map<String, dynamic> getMap();

  ///MixinMappingModel: Carga al elemento con el contenido del mapeo.
  void loadingWithMap(Map<String, dynamic> map);
}
