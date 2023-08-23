import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabbed_view/tabbed_view.dart';

enum TabEnum {
  distributorCatalogWidget,
  distributorBillingWidget, 
  productCatalogWidget, 
  configurationWidget, 
  productPDFViewer
}

@immutable
class TabModel {
  //Atributos 
  final TabEnum key;
  final String label;
  final Widget widget;
  final IconData? iconData;

  const TabModel({required this.key, required this.label, required this.widget, this.iconData});

  ///Tab: Realiza un clon de Tab con algunos valores definidas o no.
  TabModel copyWith({TabEnum? key, String? label, Widget? widget, IconData? iconData}){
    return TabModel(
      key: key ?? this.key,
      label: label ?? this.label,
      widget: widget ?? this.widget,
      iconData: iconData ?? this.iconData
    );
  }
}

///TabNotifier: Clase que notifica el estado.
class TabNotifier extends StateNotifier<List<TabModel>>{
  ///TabNotifier: Constructor.
  TabNotifier(): super([]);

  ///TabNotifier: Inserta un nuevo tab al inicio de la lista.
  void insertTab({required TabEnum tabEnum, required String label, required Widget widget, IconData? icon}){
    if (state.where((element) => element.key==tabEnum).toList().isEmpty){
      TabModel t = TabModel(key: tabEnum, label: label, widget: widget, iconData: icon);
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


class TabbedViewProvider extends StateNotifier<TabbedViewController> {
  TabbedViewProvider() : super(TabbedViewController([]));

  ///TabNotifier: Inserta un nuevo tab al inicio de la lista.
  void insertTab({required TabEnum tabEnum, required String label, required Widget widget, IconData? icon}){
    state.addTab(TabData(
      value: tabEnum,
      text: label,
      closable: true,
      content: widget
    ));
  }

  ///TabNotifier: Remueve el tab de clave 'key'.
  void removeTab(TabEnum tabEnum){
    int index = state.tabs.indexWhere((element) => element.value==tabEnum);
    state.removeTab(index);
  }

  ///TabNotifier: Consulta si existe el tab de clave 'key'.
  bool isExistTab(TabEnum key){
    print(state.tabs.where((element) => element.value==key).isNotEmpty);
    return state.tabs.where((element) => element.value==key).isNotEmpty;
  }

}

final tabbedViewProvider = StateNotifierProvider<TabbedViewProvider, TabbedViewController>((ref) => TabbedViewProvider());