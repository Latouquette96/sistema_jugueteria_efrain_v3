import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';

///Proveedor para eliminar un producto en particular.
final filterOfLoadedBrandsWithAPIProvider = FutureProvider<List<String>>((ref) async {

  final url = ref.watch(urlLoginProvider);
  final content = await http.get(Uri.http(url, '/filter/brands'));

  List<dynamic> map = jsonDecode(content.body);
  List<String> list = map.map((e){
    return e['p_brand'].toString();
  }).toList();

  if (list.isEmpty){
    list.add(Product.getBrandDefect());
  }

  return list; 
});