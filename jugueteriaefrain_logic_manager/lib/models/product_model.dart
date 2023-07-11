import 'package:jugueteriaefrain_logic_manager/mixin/mixin_mapping_model.dart';
import 'package:jugueteriaefrain_logic_manager/structure_data/triple.dart';
import 'package:jugueteriaefrain_logic_manager/utils/link_image.dart';

///Clase Product: Modela a un producto con todos sus atributos.
class Product with MixinMappingModel<Product> {
  ///Atributos de instancia
  late String? _barcode; //RN-P1.
  late String? _internalCode; //RN-P2.
  late String _title; //RN-P8
  late String _brand; //RN-P7
  late String _description; //RN-P8
  late double _pricePublic; //RN-P12
  late int _stock; //RN-P6.
  late int _subcategory; //RN-P9.
  late List<String> _images; //RN-P13, RN-P14
  late List<String> _listSize; //RN-P10.

  //Atributos de clase
  static const int _maxCharsBarcode = 48; //RN-P15
  static const int _maxCharsTitle = 65; //RN-P16
  static const int _maxCharsDescription = 9999; //RN-P17
  static const int _maxCharsBrand = 100; //RN-P18.

  ///Product: Constructor genérico de producto.
  Product({
    String? barcode,
    String? internalCode,
    required String title,
    String description = "",
    String brand = "IMPORT.",
    double pricePublic = 0,
    int stock = 0,
    int subcategory = 0,
    String? images,
    String? sizes,
  }) {
    _barcode = barcode;
    _internalCode = internalCode;
    _title = title;
    _description = description;
    _brand = brand;
    _pricePublic = pricePublic;
    _stock = stock;
    _subcategory = 0;
    _images = (images == null) ? [] : images.split(",");
    _listSize = (sizes == null) ? [] : sizes.split(",");
  }

  //------------------CONSULTAS ESTÁTICAS---------------------------------------------

  ///Product: Devuelve la cantidad máxima de chars permitidos para un código de barras.
  static int getMaxCharsBarcode() {
    return _maxCharsBarcode;
  }

  ///Product: Devuelve la cantidad máxima de chars permitidos para un título.
  static int getMaxCharsTitle() {
    return _maxCharsTitle;
  }

  ///Product: Devuelve la cantidad máxima de chars permitidos para una descripción.
  static int getMaxCharsDescription() {
    return _maxCharsDescription;
  }

  ///Product: Devuelve la cantidad máxima de chars permitidos para una marca/importadora.
  static int getMaxCharsBrand() {
    return _maxCharsBrand;
  }

  //------------------CODIGO DE BARRAS---------------------------------------------

  ///Product: Devuelve el código de barras.
  String? getBarcode() {
    return _barcode;
  }

  ///Product: Establece el código de barras.
  void setBarcode(String? value) {
    _barcode = value;
  }

  //------------------CODIGO INTERNO---------------------------------------------

  ///Product: Devuelve el código interno.
  String? getInternalCode() {
    return _internalCode;
  }

  ///Product: Establece el código interno.
  void setInternalCode(String? value) {
    _internalCode = value;
  }

  //------------------TITULO---------------------------------------------

  ///Product: Devuelve el titulo.
  String getTitle() {
    return _title;
  }

  ///Product: Establece el titulo.
  void setTitle(String value) {
    _title = value;
  }

  //------------------DESCRIPCIÓN---------------------------------------------

  ///Product: Devuelve la descripcion.
  String getDescription() {
    return _description;
  }

  ///Product: Establece la descripcion.
  void setDescription(String value) {
    _description = value;
  }

  //------------------MARCA---------------------------------------------

  ///Product: Devuelve la marca/importadora.
  String getBrand() {
    return _brand;
  }

  ///Product: Establece la marca/importadora.
  void setBrand(String value) {
    _brand = value.toUpperCase();
  }

  //------------------PRECIO PUBLICO---------------------------------------------

  ///Product: Devuelve el precio al público.
  double getPricePublic() {
    return _pricePublic;
  }

  ///Product: Establece el precio al público.
  void setPricePublic(double value) {
    _pricePublic = value;
  }

  //------------------STOCK---------------------------------------------

  ///Devuelve el stock actual (stock=-1 si "no se consigue el producto", stock=0 si "producto sin stock" y stock>0 si "en stock").
  int getStock() {
    return _stock;
  }

  ///Product: Establece el stock (stock=-1 si "no se consigue el producto", stock=0 si "producto sin stock" y stock>0 si "en stock").
  void setStock(int value) {
    _stock = value;
  }

  //------------------SUBCATEGORIA---------------------------------------------

  ///Devuelve el identificador de la subcategoria.
  int getSubcategory() {
    return _subcategory;
  }

  ///Product: Establece el identificador de la subcategoria.
  void setSubcategory(int value) {
    _subcategory = value;
  }

  //------------------IMAGENES---------------------------------------------

  ///Product: Devuelve una lista de links de imagenes.
  List<LinkImage> getLinkImages() {
    return _images.map((e) => LinkImage(e)).toList();
  }

  ///Product: Inserta una nueva imagen al final de la lista.
  void insertLinkImage(String link) {
    _images.add(LinkImage(link).getLink());
  }

  ///Remueve la imagen de la posicion dada.
  String removeLinkImage(int index) {
    return _images.removeAt(index);
  }

  ///Actualiza la posicion del link, moviendola a una posición dada.
  void updateLinkImagePosition(int index, int newPos) {
    String str = _images.removeAt(index);
    _images.insert(newPos - 1, str);
  }

  //------------------MEDIDAS---------------------------------------------

  ///Product: Inserta una nueva medida en la lista.
  void insertSize(String label, Triple<int, int?, int?> values) {
    String medida = "Medida ($label): ${values.getValue1().toString()}";
    if (values.getValue2() != null) {
      medida = "$medida x ${values.getValue2().toString()}";

      if (values.getValue3() != null) {
        medida = "$medida x ${values.getValue3().toString()}";
      }
    }
    _listSize.add(medida);
  }

  ///Product: Remueve el elemento de la posicion dada (entre 0 y N-1).
  void removeSize(int index) {
    _listSize.removeAt(index);
  }

  ///Product: Devuelve todas las medidas almacenadas.
  List<String> getSizes() {
    return _listSize;
  }

  //-----------------------------------------------------------------------

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
      "p_subcategory": _subcategory,
      //Construye una cadena con todos los elementos de la lista separados por ','.
      "p_images": _images.join(','),
      "p_sizes": _listSize.join(','),
    };
  }

  @override
  void loadingWithMap(Map<String, dynamic> map) {
    _barcode = map['p_barcode'];
    _internalCode = map['p_internal_code'];
    _title = map['p_title'];
    _description = map['p_description'];
    _brand = map['p_brand'];
    _pricePublic = map['p_price_public'];
    _stock = map['p_stock'];
    _subcategory = map['p_subcategory'];
    _images = (map['p_images'] == null) ? [] : map['p_images'].split(",");
    _listSize = (map['p_sizes'] == null) ? [] : map['p_sizes'].split(",");
  }
}
