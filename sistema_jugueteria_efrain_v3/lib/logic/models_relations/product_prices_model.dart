// ignore: implementation_imports
import 'package:pluto_grid/src/model/pluto_row.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';

///Clase ProductPrice: Modela un precio para un producto de una determinada distribuidora.
class ProductPrice extends JSONalizable<ProductPrice>{
  //Atributos de instancia
  late int _id;
  late int _productID;
  late int _distributor; //RN-P5.
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
    required int d,
    required double price,
    required int date}
  ) {
    _id = id;
    _priceBase = price;
    _productID = p;
    _distributor = d;
    _dateLastUpdated = date;
  }

  ProductPrice.clear(Product p){
    _id = 0;
    _priceBase = 0;
    _dateLastUpdated = DatetimeCustom.getDatetimeIntegerNow();
    _distributor = 0;
    _productID = p.getID();
  }

  ProductPrice.fromJSON(Map<String, dynamic> map){
    try{
      _id = int.parse(map[_keyID].toString());
      _priceBase = double.parse(map[_keyPriceBase].toString());
      _productID = int.parse(map[_keyProduct].toString());
      _dateLastUpdated = int.parse(map[_keyDateUpdate].toString());
      _distributor = int.parse(map[_keyDistributor].toString());
    }
    // ignore: empty_catches
    catch(e){
    }
  }

  //--------------------CLAVES-------------------------

  static String getKeyID(){
    return _keyID;
  }

  static String getKeyProduct(){
    return _keyProduct;
  }

  static String getKeyDistributor(){
    return _keyDistributor;
  }

  static String getKeyPriceBase(){
    return _keyPriceBase;
  }

  static String getKeyDateUpdate(){
    return _keyDateUpdate;
  }

  //--------------------PRODUCTO----------------------

  ///ProductPrice: Devuelve el ID.
  int getID(){
    return _id;
  }

  ///ProductPrice: Devuelve el ID de producto.
  int getProduct() {
    return _productID;
  }

  ///ProductPrice: Establece el producto.
  void setProduct(Product p){
    _productID = p.getID();
  }

  //--------------------DISTRIBUIDORA----------------------

  ///ProductPrice: Devuelve la distribuidora.
  int getDistributor() {
    return _distributor;
  }

  void setDistributor(int distributor){
    _distributor = distributor;
  }

  //--------------------PRECIO BASE----------------------

  ///ProductPrice: Devuelve el precio de compra (sin impuestos).
  double getPriceBase() {
    return _priceBase;
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
      _keyDistributor: _distributor,
      _keyProduct: _productID,
      _keyDateUpdate: _dateLastUpdated,
      _keyPriceBase: _priceBase
    };
  }

  @override
  PlutoRow? buildPlutoRow() {
    return null;
  }
}
