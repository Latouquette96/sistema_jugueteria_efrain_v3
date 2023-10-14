import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

/*
 * Providers para la conexion a MySQL.
 */

///Proveedor para almacenar la url (o ip) del servidor.
final urlLoginMySQLProvider = StateProvider<String>((ref) => "127.0.0.1");

///Proveedor para almacenar el usuario.
final userLoginMySQLProvider = StateProvider<String>(((ref) => "user"));

///Proveedor para almacenar el password.
final passwordLoginMySQLProvider = StateProvider<String>(((ref) => "password"));

///Provider para realizar la conexion a la base de datos MySQL.
final connectionMySQLProvider = FutureProvider<Map<String,dynamic>>((ref) async{

  Map<String, String> connectionMySQL = {
    "db_host": ref.watch(urlLoginMySQLProvider),
    "db_user": ref.watch(userLoginMySQLProvider),
    "db_password": ref.watch(passwordLoginMySQLProvider)
  };

  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  final response = await http.post(
    Uri.http(url, '/mysql/connect'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(connectionMySQL),
  );

  return jsonDecode(response.body);
});

///Provider para cerrar la conexion a la base de datos MySQL.
final closeConnectionMySQLProvider = FutureProvider<Map<String,dynamic>>((ref) async{
  final url = ref.watch(urlAPIProvider);

  //Realiza la petición POST para insertar el producto.
  final response = await http.post(
    Uri.http(url, '/mysql/close'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );

  return jsonDecode(response.body);
});