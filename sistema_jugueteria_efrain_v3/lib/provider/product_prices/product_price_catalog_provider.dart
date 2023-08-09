import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product_prices/product_price_provider.dart';

///Proveedor para recuperar TODOS los precios existentes para un producto determinado.
final getProductPricesByIDProviderAux = FutureProvider<List<ProductPrice>>((ref) async {

  String url = ref.watch(urlLoginProvider);

  //Producto sobre el cual se busca los precios de producto.
  final product = ref.watch(productSearchPriceProvider);
  //Peticion GET para obtener los precios de producto.
  final content = await http.get(Uri.http(url, '/products/prices_products/${product!.getID()}'));
  List<dynamic> map = convert.jsonDecode(content.body);
  List<ProductPrice> list = map.map((e) => ProductPrice.fromJSON(e)).toList();


  return list;
});

///Proveedor para recuperar TODOS los precios existentes para un producto determinado.
///• v1: Lista de pares Distribuidora con su respectivo precio de producto.
///• v2: Lista de distribuidoras libres.
final getProductPricesByIDProvider = FutureProvider<Pair<List<Pair<Distributor, ProductPrice>>, List<Distributor>>>((ref) async {

  String url = ref.watch(urlLoginProvider);

  //Producto sobre el cual se busca los precios de producto.
  final product = ref.watch(productSearchPriceProvider);

  //Obtiene todas las distribuidoras existentes.
  List<Distributor> listDistributor = (await ref.read(catalogDistributorProvider.future)).getValue2()!;

  //Obtiene todos los precios de producto
  //Peticion GET para obtener los precios de producto.
  final content = await http.get(Uri.http(url, '/products/prices_products/${product!.getID()}'));
  List<dynamic> map = convert.jsonDecode(content.body);
  List<ProductPrice> list = map.map((e) => ProductPrice.fromJSON(e)).toList();

   //Computa ambas listas (ditribuidora y precios en una sola)
  List<Pair<Distributor, ProductPrice>> listProduct = list.map((e){
    Distributor d = listDistributor.firstWhere((element) => element.getID()==e.getDistributor());
      return Pair(v1: d, v2: e);
    }).toList();
    
  //Recupera un listado de distribuidoras libres para el producto.
  List<Distributor> listDistributorFree = listDistributor.where((distr){
    bool isFree = true;
    if (listProduct.isNotEmpty){
      int i = 0;
      //Para cada distr, se comprueba si pertenece a la lista de productos.
      while(isFree && i<listProduct.length){
        //Está libre la distribuidora siempre y cuando no esté en la lista de productos.
        isFree = listProduct[i].getValue1().getID()!=distr.getID();
        i++;
      }
    }
    return isFree;
  }).toList();

  return Pair<List<Pair<Distributor, ProductPrice>>, List<Distributor>>(v1: listProduct, v2: listDistributorFree);
});


///Proveedor para crear un precio de producto en particular.
final newProductPriceWithAPIProvider = FutureProvider<Response>((ref) async {
  String url = ref.watch(urlLoginProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceProvider);
  //Envio la solicitud POST para cargar
  final response = await http.post(
    Uri.http(url, '/products/prices_products/'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(productPrice!.getJSON()), 
  );

  return response;  
});

///Proveedor para modificar un precio de producto en particular.
final updateProductPriceWithAPIProvider = FutureProvider<Response>((ref) async {
  String url = ref.watch(urlLoginProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceProvider);
  //Envio la solicitud POST para cargar
  final response = await http.put(
    Uri.http(url, '/products/prices_products/${productPrice!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode(productPrice.getJSON()), 
  );

  return response;  
});

///Proveedor para remover un precio de producto en particular.
final removeProductPriceWithAPIProvider = FutureProvider<Response>((ref) async {
  String url = ref.watch(urlLoginProvider);

  //Recupero el producto.
  final productPrice = ref.watch(productPriceRemoveProvider);
  //Envio la solicitud POST para cargar
  final response = await http.delete(
    Uri.http(url, '/products/prices_products/${productPrice!.getID()}'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'}
  );

  return response;  
});