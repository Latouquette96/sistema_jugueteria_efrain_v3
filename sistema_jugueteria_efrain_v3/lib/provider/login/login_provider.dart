import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
 * Providers para la conexion a la REST API.
 */

///Proveedor para almacenar la url (o ip) del servidor.
final urlLoginProvider = StateProvider<String>((ref) => "127.0.0.1");

///Proveedor para almacenar el puerto de la API.
final portLoginProvider = StateProvider<String>((ref) => "3000");

///Proveedor para almacenar el usuario.
final userLoginProvider = StateProvider<String>(((ref) => "user"));

///Proveedor para almacenar el password.
final passwordLoginProvider = StateProvider<String>(((ref) => "password"));

///Proveedor para almacenar la url definitiva para conectar a la API.
final urlAPIProvider = StateProvider((ref) => "${ref.read(urlLoginProvider)}:${ref.read(portLoginProvider)}");