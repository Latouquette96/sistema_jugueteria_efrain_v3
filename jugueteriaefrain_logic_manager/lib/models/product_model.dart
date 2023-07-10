import 'package:jugueteriaefrain_logic_manager/mixin/mixin_mapping_model.dart';
import 'package:jugueteriaefrain_logic_manager/models/distributor_model.dart';

///Clase Product: Modela a un producto con todos sus atributos.
class Product with MixinMappingModel<Product> {
  ///Atributos de instancia
  late String _barcode; //RN-P1.
  late String? _internalCode; //RN-P2.
  late String _title; //RN-P8
  late String _brand; //RN-P7
  late String _description; //RN-P8
  late double _pricePublic; //RN-P12
  late int _stock; //RN-P6.
  late int _category; //RN-P9.
  late int _subcategory; //RN-P9.
  late List<String> _images; //RN-P13, RN-P14
  late Distributor? _currentDistributor; //RN-P22.

  //Atributos de clase
  final int _maxCharsBarcode = 48; //RN-P15
  final int _maxCharsTitle = 65; //RN-P16
  final int _maxCharsDescription = 9999; //RN-P17
  final int _maxCharsBrand = 100; //RN-P18.

  ///Product: Constructor genérico de producto.
  Product({
    String barcode = "0",
    String? internalCode,
    required String title,
    String description = "",
    String brand = "IMPORT.",
    Distributor? distributor,
    double pricePublic = 0,
    int stock = 0,
    int category = 0,
    int subcategory = 0,
    String? images,
  }) {
    _barcode = barcode;
    _internalCode = internalCode;
    _title = title;
    _description = description;
    _brand = brand;
    _currentDistributor = distributor;
    _pricePublic = pricePublic;
    _stock = stock;
    _category = 0;
    _subcategory = 0;
    _images = (images == null) ? [] : images.split(",");
  }

  @override
  Map<String, dynamic> getMap() {
    return {
      "p_barcode": _barcode,
      "p_internal_code": _internalCode,
      "p_title": _title,
      "p_description": _description,
      "p_brand": _brand,
      "p_price_public": _pricePublic,
      "p_stock": _stock,
      "p_category": _category,
      "p_subcategory": _subcategory,
      //Construye una cadena con todos los elementos de la lista separados por ','.
      "p_images": _images.join(','),
      "p_current_distributor": _currentDistributor,
    };
  }

  @override
  void loadingWithMap(Map<String, dynamic> map) {
    _barcode = map['p_barcode'];
    _internalCode = map['p_internal_code'];
    _title = map['p_title'];
    _description = map['p_description'];
    _brand = map['p_brand'];
    _currentDistributor = map['p_current_distributor'];
    _pricePublic = map['p_price_public'];
    _stock = map['p_stock'];
    _category = map['p_category'];
    _subcategory = map['p_subcategory'];
    _images = (map['p_images'] == null) ? [] : map['p_images'].split(",");
  }
}
