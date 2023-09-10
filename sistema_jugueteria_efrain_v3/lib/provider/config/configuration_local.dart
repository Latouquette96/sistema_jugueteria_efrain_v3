import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';

///configurationProvider: Provider que permite obtener la configuraciones.
final configurationProvider = Provider<ConfigurationLocal>((ref) => ConfigurationLocal.getInstance());

///configImagePathProvider: Configuración del directorio de imagen.
final configImagePathProvider = Provider<String>((ref){
  final config = ref.watch(configurationProvider);

  return config.getValue(ConfigurationLocal.getKeyImagePath())!;
});

///Clase ConfigurationLocal: Modela las configuraciones del sistema empleando un SharedPreferences para almacenar los datos.
class ConfigurationLocal {
  //Atributos de instancia
  late SharedPreferences _sharedPreferences;
  late Map<String, Pair<String, String>> _map;

  //Instancia
  static final ConfigurationLocal _instance = ConfigurationLocal._();

  //Atributos de clase
  static const String _keyImagePath = "config_image_path";
  static const String _keyCatalogPath = "config_catalog_path";
  static const String _keyShopPath = "config_shop_path";
  static const String _keyBillingsPath = "config_billings_path";

  ///Constructor de ConfigurationLocal
  ConfigurationLocal._(){
    _map = {
      _keyImagePath: Pair<String, String>(v1: "Directorio de imágenes", v2: "Sin definir"),
      _keyCatalogPath: Pair<String, String>(v1: "Directorio de catálogo de productos", v2: "Sin definir"),
      _keyShopPath: Pair<String, String>(v1: "Directorio de facturas de ventas", v2: "Sin definir"),
      _keyBillingsPath: Pair<String, String>(v1: "Directorio de facturas de distribuidoras", v2: "Sin definir")
    };
  }

  ///ConfigurationLocal: Devuelve la clave para el directorio donde se almacenarán los catálogos.
  static String getKeyCatalogPath(){
    return _keyCatalogPath;
  }

  ///ConfigurationLocal: Inicializa las configuraciones del sistema.
  Future<void> initialize() async {
    //Recupera la instancia de SharedPreferences.
    _sharedPreferences = await SharedPreferences.getInstance();

    //Obtengo el directorio por defecto para Android o cualquier otra plataforma.
    String dir = (Platform.isAndroid)
      ? (await getApplicationDocumentsDirectory()).path
      : (await getDownloadsDirectory())!.path;

    for (String key in _map.keys){
      _map[key]!.setValue2(_sharedPreferences.getString(_keyImagePath) ?? dir);
    }
  }

  ///ConfigurationLocal: Establece el valor para una clave dada.
  Future<void> _setValue(String key, String directory) async{
    await _sharedPreferences.setString(key, directory);
    _map[key]!.setValue2(directory);
  }

  ///ConfigurationLocal: Almacena todos los valores del mapeo dado.
  Future<void> setValueMap(Map<String, String> map) async{
    map.forEach((key, value) async {
      await _setValue(key, value);
    });
  }

  ///ConfigurationLocal: Devuelve el valor de una determinada clave.
  String? getValue(String key){
    String? toReturn;

    try{
      toReturn = _map[key]!.getValue2();
    }
    catch(e){
      toReturn = null;
    }

    return toReturn;
  }

  ///ConfigurationLocal: Devuelve la clave de la ruta de imagen.
  static String getKeyImagePath(){
    return _keyImagePath;
  }

  ///ConfigurationLocal: Devuelve el titulo de una determinada clave.
  String? getTitle(String key){
    String? toReturn;

    try{
      toReturn = _map[key]!.getValue1();
    }
    catch(e){
      toReturn = null;
    }

    return toReturn;
  }

  ///ConfigurationLocal: Devuelve un iterable de claves.
  List<String> getKeys(){
    return _map.keys.toList();
  }

  ///ConfigurationLocal: Devuelve la instancia en ejecucion de la ConfigurationLocal.
  static ConfigurationLocal getInstance(){
    return _instance;
  }
}