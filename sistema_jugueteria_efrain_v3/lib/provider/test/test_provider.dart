import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

final testMultipleRows = FutureProvider<void>((ref) async {
  String url = ref.watch(urlAPIProvider);

  //Envio la solicitud POST para cargar
  await http.post(
    Uri.http(url, '/tests/multipleRows/'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  );
});