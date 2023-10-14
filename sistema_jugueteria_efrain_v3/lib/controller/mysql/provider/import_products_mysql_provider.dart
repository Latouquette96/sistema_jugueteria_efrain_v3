import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_from_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_product_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/response_api_json_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase ImportProductMySQLProvider: Modela las operaciones CRUD sobre MySQL.
class ImportProductMySQLProvider extends StateNotifier<List<Triple<Product, Distributor, double>>> {
  //Atributos de clase
  final StateNotifierProviderRef<ImportProductMySQLProvider, List<Triple<Product, Distributor, double>>> ref;

  ///Constructor privado de ImportProductMySQLProvider
  ImportProductMySQLProvider(this.ref): super([]);

  ///ImportProductMySQLProvider: Inicializa el arreglo de producto.
  Future<void> initialize({BuildContext? context}) async{
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlAPIProvider);
    //Mapeo con el contenido a mostrar
    Map<String, dynamic> map;

    try{
      List<Distributor> distributors = ref.watch(catalogDistributorProvider);

      final content = await http.get(Uri.http(url, "/mysql/products"));
      map = jsonDecode(content.body);

      List<Triple<Product, Distributor, double>> list = [];

      if (map['status']==200 || map['status']==201){
        List<Product> listProducts = ref.watch(productCatalogProvider);
        //Para cada fila de los resultados obtenidos.
        for (Map<String, dynamic> row in map['value']){
          //Recupera las tres coluumnas principales de la consulta.
          Map<String, dynamic> mapProductRow = jsonDecode(row['product']);
          Map<String, dynamic> mapProductPriceRow = jsonDecode(row['price_product']);
          //Construye el producto de acuerdo al producto de MySQL.
          Product productRow = ConvertFromMySQL.getProductFromMySQL(mapProductRow);
          //Bandera para comprobar si se inserta el triple o no.
          bool insertTriple = false;

          //Si no hay productos actualmente en la base de datos, entonces insertar directamente.
          if (listProducts.isEmpty){
            insertTriple = true;
          }
          else{
            //Se obtiene el producto existente de la lista o devuelve null.
            Product? productExisting = _isExistingProduct(listProducts, productRow);
            //Si el producto existe y ademas el producto fue modificado, o si el producto no existe, entonces se debe insertar el triple.
            insertTriple = (productExisting!=null) ? _isProductModified(productExist: productExisting, productMySQL: productRow) : true;
          }

          //Si se debe insertar triple, entonces...
          if (insertTriple){
            //Obtener la distribuidora del producto.
            Distributor distributorRow = distributors.firstWhere(
                    (element){
                  return element.getCUIT().replaceAll('-', '').compareTo(row['d_cuit'].toString().replaceAll('-', ''))==0;},
                orElse: () => distributors.first
            );
            //Triple es una tripla de valores: (producto, distribuidora, precio_base)
            list.add(Triple<Product, Distributor, double>(
                v1: productRow,
                v2: distributorRow,
                v3: double.tryParse(mapProductPriceRow['p_pricebase'].toString()))
            );
          }
        }
      }

      //Actualiza el estado.
      state = [...list];
      //Notifica al catalogo.
      if (ref.read(stateManagerProductMySQLProvider)!=null){
        ref.read(stateManagerProductMySQLProvider)!.insertRows(0, state.map((e) => e.getValue1().getPlutoRow()!).toList());
      }
    }
    catch(e){
      map = ResponseApiJSON.getProblemOccurredMessage();
    }

    if (context!=null && context.mounted){
      ElegantNotificationCustom.showNotificationAPI(context, map);
    }
  }

  ///ImportProductMySQLProvider: Dada una lista de productos, comprueba si un producto (de un determinado código) pertenece a la lista y retorna el elemento de la lista.
  ///
  ///[listProduct] Lista de productos.
  ///
  ///[productMySQL] Producto proveniente de MySQL.
  Product? _isExistingProduct(List<Product> listProduct, Product productMySQL){
    Product product = listProduct.firstWhere((element){
      return (
        element.getBarcode()==productMySQL.getBarcode()
      );
    },
    orElse: (){ 
      return Product.clean();
    },);

    Product? toReturn = (product.getDateCreate()==DatetimeCustom.getDatetimeString(0)) ? null : product;
    return toReturn;
  }

  ///ImportProductMySQLProvider: Dado un producto existente y uno de mysql, comprueba si difieren en algún campo y devuelve True en caso afirmativo, de lo contrario, retorna False.
  ///
  ///[productExist] Producto existente.
  ///
  ///[productMySQL] Producto proveniente de MySQL.
  bool _isProductModified({required Product productExist, required Product productMySQL}){
    return (
      productExist.getBarcode()!=productMySQL.getBarcode() ||
      productExist.getInternalCode()!=productMySQL.getInternalCode() ||
      productExist.getTitle()!=productMySQL.getTitle() ||
      productExist.getBrand()!=productMySQL.getBrand() ||
      productExist.getDescription()!=productMySQL.getDescription() ||
      productExist.getStock()!=productMySQL.getStock() ||
      productExist.getPricePublic()!=productMySQL.getPricePublic() ||
      productExist.getMinimumAge()!=productMySQL.getMinimumAge() ||
      productExist.getSizes().toString()!=productMySQL.getSizes().toString() ||
      (productExist.getLinkImages().toList().map<String>((e) => e.getLink()).toList().toString())!=(productMySQL.getLinkImages().toList().map<String>((e) => e.getLink()).toList().toString())
    );
  }

  ///ImportProductMySQLProvider: Refrezca el listado de productos.
  Future<void> refresh({BuildContext? context}) async {
    //Limpia el catalogo de todas las filas.
    if (ref.read(stateManagerProductMySQLProvider)!=null){
      ref.read(stateManagerProductMySQLProvider)!.removeAllRows();
    }
    ref.read(catalogProductsImportProvider.notifier).clear();
    //Limpia el estado actual.
    state = [];
    //Inicializa el catalogo.
    await initialize(context: context);
  }

  ///ImportProductMySQLProvider: Remueve el producto de la lista.
  void remove(Triple<Product, Distributor, double> triple){
    state.remove(triple);
  }
}

///importProductMySQLProvider es un proveedor que permite importar los productos almacenados en el servidor de MySQL.
final importProductMySQLProvider = StateNotifierProvider<ImportProductMySQLProvider, List<Triple<Product, Distributor, double>>>((ref) => ImportProductMySQLProvider(ref));
