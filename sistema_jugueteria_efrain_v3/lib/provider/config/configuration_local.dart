import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///configurationProvider: Provider que permite obtener la configuraciones.
final configurationProvider = Provider<ConfigurationLocal>((ref) => ConfigurationLocal.getInstance());

///Clase ConfigurationLocal: Modela las configuraciones del sistema empleando un SharedPreferences para almacenar los datos.
class ConfigurationLocal {
  //Atributos de instancia
  late SharedPreferences _sharedPreferences;

  //Instancia
  static final ConfigurationLocal _instance = ConfigurationLocal._();

  //Atributos de clase
  static const String _keyImagePath = "config_image_path";
  static const String _keyCatalogPath = "config_catalog_path";
  static const String _keyShopPath = "config_shop_path";
  static const String _keyBillingsPath = "config_billings_path";
  static const String _keyInfoExpansionTile = "config_info_expansion_tile";

  late String _valueImagePath;
  late String _valueCatalogPath;
  late String _valueShopPath;
  late String _valueBillingsPath;
  late bool   _valueInfoExpansionTile;

  ///Constructor de ConfigurationLocal
  ConfigurationLocal._(){
    _valueImagePath = "Sin definir directorio";
    _valueCatalogPath = "Sin definir directorio";
    _valueShopPath = "Sin definir directorio";
    _valueBillingsPath = "Sin definir directorio";
    _valueInfoExpansionTile = false;
  }

  ///ConfigurationLocal: Devuelve la clave para el directorio donde se almacenarán los catálogos.
  static String getKeyCatalogPath(){
    return _keyCatalogPath;
  }

  ///ConfigurationLocal: Devuelve la clave para el directorio donde se almacenarán las imágenes.
  static String getKeyImagePath(){
    return _keyImagePath;
  }

  ///ConfigurationLocal: Devuelve la clave para el directorio donde se almacenarán los archivos de ventas realizadas.
  static String getKeyShopPath(){
    return _keyShopPath;
  }

  ///ConfigurationLocal: Devuelve la clave para el directorio donde se almacenarán las facturas de las distribuidoras.
  static String getKeyBillingPath(){
    return _keyBillingsPath;
  }

  ///ConfigurationLocal: Devuelve la clave para la opcion de mostrar información en expansionTile.
  static String getKeyInfoExpansionTile(){
    return _keyInfoExpansionTile;
  }

  ///ConfigurationLocal: Inicializa las configuraciones del sistema.
  Future<void> initialize() async {
    //Recupera la instancia de SharedPreferences.
    _sharedPreferences = await SharedPreferences.getInstance();
    String dir =  (await getDownloadsDirectory())!.path;

    _valueImagePath = _sharedPreferences.getString(_keyImagePath) ?? dir;
    _valueBillingsPath = _sharedPreferences.getString(_keyBillingsPath) ?? dir;
    _valueCatalogPath = _sharedPreferences.getString(_keyCatalogPath) ?? dir;
    _valueShopPath = _sharedPreferences.getString(_keyShopPath) ?? dir;
    _valueInfoExpansionTile = _sharedPreferences.getBool(_keyInfoExpansionTile) ?? true;
  }

  ///ConfigurationLocal: Establece el valor
  Future<void> setValueImagePath(String directory) async{
    await _sharedPreferences.setString(_keyImagePath, directory);
    _valueImagePath = directory;
  }

  ///ConfigurationLocal: Establece el valor
  Future<void> setValueCatalogPath(String directory) async{
    await _sharedPreferences.setString(_keyCatalogPath, directory);
    _valueCatalogPath = directory;
  }

  ///ConfigurationLocal: Establece el valor.
  Future<void> setValueShopPath(String directory) async{
    await _sharedPreferences.setString(_keyShopPath, directory);
    _valueShopPath = directory;
  }

  ///ConfigurationLocal: Establece el valor.
  Future<void> setValueBillingPath(String directory) async{
    await _sharedPreferences.setString(_keyBillingsPath, directory);
    _valueBillingsPath = directory;
  }

  ///ConfigurationLocal: Establece el valor para una clave dada.
  Future<void> setInfoExpansionTile(bool value) async{
    await _sharedPreferences.setBool(_keyInfoExpansionTile, value);
    _valueInfoExpansionTile = !_valueInfoExpansionTile;
  }


  ///ConfigurationLocal: Devuelve el valor
  String getValueImagePath() {
    return _valueImagePath;
  }

  ///ConfigurationLocal: Devuelve el valor
  String getValueCatalogPath() {
    return _valueCatalogPath;
  }

  ///ConfigurationLocal: Devuelve el valor.
  String getValueShopPath() {
    return _valueShopPath;
  }

  ///ConfigurationLocal: Devuelve el valor.
  String getValueBillingPath() {
    return _valueBillingsPath;
  }

  ///ConfigurationLocal: Devuelve el valor.
  bool isShowInfoExpansionTile() {
    return _valueInfoExpansionTile;
  }

  ///ConfigurationLocal: Devuelve la instancia en ejecucion de la ConfigurationLocal.
  static ConfigurationLocal getInstance(){
    return _instance;
  }
}