import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

///Clase GeneratedCodeController: Permite almacenar el codigo generado hasta que sea liberado o reservado.
class GeneratedCodeController {
  static final GeneratedCodeController _instance = GeneratedCodeController._();
  
  //Atributos de provider.
  late String? _generateCode;

  ///Constructor de GeneratedCodeController
  GeneratedCodeController._(){
    _generateCode = null;
  }

  ///GeneratedCodeController: Devuelve el código generado (en caso de existir), de lo contrario, null.
  String? getGenerateCode(){
    return _generateCode;
  }

  ///GeneratedCodeController: Carga, en caso de ser un código generado, el código del producto.
  Future<void> loadCode(Product p) async {
    if (isGenerateCode(p.getBarcode())){
      _generateCode = p.getBarcode();
    }
  }

  ///GeneratedCodeController: Liberar el código vinculado para el producto dado.
  Future<bool> freeCode(String url, Product product) async {
    bool resultado = false;

    if (_generateCode!=null){
      //Realiza la petición POST para insertar el producto.
      ResponseAPI responseAPI = await APICall.put(
          url: url,
          route: '/code_generated/free/${product.getID()}'
      );

      if (responseAPI.isResponseSuccess()){
        resultado = true;
        //Libera el estado.
        _generateCode = null;
      }
    }

    return resultado;
  }

  ///GeneratedCodeController: Realiza la reserva del código para el producto dado.
  Future<bool> reserveCode(String url, Product product) async {
    bool result = false;

    if (_generateCode!=null){
      result = await reserveGeneratedCode(url, product, _generateCode!);
      if (result) _generateCode = null;
    }

    return result;
  }

  ///GeneratedCodeController: Realiza la reserva del código generado para un producto.
  static Future<bool> reserveGeneratedCode(String url, Product p, String code) async {
    bool resultado = false;
    int id = getGenerateCodeInteger(code);

    //Realiza la petición POST para insertar el producto.
    ResponseAPI responseAPI = await APICall.put(
        url: url,
        route: '/code_generated/$id',
        body: {
          'cg_product': p.getID()
        }
    );

    if (responseAPI.isResponseSuccess()){
      resultado = true;
    }

    return resultado;
  }


  ///GeneratedCodeController: Obtiene un nuevo código para el producto (o el mismo si el producto tiene un código generado).
  Future<String> generateCode(String url, Product product) async {

    //Obtiene el código de producto.
    String code = product.getBarcode();

    if (isGenerateCode(code)==false){
      ResponseAPI responseCode = await APICall.get(
          url: url,
          route: "/code_generated/first_free"
      );

      //Si la respuesta es afirmativa, entonces retornar el nuevo código.
      if (responseCode.isResponseSuccess()){
        code = "-${responseCode.getValue()}";
      }
    }

    //Actualiza el estado con el código obtenido.
    _generateCode = code;

    return code;
  }

  ///GeneratedCodeController: Libera el código generado.
  void free(){
    if (_generateCode!=null) _generateCode = null;
  }

  ///GeneratedCodeController: Comprueba si el barcode del producto es generado o no.
  static bool isGenerateCode(String code){
    bool isGenerate = true;

    try{
      int codeInt = int.parse(code);
      if (codeInt>0){
        isGenerate = false;
      }
    }
    catch(e){
      isGenerate = false;
    }

    return isGenerate;
  }

  ///GeneratedCodeController: Devuelve el entero positivo asociado al identificador de código generado.
  static int getGenerateCodeInteger(String code){
    int generateCode = 0;

    try{
      generateCode = int.parse(code);
      if (generateCode<0){
        generateCode = generateCode * -1;
      }
    }
    catch(e){
      generateCode = 0;
    }

    return generateCode;
  }
  
  static GeneratedCodeController getInstance(){
    return _instance;
  }
}