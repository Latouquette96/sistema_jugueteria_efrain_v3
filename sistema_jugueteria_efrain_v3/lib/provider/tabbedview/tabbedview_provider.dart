import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/main/home_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/tabbedview/tabdata_provider.dart';
import 'package:tabbed_view/tabbed_view.dart';

///Clase TabbedViewProvider: Almacena el controlador de TabData.
class TabbedViewProvider extends StateNotifier<TabbedViewController> {
  final StateNotifierProviderRef<TabbedViewProvider, TabbedViewController> ref;
  
  TabbedViewProvider(this.ref) : super(TabbedViewController([
    TabData(
      text: "Home",
      closable: false,
      content: const HomeWidget()
    )
  ]));

  ///TabbedViewProvider: Inserta un nuevo tab al inicio de la lista.
  void insertTab({required String label, required Widget widget, IconData? icon, required StateNotifierProvider<ElementStateProvider<TabData>, TabData?> tabProvider}){
    TabData tab = TabData(
      text: label,
      closable: true,
      content: widget
    );
    
    state.insertTab(0, tab);
    ref.read(tabProvider.notifier).load(tab);
  }

  ///TabbedViewProvider: Remueve el tab de clave 'key'.
  void removeTab(StateNotifierProvider<ElementStateProvider<TabData>, TabData?> tabProvider){
    int index = state.tabs.indexOf(ref.read(tabProvider));
    if (index>-1){
      state.removeTab(index);
      ref.read(tabProvider.notifier).free();
    }
  }

  ///TabbedViewProvider: Remueve el tab dado.
  void closeTab(TabData? tab){
    if (tab!=null){
      StateNotifierProvider<ElementStateProvider<TabData>, TabData?>? tabProvider;

      if (tab==ref.read(tabProductCatalogProvider)) {
        tabProvider = tabProductCatalogProvider;
      }
      else{
        if (ref.read(tabProductCatalogPDFProvider)==tab){
          tabProvider = tabProductCatalogPDFProvider;
        }
        else{
          if (ref.read(tabDistributorCatalogProvider)==tab){
            tabProvider = tabDistributorCatalogProvider;
          }
          else{
            if (ref.read(tabProductCatalogPDFManualProvider)==tab){
              tabProvider = tabProductCatalogPDFManualProvider;
            }
            else{
              if (ref.read(tabImportMySQLCatalog)==tab){
                tabProvider = tabImportMySQLCatalog;
              }
              else{
                if (ref.read(tabStatistics)==tab){
                  tabProvider = tabStatistics;
                }
              }
            }
          }
        }
      }

      if (tabProvider!=null) {
        //Libera el TabData almacenado en el provider tabProvider.
        ref.read(tabProvider.notifier).free();
      }
    }
  }
}

final tabbedViewProvider = StateNotifierProvider<TabbedViewProvider, TabbedViewController>((ref) => TabbedViewProvider(ref));