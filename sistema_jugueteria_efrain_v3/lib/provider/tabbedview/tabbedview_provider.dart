import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';
import 'package:tabbed_view/tabbed_view.dart';

///Clase TabbedViewProvider: Almacena el controlador de TabData.
class TabbedViewProvider extends StateNotifier<TabbedViewController> {
  final StateNotifierProviderRef<TabbedViewProvider, TabbedViewController> ref;
  
  TabbedViewProvider(this.ref) : super(TabbedViewController([]));

  ///TabbedViewProvider: Inserta un nuevo tab al inicio de la lista.
  void insertTab({required String label, required Widget widget, IconData? icon, required StateNotifierProvider<ElementStateProvider<TabData>, TabData?> tabProvider}){
    TabData tab = TabData(
      text: label,
      closable: false,
      content: widget
    );
    
    state.insertTab(0, tab);
    ref.read(tabProvider.notifier).load(tab);
  }

  ///TabbedViewProvider: Remueve el tab de clave 'key'.
  void removeTab(StateNotifierProvider<ElementStateProvider<TabData>, TabData?> tabProvider){
    int index = state.tabs.indexOf(ref.read(tabProvider));
    state.removeTab(index);
    ref.read(tabProvider.notifier).free();
  }
}

final tabbedViewProvider = StateNotifierProvider<TabbedViewProvider, TabbedViewController>((ref) => TabbedViewProvider(ref));