import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase ToggleNotifier
class ToggleNotifier extends StateNotifier<bool> {
  ToggleNotifier() : super(false);

  ///ToggleNotifier: Realizar el toggle.
  void toggle() {
    state = !state;
  }
}

final showImportProductsMySQL =  StateNotifierProvider<ToggleNotifier, bool>((ref) {
  return ToggleNotifier();
});

final showImportDistributorsMySQL = StateNotifierProvider<ToggleNotifier, bool>((ref) {
  return ToggleNotifier();
});