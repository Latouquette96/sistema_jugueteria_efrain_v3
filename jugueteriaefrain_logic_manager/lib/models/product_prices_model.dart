import 'package:jugueteriaefrain_logic_manager/models/product_model.dart';

///Clase ProductPrices: Modela los distintos precios de un determinado producto en las distintas distribuidoras registradas.
class ProductPrices {
  //Atributos de instancia
  late Product _product;
  late List<Map<String, dynamic>> _listPrice; //RN-P3 y RN-21.

  ///Constructor de ProductPrices: Carga un listado de precios a un determinado producto.
  ProductPrices.loadOfMap(
      {required Product product, List<Map<String, dynamic>>? listPrice}) {
    _product = product;
    _listPrice = (listPrice == null) ? [] : listPrice;
  }

  ///ProductPrices: Devuelve el producto en cuestión.
  Product getProduct() {
    return _product;
  }

  ///ProductPrices: Devuelve un listado de precios
  List<Map<String, dynamic>> getListPricesInformation() {
    return _listPrice;
  }
}
