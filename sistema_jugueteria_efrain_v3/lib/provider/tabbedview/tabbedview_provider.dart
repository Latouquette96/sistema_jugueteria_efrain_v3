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
    return state.tabs.where((element) => element.value==key).isNotEmpty;
  }

}

final tabbedViewProvider = StateNotifierProvider<TabbedViewProvider, TabbedViewController>((ref) => TabbedViewProvider());