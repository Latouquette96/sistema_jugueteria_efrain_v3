import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';

///Clase ProductProvider: Proveedor de servicios para almacenar el estado de un PlutoRow.
class ProductProvider extends StateNotifier<PlutoRow?> {
  ProductProvider(): super(null);

  ///ProductProvider: Carga un PlutoRow nuevo.
  void load(PlutoRow d){
    state = d;
  }

  ///ProductProvider: Libera el PlutoRow actual.
  void free(){
    state = null;
  }  
}

///productProvider es un proveedor que sirve para almacenar el estado de un PlutoRow que será actualizado o creado.
final plutoRowProvider = StateNotifierProvider<ProductProvider, PlutoRow?>((ref) => ProductProvider());
