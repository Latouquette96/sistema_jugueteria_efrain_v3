import 'package:jugueteriaefrain_logic_manager/models/distributor_model.dart';
import 'package:jugueteriaefrain_logic_manager/models/product_model.dart';
import 'package:jugueteriaefrain_logic_manager/utils/datetime_custom.dart';

///Clase ProductPrice: Modela un precio para un producto de una determinada distribuidora.
class ProductPrice {
  //Atributos de instancia
  late Product _product;
  late Distributor _distributor; //RN-P5.
  late double _priceBase; //RN-P4.
  late int _dateLastUpdated; //RN-P21.

  ///Constructor de ProductPrice.
  ProductPrice(
      {required Product p,
      required Distributor d,
      required double price,
      required int date}) {
    _priceBase = price;
    _product = p;
    _distributor = d;
    _dateLastUpdated = date;
  }

  //--------------------PRODUCTO----------------------

  ///ProductPrice: Devuelve el producto.
  Product getProduct() {
    return _product;
  }

  //--------------------DISTRIBUIDORA----------------------

  ///ProductPrice: Devuelve la distribuidora.
  Distributor getDistributor() {
    return _distributor;
  }

  //--------------------PRECIO BASE----------------------

  ///ProductPrice: Devuelve el precio de compra (sin impuestos).
  double getPriceBase() {
    return _priceBase;
  }

  ///ProductPrice: Devuelve el precio de compra definitivo (con impuestos si es que corresponde).
  double getPurchasePrice() {
    return (_priceBase * _distributor.getIVA()); //Según RN-P11.
  }

  ///ProductPrice: Establece un nuevo precio base.
  void setPriceBase(double price) {
    _priceBase = price;
  }

  //-------------------ULTIMA FECHA DE ACTUALIZACION---------------------

  String getDateLastUpdated() {
    return DatetimeCustom.getDatetimeString(_dateLastUpdated);
  }
}
