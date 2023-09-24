import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/controller/connection_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/enum/response_status_code.dart';

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
final connectionMySQLProvider = FutureProvider<ResponseStatusCode>((ref) async{

  bool response = await MySQLConnection.getConnection().connect(
    server: ref.watch(urlLoginMySQLProvider),
    user: ref.watch(userLoginMySQLProvider),
    pass: ref.watch(passwordLoginMySQLProvider)
  );

  return (response) ? ResponseStatusCode.statusCodeOK : ResponseStatusCode.statusCodeFailded;
});