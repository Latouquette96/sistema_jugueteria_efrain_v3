import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';

///Clase GeneratedCodeNotifier: Permite almacenar el codigo generado hasta que sea liberado o reservado.
class GeneratedCodeNotifier extends StateNotifier<String?> {
  //Atributos de provider.
  late final StateNotifierProviderRef<GeneratedCodeNotifier, String?> _ref;

  ///Constructor de GeneratedCodeNotifier
  GeneratedCodeNotifier(super.state, {required StateNotifierProviderRef<GeneratedCodeNotifier, String?> ref}){
    _ref = ref;
  }

  ///GeneratedCodeNotifier: Carga, en caso de ser un código generado, el código del producto.
  Future<void> loadCode(Product p) async {
    if (isGenerateCode(p.getBarcode())){
      state = p.getBarcode();
    }
  }

  ///GeneratedCodeNotifier: Liberar el código vinculado para el producto dado.
  Future<bool> freeCode() async {
    bool resultado = false;

    if (state!=null){
      final product = _ref.watch(productProvider);
      final url = _ref.watch(urlAPIProvider);

      //Realiza la petición POST para insertar el producto.
      ResponseAPI responseAPI = await APICall.put(
          url: url,
          route: '/code_generated/free/${product!.getID()}'
      );

      if (responseAPI.isResponseSuccess()){
        resultado = true;
        //Libera el estado.
        state = null;
      }
    }

    return resultado;
  }

  ///GeneratedCodeNotifier: Realiza la reserva del código para el producto dado.
  Future<bool> reserveCode() async {
    final url = _ref.watch(urlAPIProvider);
    final p = _ref.watch(productProvider);
    bool result = false;

    if (state!=null){
      result = await reserveGeneratedCode(url, p!, state!);
      if (result) state = null;
    }

    return result;
  }

  ///GeneratedCodeNotifier: Realiza la reserva del código generado para un producto.
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


  ///GeneratedCodeNotifier: Obtiene un nuevo código para el producto (o el mismo si el producto tiene un código generado).
  Future<String> generateCode() async {
    final url = _ref.watch(urlAPIProvider);
    final product = _ref.watch(productProvider);

    //Obtiene el código de producto.
    String code = product!.getBarcode();

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
    state = code;

    return code;
  }

  ///GeneratedCodeNotifier: Libera el código generado.
  void free(){
    if (state!=null) state = null;
  }

  ///GeneratedCodeNotifier: Comprueba si el barcode del producto es generado o no.
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

  ///GeneratedCodeNotifier: Devuelve el entero positivo asociado al identificador de código generado.
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
}

///Provider para controlar el estado de un código generado.
final generatedCodeProvider = StateNotifierProvider<GeneratedCodeNotifier, String?>((ref) => GeneratedCodeNotifier(null, ref: ref));