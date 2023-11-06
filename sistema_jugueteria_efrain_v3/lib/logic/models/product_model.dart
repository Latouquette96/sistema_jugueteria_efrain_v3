import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/json/factory_category.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/category_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/minimum_age.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/json/subcategory_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';

///Clase Product: Modela a un producto con todos sus atributos.
class Product extends JSONalizable<Product> {
  ///Atributos de instancia
  late int _id;
  late String _barcode; //RN-P1.
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
  late int _minimumAge; 

  //Atributos de clase
  static const int _maxCharsBarcode = 48; //RN-P15
  static const int _maxCharsTitle = 65; //RN-P16
  static const int _maxCharsDescription = 9999; //RN-P17
  static const int _maxCharsBrand = 100; //RN-P18.
  static const String _brandDefect = "IMPORT.";
  
  static const String _keyID           = "p_id";
  static const String _keyBarcode      = "p_barcode";
  static const String _keyTitle        = "p_title";
  static const String _keyDescription  = "p_description";
  static const String _keyBrand        = "p_brand";
  static const String _keyPricePublic  = "p_price_public";
  static const String _keyStock        = "p_stock";
  static const String _keyCategory  = "p_category";
  static const String _keySubcategory  = "p_subcategory";
  static const String _keyImages       = "p_images";
  static const String _keySizes        = "p_sizes";
  static const String _keyDateUpdated  = "p_date_updated";
  static const String _keyDateCreated  = "p_date_created";
  static const String _keyMinimumAge   = "p_minimum_age";

  ///Product: Constructor genérico de producto.
  Product({
    int id = 0,
    required String barcode,
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
    int minimumAge = 0,
  }) {
    _id = id;
    _barcode = barcode;
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
    _minimumAge = minimumAge;
    plutoRow = buildPlutoRow();
  }

  ///Product: Constructor de Product con datos JSON.
  Product.fromJSON(Map<String, dynamic> map) {
    fromJSONServer(map);
  }

