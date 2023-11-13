import 'package:flutter_riverpod/flutter_riverpod.dart';

///Clase SelectedItemsProvider: Provider que se emplea con la finalidad de tener como estado un listado de elementos [T] seleccionados para alguna operación en particular.
class SelectedItemsProvider<T> extends StateNotifier<List<T>> {
  //Atributos de clase
  final StateNotifierProviderRef<SelectedItemsProvider, List<T>> ref;
  final List<T> listElements;

  //Constructor de SelectedItemsProvider
  SelectedItemsProvider(this.ref, this.listElements): super([]);

  ///SelectedItemsProvider: Inserta un nuevo elemento a la lista.
  void insert(T element){
    state = [...state, element];
  }

  ///SelectedItemsProvider: Inserta todos los elementos del catalogo de elementos.
  void insertAll(){
    state = [];
    state = [...listElements];
  }

  ///SelectedItemsProvider: Remueve todos los elementos del catalogo.
  void removeAll(){
    state = [];
  }

  ///SelectedItemsProvider: Remueve el elemento de la lista.
  void remove(T p){
    state = state.where((element) => element!=p).toList();
  }

  ///SelectedItemsProvider: Comprueba si el elemento está seleccionado o no. Devuelve True en caso afirmativo, de lo contrario, retorna False.
  bool contains(T element){
    return state.contains(element);
  }

  ///SelectedItemsProvider: Limpia el catalogo de elementos seleccionados.
  void clear(){
    state = [];
  }
}