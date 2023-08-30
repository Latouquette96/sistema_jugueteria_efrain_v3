import 'package:flutter_riverpod/flutter_riverpod.dart';

///Proveedor para almacenar la url del servidor.
final urlLoginProvider = StateProvider<String>((ref) => "127.0.0.1:3000");

final userLoginProvider = StateProvider<String>(((ref) => "user"));

final passwordLoginProvider = StateProvider<String>(((ref) => "password"));