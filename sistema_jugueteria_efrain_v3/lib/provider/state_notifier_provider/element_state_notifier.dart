import 'package:flutter_riverpod/flutter_riverpod.dart';

///Clase ElementStateProvider: Proveedor de servicios para almacenar el estado de una distribuidora.
class ElementStateProvider<E> extends StateNotifier<E?> {
  ElementStateProvider(): super(null);

  ///ElementStateProvider: Carga un elemento nuevo como estado.
  void load(E element){
    state = element;
  }

  ///ElementStateProvider: Libera el elemento actual, realizando un cambio de estado.
  void free(){
    state = null;
  }
}