  ///Product: Constructor de Product limpio (sin datos definidos).
  Product.clean() {
    _id = 0;
    _barcode = "-";
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
    _minimumAge = 0;
    
    plutoRow = buildPlutoRow();
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

  ///Product: Devuelve la marca por defecto de un producto.
  static String getBrandDefect(){
    return _brandDefect;
  }

  //------------------CLAVES------------------------------------------

  static String getKeyID(){
    return _keyID;
  }

  static String getKeyBarcode(){
    return _keyBarcode;
  }

  static String getKeyTitle(){
    return _keyTitle;
  }

  static String getKeyDescription(){
    return _keyDescription;
  }

  static String getKeyBrand(){
    return _keyBrand;
  }

  static String getKeyPricePublic(){
    return _keyPricePublic;
  }

  static String getKeyStock(){
    return _keyStock;
  }

  static String getKeyCategory(){
    return _keyCategory;
  }

  static String getKeySubcategory(){
    return _keySubcategory;
  }

  static String getKeyImages(){
    return _keyImages;  
  }

  static String getKeySizes(){
    return _keySizes;
  }

  static String getKeyDateUpdated(){
    return _keyDateUpdated;
  }

  static String getKeyDateCreated(){
    return _keyDateCreated;
  }

  static String getKeyMinimumAge(){
    return _keyMinimumAge;
  }

  //-------------------ARCHIVO--------------------------------------

  ///Product: Devuelve el nombre del archivo de imagen de la posicion index.
  String getFileName(int index){

    String name = "$_brand-$_title-$index.jpg";
    name = name.replaceAll('"', '_');
    name = name.replaceAll(">", '');
    name = name.replaceAll("<", '');
    name = name.replaceAll("\\", '');
    name = name.replaceAll("/", '');
    name = name.replaceAll(":", '');
    name = name.replaceAll(";", '');
    name = name.replaceAll("|", '');
    name = name.replaceAll("[", '');
    name = name.replaceAll("]", '');
    name = name.replaceAll("=", '');
    name = name.replaceAll("+", '');
    name = name.replaceAll("*", '');
    name = name.replaceAll("?", '');
    name = name.replaceAll("¿", '');
    name = name.replaceAll("!", '');
    name = name.replaceAll("¡", '');
    name = name.replaceAll("{", '');
    name = name.replaceAll("}", '');
    name = name.replaceAll("^", '');
    name = name.replaceAll("\$", '');
    name = name.replaceAll("%", '');
    name = name.replaceAll("&", '');
    name = name.replaceAll("#", '');
    name = name.replaceAll(" ", '');

    return name;
  }


  //------------------ID---------------------------------------------

  ///Product: Devuelve el ID del producto.
  int getID() {
    return _id;
  }

  ///Product: Establece el ID del producto (solo si id del producto es 0). 
  void setID(int value) {
    _id=value;
  }

  //------------------CODIGO DE BARRAS---------------------------------------------

  ///Product: Devuelve el código de barras.
  String getBarcode() {
    return _barcode;
  }

  ///Product: Establece el código de barras.
  void setBarcode(String value) {
    _barcode = value;
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
  List<ResourceLink> getLinkImages() {
    return _images.map((e) => ResourceLink(e)).toList();
  }

  ///Product: Inserta una nueva imagen al final de la lista.
  void insertLinkImage(String link) {
    _images.add(ResourceLink(link).getLink());
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

  //------------------EDAD MINIMA-------------------

  ///Product: Devuelve la edad minima del producto.
  int getMinimumAge(){
    return _minimumAge;
  }

  ///Product: Establece la edad minima del producto.
  void setMinimumAge(MinimumAge ma){
    _minimumAge = ma.getMinimumAgeID();
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
      _keyTitle: _title,
      _keyDescription: _description,
      _keyBrand: _brand,
      _keyPricePublic: _pricePublic,
      _keyStock: _stock,
      _keySubcategory: _subcategory,
      //Construye una cadena con todos los elementos de la lista separados por ','.
      _keyImages: _images.join(',').replaceAll(' ', ''),
      _keySizes: _listSize.join(','),
      _keyDateCreated: _dateCreate,
      _keyDateUpdated: _dateUpdate,
      _keyMinimumAge: _minimumAge
    };
  }

  Map<String, dynamic> getJSONWithoutID() {
    return {
      _keyBarcode: _barcode,
      _keyTitle: _title,
      _keyDescription: _description,
      _keyBrand: _brand,
      _keyPricePublic: _pricePublic,
      _keyStock: _stock,
      _keySubcategory: _subcategory,
      //Construye una cadena con todos los elementos de la lista separados por ','.
      _keyImages: _images.join(',').replaceAll(' ', ''),
      _keySizes: _listSize.join(','),
      _keyDateCreated: _dateCreate,
      _keyDateUpdated: _dateUpdate,
      _keyMinimumAge: _minimumAge
    };
  }

  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = map[_keyID];
    _barcode = map[_keyBarcode];
    _title = map[_keyTitle];
    _description = map[_keyDescription];
    _brand = map[_keyBrand];
    _pricePublic = map[_keyPricePublic];
    _stock = map[_keyStock];
    _subcategory = (map[_keyCategory] as Category).getCategoryID()*100 + (map[_keySubcategory] as SubCategory).getSubCategoryID();
    _images = (map[_keyImages] == null) ? [] : (map[_keyImages] as List<ResourceLink>).map((e) => e.getLink()).toList();
    _listSize = (map[_keySizes] == null) ? [] : (map[_keySizes] as List<String>);
    try{
      _dateCreate = DatetimeCustom.parseStringDatetime(map[_keyDateCreated]);
      _dateUpdate = DatetimeCustom.parseStringDatetime(map[_keyDateUpdated]);
    }
    catch(e){
      _dateCreate = DatetimeCustom.getDatetimeIntegerNow();
      _dateUpdate = 0;
    }
    _minimumAge = (map[_keyMinimumAge] as MinimumAge).getMinimumAgeID();

    plutoRow = buildPlutoRow();
  }
  
  ///Product: Carga los dato del producto con un mapeo proveniente del servidor.
  void fromJSONServer(Map<String, dynamic> map) {
    String imageString =  map[_keyImages].toString().replaceAll("[", "");
      imageString =  imageString.replaceAll("]", "");

      _id = map[_keyID];
      _barcode = map[_keyBarcode];
      _title = map[_keyTitle];
      _description = map[_keyDescription];
      _brand = map[_keyBrand];
      _pricePublic = double.parse(map[_keyPricePublic].toString());
      _stock = map[_keyStock];
      _subcategory = map[_keySubcategory];
      _images = imageString.replaceAll(' ', '').split(',');
      _listSize = map[_keySizes].split(',');
      _dateCreate = int.parse(map[_keyDateCreated].toString());
      _dateUpdate = int.parse(map[_keyDateUpdated].toString());
      _minimumAge = map[_keyMinimumAge];
      
      plutoRow = buildPlutoRow();
  }

  //--------------------GRAFICOS---------------------

  @override
  PlutoRow buildPlutoRow(){
    var categoryPair = FactoryCategory.getInstance().search(getSubcategory());
    
    plutoRow = PlutoRow(
        type: PlutoRowType.normal(),
        checked: false,
        cells: {
          "p_options": PlutoCell(),
          Product.getKeyID(): PlutoCell(value: _id),
          Product.getKeyBarcode(): PlutoCell(value: getBarcode()),
          Product.getKeyTitle(): PlutoCell(value: getTitle()),
          Product.getKeyBrand(): PlutoCell(value: getBrand()),
          Product.getKeyCategory(): PlutoCell(value: "${categoryPair.getValue1()!.getCategoryName()} > ${categoryPair.getValue2()!.getSubCategoryName()}"),
          Product.getKeyStock(): PlutoCell(value: getStock()),
          Product.getKeyPricePublic(): PlutoCell(value: getPricePublic()),
       },
    );
    return plutoRow!; 
  }
}
