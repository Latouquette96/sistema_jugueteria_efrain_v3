import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabdata_provider.dart';
import 'package:tabbed_view/tabbed_view.dart';

class TabbedViewProvider extends StateNotifier<TabbedViewController> {
  final StateNotifierProviderRef<TabbedViewProvider, TabbedViewController> ref;
  
  TabbedViewProvider(this.ref) : super(TabbedViewController([]));

  ///TabbedViewProvider: Inserta un nuevo tab al inicio de la lista.
  void insertTab({required String label, required Widget widget, IconData? icon, required StateNotifierProvider<TabDataProvider, TabData?> tabProvider}){
    TabData tab = TabData(
      text: label,
      closable: false,
      content: widget
    );
    
    state.addTab(tab);
    ref.read(tabProvider.notifier).load(tab);
  }

  ///TabNotifier: Remueve el tab de clave 'key'.
  void removeTab(StateNotifierProvider<TabDataProvider, TabData?> tabProvider){
    int index = state.tabs.indexOf(ref.read(tabProvider));
    state.removeTab(index);
    ref.read(tabProvider.notifier).clear();
  }
}

final tabbedViewProvider = StateNotifierProvider<TabbedViewProvider, TabbedViewController>((ref) => TabbedViewProvider(ref));