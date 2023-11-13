import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_from_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_product_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/fourfold.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_distributor.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_product.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase ImportProductMySQLProvider: Modela las operaciones CRUD sobre MySQL.
class ImportProductMySQLProvider extends StateNotifier<List<Fourfold<Product, Distributor, double, String>>> {
  //Atributos de clase
  final StateNotifierProviderRef<ImportProductMySQLProvider, List<Fourfold<Product, Distributor, double, String>>> ref;

  ///Constructor privado de ImportProductMySQLProvider
  ImportProductMySQLProvider(this.ref): super([]);

  ///ImportProductMySQLProvider: Inicializa el arreglo de producto.
  Future<ResponseAPI> initialize() async{
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlAPIProvider);
    //Mapeo con el contenido a mostrar
    ResponseAPI toReturn;

    try{
      List<Distributor> distributors = StateManagerDistributor.getInstance().getElements();

      final content = await APICall.get(url: url, route: "/mysql/products");

      List<Fourfold<Product, Distributor, double, String>> list = [];
      if (content.isResponseSuccess()){
        List<Product> listProducts = StateManagerProduct.getInstanceProduct().getElements();

        //Para cada fila de los resultados obtenidos.
        for (Map<String, dynamic> row in content.getValue()){
          //Recupera las tres coluumnas principales de la consulta.
          Map<String, dynamic> mapProductRow = jsonDecode(row['product']);
          Map<String, dynamic> mapProductPriceRow = jsonDecode(row['price_product']);

          //Construye el producto de acuerdo al producto de MySQL.
          Product productRow = ConvertFromMySQL.getProductFromMySQL(mapProductRow);
          //Bandera para comprobar si se inserta el fourfold o no.
          bool insertFourfold = false;

          //Si no hay productos actualmente en la base de datos, entonces insertar directamente.
          if (listProducts.isEmpty){
            insertFourfold = true;
          }
          else{
            //Se obtiene el producto existente de la lista o devuelve null.
            Product? productExisting = _isExistingProduct(listProducts, productRow);
            insertFourfold = (productExisting!=null) ? _isProductModified(productExist: productExisting, productMySQL: productRow) : true;
            if (insertFourfold) productRow.setID((productExisting!=null) ? productExisting.getID() : 0);
          }

          //Si se debe insertar fourfold, entonces...
          if (insertFourfold){
            //Si está definido el producto
            if (productRow.getBarcode()!="-" && productRow.getTitle()!="-" && productRow.getDescription()!="-"){
              //Si no está duplicado en la lista a insertar.
              if (list.indexWhere((element){ return _equals(produc1: element.getValue1(), product2: productRow); }) ==-1){

                //Obtener la distribuidora del producto.
                Distributor distributorRow = distributors.firstWhere(
                        (element){
                      return element.getCUIT().replaceAll('-', '').compareTo(row['d_cuit'].toString().replaceAll('-', ''))==0;},
                    orElse: () => distributors.first
                );

                productRow.buildPlutoRow();

                //Fourfold es una tripla de valores: (producto, distribuidora, precio_base)
                list.add(Fourfold<Product, Distributor, double, String>(
                    v1: productRow,
                    v2: distributorRow,
                    v3: double.tryParse(mapProductPriceRow['p_pricebase'].toString()),
                    v4: mapProductPriceRow['p_internal_code']
                ));
              }

            }
          }
        }
      }

      //Actualiza el estado.
      state = [...list];
      //Notifica al catalogo.
      if (ref.read(stateManagerProductMySQLProvider)!=null){
        ref.read(stateManagerProductMySQLProvider)!.insertRows(0, state.map((e) => e.getValue1().getPlutoRow()).toList());
      }

      toReturn = content;
    }
    catch(e){
      toReturn = ResponseAPI.getProblemOccurredMessage();
    }

    return toReturn;
  }

  ///ImportProductMySQLProvider: Dada una lista de productos, comprueba si un producto (de un determinado código) pertenece a la lista y retorna el elemento de la lista.
  ///
  ///[listProduct] Lista de productos.
  ///[productMySQL] Producto proveniente de MySQL.
  Product? _isExistingProduct(List<Product> listProduct, Product productMySQL){
    Product product = listProduct.firstWhere((element){
      return (
          (element.getBarcode()==productMySQL.getBarcode())
      );
    },
    orElse: (){
      return Product.clean();
    },);

    Product? toReturn = (product.getID()==0) ? null : product;
    return toReturn;
  }

  ///ImportProductMySQLProvider: Dado un producto existente y uno de mysql, comprueba si difieren en algún campo y devuelve True en caso afirmativo, de lo contrario, retorna False.
  ///
  ///[productExist] Producto existente.
  ///[productMySQL] Producto proveniente de MySQL.
  bool _isProductModified({required Product productExist, required Product productMySQL}){
    return (
      productExist.getBarcode()!=productMySQL.getBarcode() ||
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

  ///ImportProductMySQLProvider: Comprueba si dos productos tienen la misma información relevante.
  ///
  ///[produc1] Producto existente.
  ///[product2] Producto proveniente de MySQL.
  bool _equals({required Product produc1, required Product product2}){
    return (
        produc1.getBarcode()==product2.getBarcode() &&
            produc1.getTitle()==product2.getTitle() &&
            produc1.getBrand()==product2.getBrand() &&
            produc1.getPricePublic()==product2.getPricePublic()
    );
  }

  ///ImportProductMySQLProvider: Refrezca el listado de productos.
  Future<ResponseAPI> refresh() async {
    //Limpia el catalogo de todas las filas.
    if (ref.read(stateManagerProductMySQLProvider)!=null){
      ref.read(stateManagerProductMySQLProvider)!.removeAllRows();
    }
    ref.read(catalogProductsImportProvider.notifier).clear();
    //Limpia el estado actual.
    state = [];
    //Inicializa el catalogo.
    return await initialize();
  }

  ///ImportProductMySQLProvider: Remueve el producto de la lista.
  void remove(Fourfold<Product, Distributor, double, String> fourfold){
    state.remove(fourfold);
  }
}

///importProductMySQLProvider es un proveedor que permite importar los productos almacenados en el servidor de MySQL.
final importProductMySQLProvider = StateNotifierProvider<ImportProductMySQLProvider, List<Fourfold<Product, Distributor, double, String>>>((ref) => ImportProductMySQLProvider(ref));
