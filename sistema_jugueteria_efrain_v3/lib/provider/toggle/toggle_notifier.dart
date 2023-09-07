import 'package:flutter_riverpod/flutter_riverpod.dart';

///Clase ToggleNotifier
class ToggleNotifier extends StateNotifier<bool> {
  ToggleNotifier() : super(false);

  ///ToggleNotifier: Realizar el toggle.
  void toggle() {
    state = !state;
  }
}