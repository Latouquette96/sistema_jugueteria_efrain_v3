mixin MixinComparable<E> {

  ///MixinComparable: Devuelve el string con el que se representa al elemento.
  String itemAsString();

  ///MixinComparable: Devuelve True si los dos elementos son iguales según el parámetro dado.
  bool compare(E e1, E e2);
}