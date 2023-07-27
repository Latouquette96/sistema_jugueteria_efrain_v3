import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TabEnum {
  distributorCatalogWidget,
  distributorBillingWidget
}

@immutable
class TabModel {
  //Atributos 
  final TabEnum key;
  final String label;
  final Widget widget;

  const TabModel({required this.key, required this.label, required this.widget});

  ///Tab: Realiza un clon de Tab con algunos valores definidas o no.
  TabModel copyWith({TabEnum? key, String? label, Widget? widget}){
    return TabModel(
      key: key ?? this.key,
      label: label ?? this.label,
      widget: widget ?? this.widget
    );
  }
}

///TabNotifier: Clase que notifica el estado.
class TabNotifier extends StateNotifier<List<TabModel>>{
  ///TabNotifier: Constructor.
  TabNotifier(): super([]);

  ///TabNotifier: Inserta un nuevo tab al inicio de la lista.
  void insertTab2(TabModel t){
    if (state.where((element) => element.key==t.key).toList().isEmpty){
      state = [t, ...state];
    }
  }

  ///TabNotifier: Inserta un nuevo tab al inicio de la lista.
  void insertTab(TabEnum tabEnum, String label, Widget widget){
    if (state.where((element) => element.key==tabEnum).toList().isEmpty){
      TabModel t = TabModel(key: tabEnum, label: label, widget: widget);
      state = [t, ...state];
    }
  }

  ///TabNotifier: Remueve el tab de clave 'key'.
  void removeTab(TabEnum key){
    state = state.where((element) => element.key!=key).toList();
  }

  ///TabNotifier: Consulta si existe el tab de clave 'key'.
  bool isExistTab(TabEnum key){
    return state.where((element) => element.key==key).toList().isNotEmpty;
  }
}

final tabProvider = StateNotifierProvider<TabNotifier, List<TabModel>>((ref) => TabNotifier());