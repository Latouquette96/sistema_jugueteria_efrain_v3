import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///productProvider es un proveedor que sirve para almacenar el estado de un PlutoRow que será actualizado o creado.
final plutoRowProvider = StateNotifierProvider<ElementStateProvider<PlutoRow>, PlutoRow?>((ref) => ElementStateProvider<PlutoRow>());

///plutoRowPDFProvider es un proveedor que sirve para almacenar el estado de un PlutoRow que será actualizado o creado.
final plutoRowPDFProvider = StateNotifierProvider<ElementStateProvider<PlutoRow>, PlutoRow?>((ref) => ElementStateProvider<PlutoRow>());