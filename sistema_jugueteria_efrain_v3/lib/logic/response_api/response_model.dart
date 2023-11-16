import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

///Clase ResponseAPI: Modela un mensaje recibido de una solicitud a la API.
class ResponseAPI {
  //Atributos de instancia
  late Map<String, dynamic> _response;

  ///Constructor de ResponseAPI a partir de un Response (http).
  ResponseAPI.fromResponse({required Response response}){
    try{
      _response = response.data;
    }
    catch(e){
      _response = jsonDecode(response.data);
    }
  }

  ///Constructor de ResponseAPI a partir de un Response (http).
  ResponseAPI.fromResponseHttp({required http.Response response}){
    _response = jsonDecode(response.body);
  }

  ///Constructor de ResponseAPI a partir de datos brindados manualmente.
  ResponseAPI.manual({
    required int status,
    required dynamic value,
    String? error,
    String? message,
    required String title
  }){
    _response = {
        'status': status,
        'value': value,
        'error': error,
        'message': message,
        'title': title
    };
  }

  ///ResponseAPI: Devuelve el status de la solicitud.
  int getStatus(){
    return _response['status'];
  }

  ///ResponseAPI: Comprueba si la solicitud fue exitosa (status=200 o status=201) o no.
  bool isResponseSuccess(){
    return (_response['status']==200 || _response['status']==201);
  }

  ///ResponseAPI: Devuelve el valor de la solicitud (si ocurre error, es seguro que el valor es null).
  dynamic getValue(){
    return _response['value'];
  }

  ///ResponseAPI: Devuelve el título del mensaje.
  String getTitle(){
    return _response['title'];
  }

  ///ResponseAPI: Devuelve el texto de error (puede no existir).
  ///Es seguro que si [status] es [200] o [201], entonces el error es nulo.
  String? getError(){
    return _response['error'].toString();
  }

  ///ResponseAPI: Devuelve el texto de mensaje.
  String? getMessage(){
    return _response['message'];
  }

  ///ResponseApiJSON: Devuelve un mensaje que indica que ocurrió un problema.
  static ResponseAPI getProblemOccurredMessage(){
    return ResponseAPI.manual(
        status: 400,
        value: null,
        title: "Error 404",
        message: 'Error: No se pudo realizar la solicitud al servidor.'
    );
  }

  ///ResponseApiJSON: Devuelve un mensaje que indica que ocurrió un problema.
  static ResponseAPI getConnectionErrorMessage(dynamic e){
    return ResponseAPI.manual(
        status: 404,
        value: null,
        error: e.toString(),
        title: "Error 404",
        message: 'Error: No se pudo realizar la conexion con el servidor.'
    );
  }
}

///Clase ResponseSystem: Modela respuesta de las operaciones en el sistema.
///[F] es el tipo de datos del valor.
class ResponseSystem<F> extends ResponseAPI{

  ResponseSystem.manual({required super.status, required super.value, required super.title, super.message, super.error}) : super.manual();


  @override
  F? getValue(){
    return (super.getValue()!=null) ? super.getValue() as F : null;
  }
}