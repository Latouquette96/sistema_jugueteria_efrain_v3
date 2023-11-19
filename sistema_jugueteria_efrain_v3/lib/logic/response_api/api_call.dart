import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

///Clase APICall: Modela las operaciones POST, PUT y DELETE y permite retornar un ResponseAPI con el fin de modelar la respuesta del servidor.
class APICall {

  ///APICall: Realiza la solicitud de operación POST sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> post({required String url, required String route, Map<String, dynamic>? body}) async{
    Dio dio = Dio();

    try{
      Response response = await dio.post(
        Uri.http(url, route).toString(),
        options: Options(
            contentType: "${Headers.jsonContentType}; charset=UTF-8",
            responseType: ResponseType.json
        ),
        data: (body!=null) ? jsonEncode(body) : null,
      );

      return ResponseAPI.fromResponse(response: response);
    }
    catch(e){
      return ResponseAPI.getConnectionErrorMessage(e);
    }
  }

  ///APICall: Realiza la solicitud de operación PUT sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> put({required String url, required String route, Map<String, dynamic>? body}) async{
    Dio dio = Dio();
    
    try{
      Response response = await dio.put(
        Uri.http(url, route).toString(),
        options: Options(
            contentType: "${Headers.jsonContentType}; charset=UTF-8",
            responseType: ResponseType.json
        ),
        data: (body!=null) ? jsonEncode(body) : null,
      );

      return ResponseAPI.fromResponse(response: response);
    }
    catch(e){
      return ResponseAPI.getConnectionErrorMessage(e);
    }
  }

  ///APICall: Realiza la solicitud de operación DELETE sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> delete({required String url, required String route, Map<String, dynamic>? body}) async{
    Dio dio = Dio();
    
    try{
      Response response = await dio.delete(
        Uri.http(url, route).toString(),
        options: Options(
            contentType: "${Headers.jsonContentType}; charset=UTF-8",
            responseType: ResponseType.json
        ),
        data: (body!=null) ? jsonEncode(body) : null,
      );

      return ResponseAPI.fromResponse(response: response);
    }
    catch(e){
      return ResponseAPI.getConnectionErrorMessage(e);
    }
  }

  ///APICall: Realiza la solicitud de operación GET sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> get({required String url, required String route}) async{
    Dio dio = Dio();

    try{
      Response response = await dio.get(
        Uri.http(url, route).toString(),
        options: Options(
            contentType:  "${Headers.jsonContentType}; charset=UTF-8",
            responseType: ResponseType.json
        ),
      );

      return ResponseAPI.fromResponse(response: response);
    }
    catch(e){
      return ResponseAPI.getConnectionErrorMessage(e);
    }
  }
}