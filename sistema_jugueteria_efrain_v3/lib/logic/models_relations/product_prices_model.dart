import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';

///Clase ProductPrice: Modela un precio para un producto de una determinada distribuidora.
class ProductPrice with MixinJSONalizable<ProductPrice>{
  //Atributos de instancia
  late int _id;
  late int _productID;
  late Distributor _distributor; //RN-P5.
  late double _priceBase; //RN-P4.
  late int _dateLastUpdated; //RN-P21.

  //Atributos de clase
  static const String _keyID          = "pp_id";
  static const String _keyProduct     = "pp_product";
  static const String _keyDistributor = "pp_distributor";
  static const String _keyPriceBase   = "pp_price_base";
  static const String _keyDateUpdate  = "pp_date_update";

  ///Constructor de ProductPrice.
  ProductPrice({
    required int id,
    required int p,
    required Distributor d,
    required double price,
    required int date}
  ) {
    _id = id;
    _priceBase = price;
    _productID = p;
    _distributor = d;
    _dateLastUpdated = date;
  }

  //--------------------PRODUCTO----------------------

  ///ProductPrice: Devuelve el ID de producto.
  int getProduct() {
    return _productID;
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

  //---------------------------------------------------------------------
  
  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = int.parse(map[_keyID]);
    _priceBase = double.parse(map[_keyPriceBase]);
    _productID = int.parse(map[_keyProduct]);
    _distributor = map[_keyDistributor];
    _dateLastUpdated = map[_keyDateUpdate];
  }
  
  @override
  Map<String, dynamic> getJSON() {
    return {
      _keyID: _id,
      _keyDistributor: _distributor.getID(),
      _keyProduct: _productID,
      _keyDateUpdate: _dateLastUpdated,
      _keyPriceBase: _priceBase
    };
  }
}
