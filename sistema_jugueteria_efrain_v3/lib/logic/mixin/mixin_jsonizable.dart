///MixinJSONalizable: Modela un mixin para leer y crear mapeos de elementos de tipo E.
mixin MixinJSONalizable<E> {
  ///MixinJSONalizable: Devuelve un mapeo del estado interno del elemento.
  Map<String, dynamic> getJSON();

  ///MixinJSONalizable: Carga al elemento con el contenido del mapeo.
  void fromJSON(Map<String, dynamic> map);
}
