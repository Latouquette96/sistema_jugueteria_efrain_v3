import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';
import 'package:tabbed_view/tabbed_view.dart';

/*
  * En este archivo está incluidos los tabs a los distintos screens, haciendo uso de provider Riverpod.
 */


final tabProductCatalogProvider = StateNotifierProvider<ElementStateProvider<TabData>, TabData?>((ref) => ElementStateProvider<TabData>());

final tabProductCatalogPDFProvider = StateNotifierProvider<ElementStateProvider<TabData>, TabData?>((ref) => ElementStateProvider<TabData>());

final tabProductCatalogPDFManualProvider = StateNotifierProvider<ElementStateProvider<TabData>, TabData?>((ref) => ElementStateProvider<TabData>());

final tabDistributorCatalogProvider = StateNotifierProvider<ElementStateProvider<TabData>, TabData?>((ref) => ElementStateProvider<TabData>());

final tabConfigurationProvider = StateNotifierProvider<ElementStateProvider<TabData>, TabData?>((ref) => ElementStateProvider<TabData>());

final tabImportMySQLCatalog = StateNotifierProvider<ElementStateProvider<TabData>, TabData?>((ref) => ElementStateProvider<TabData>());