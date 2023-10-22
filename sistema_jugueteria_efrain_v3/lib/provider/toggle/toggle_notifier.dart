import 'package:flutter_riverpod/flutter_riverpod.dart';

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