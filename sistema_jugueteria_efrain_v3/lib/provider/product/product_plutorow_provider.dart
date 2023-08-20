import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';

///Clase ProductPlutoRowProvider: Proveedor de servicios para almacenar el estado de un productPlutoRowo.
class ProductPlutoRowProvider extends StateNotifier<PlutoRow?> {
  ProductPlutoRowProvider(): super(null);

  ///ProductPlutoRowProvider: Carga un PlutoRow nuevo.
  void load(PlutoRow d){
    state = d;
  }

  ///ProductPlutoRowProvider: Libera el PlutoRow actual.
  void free(){
    state = null;
  }

  void update(Product p){
    state!.cells[Product.getKeyPricePublic()] = p.getPlutoRow().cells[Product.getKeyPricePublic()]!;
  }
}

///productPlutoRowProvider es un proveedor que sirve para almacenar el estado de un productPlutoRowo que será actualizado o creado.
final productPlutoRowProvider = StateNotifierProvider<ProductPlutoRowProvider, PlutoRow?>((ref) => ProductPlutoRowProvider());