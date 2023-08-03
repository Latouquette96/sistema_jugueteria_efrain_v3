import 'package:flutter_riverpod/flutter_riverpod.dart';

///Proveedor para almacenar la url del servidor.
final urlLoginProvider = Provider<String>((ref) => "127.0.0.1:3000");