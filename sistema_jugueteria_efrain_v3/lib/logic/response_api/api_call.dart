import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';

///Clase APICall: Modela las operaciones POST, PUT y DELETE y permite retornar un ResponseAPI con el fin de modelar la respuesta del servidor.
class APICall {

  ///APICall: Realiza la solicitud de operación POST sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> post({required String url, required String route, Map<String, dynamic>? body}) async{
    http.Response response = await http.post(
      Uri.http(url, route),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: (body!=null) ? jsonEncode(body) : null,
    );

    return ResponseAPI.fromResponse(response: response);
  }

  ///APICall: Realiza la solicitud de operación PUT sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> put({required String url, required String route, Map<String, dynamic>? body}) async{
    http.Response response = await http.put(
      Uri.http(url, route),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: (body!=null) ? jsonEncode(body) : null,
    );

    return ResponseAPI.fromResponse(response: response);
  }

  ///APICall: Realiza la solicitud de operación DELETE sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> delete({required String url, required String route, Map<String, dynamic>? body}) async{
    http.Response response = await http.delete(
      Uri.http(url, route),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: (body!=null) ? jsonEncode(body) : null,
    );

    return ResponseAPI.fromResponse(response: response);
  }

  ///APICall: Realiza la solicitud de operación GET sobre la API y retorna una respuesta del servidor.
  static Future<ResponseAPI> get({required String url, required String route}) async{
    http.Response response = await http.get(
      Uri.http(url, route),
      headers: {'Content-Type': 'application/json; charset=UTF-8'}
    );

    return ResponseAPI.fromResponse(response: response);
  }
}