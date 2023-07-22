import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/link_image.dart';

///Clase Product: Modela a un producto con todos sus atributos.
class Product with MixinJSONalizable<Product> {
  ///Atributos de instancia
  late int _id;
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
  late int _dateUpdate; //RN-P22.
  late int _dateCreate; //RN-P22.

  //Atributos de clase
  static const int _maxCharsBarcode = 48; //RN-P15
  static const int _maxCharsTitle = 65; //RN-P16
  static const int _maxCharsDescription = 9999; //RN-P17
  static const int _maxCharsBrand = 100; //RN-P18.

  static const String _keyID           = "p_id";
  static const String _keyBarcode      = "p_barcode";
  static const String _keyInternalCode = "p_internal_code";
  static const String _keyTitle        = "p_title";
  static const String _keyDescription  = "p_description";
  static const String _keyBrand        = "p_brand";
  static const String _keyPricePublic  = "p_price_public";
  static const String _keyStock        = "p_stock";
  static const String _keySubcategory  = "p_subcategory";
  static const String _keyImages       = "p_images";
  static const String _keySizes        = "p_sizes";
  static const String _keyDateUpdated  = "p_date_updated";
  static const String _keyDateCreated  = "p_date_created";


  ///Product: Constructor genérico de producto.
  Product({
    int id = 0,
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
    int dateCreate = 0,
    int dateUpdate = 0,
  }) {
    _id = id;
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
    _dateCreate = (dateCreate == 0) ? DatetimeCustom.getDatetimeIntegerNow() : dateCreate;
    _dateUpdate = dateUpdate;
  }

  ///Product: Constructor de Product con datos JSON.
  Product.fromJSON(Map<String, dynamic> map) {
    fromJSON(map);
  }

  ///Product: Constructor de Product limpio (sin datos definidos).
  Product.clean() {
    _id = 0;
    _barcode = "-";
    _internalCode = "-";
    _title = "-";
    _description = "-";
    _brand = "IMPORT.";
    _pricePublic = 0.00;
    _stock = 0;
    _subcategory = 0;
    _images = [];
    _listSize = [];
    _dateCreate = 0;
    _dateUpdate = 0;
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

  //------------------ID---------------------------------------------

  ///Product: Devuelve el ID del producto.
  int getID() {
    return _id;
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

  //------------------FECHAS DE ACTUALIZACION Y CREACION-------------------

  ///Product: Devuelve la ultima fecha de actualización de los datos del producto.
  String getDateUpdate() {
    return DatetimeCustom.getDatetimeString(_dateUpdate);
  }

  ///Product: Devuelve la fecha de creación del producto.
  String getDateCreate() {
    return DatetimeCustom.getDatetimeString(_dateCreate);
  }

  //-----------------------------------------------------------------------

  @override
  Map<String, dynamic> getJSON() {
    return {
      _keyID: _id,
      _keyBarcode: _barcode,
      _keyInternalCode: _internalCode,
      _keyTitle: _title,
      _keyDescription: _description,
      _keyBrand: _brand,
      _keyPricePublic: _pricePublic,
      _keyStock: _stock,
      _keySubcategory: _subcategory,
      //Construye una cadena con todos los elementos de la lista separados por ','.
      _keyImages: _images.join(','),
      _keySizes: _listSize.join(','),
      _keyDateCreated: _dateCreate,
      _keyDateUpdated: _dateUpdate
    };
  }

  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = map[_keyID];
    _barcode = map[_keyBarcode];
    _internalCode = map[_keyInternalCode];
    _title = map[_keyTitle];
    _description = map[_keyDescription];
    _brand = map[_keyBrand];
    _pricePublic = map[_keyPricePublic];
    _stock = map[_keyStock];
    _subcategory = map[_keySubcategory];
    _images = (map[_keyImages] == null) ? [] : map[_keyImages].split(",");
    _listSize = (map[_keySizes] == null) ? [] : map[_keySizes].split(",");
    _dateCreate = int.parse(map[_keyDateCreated]);
    _dateUpdate = int.parse(map[_keyDateUpdated]);
  }
}
