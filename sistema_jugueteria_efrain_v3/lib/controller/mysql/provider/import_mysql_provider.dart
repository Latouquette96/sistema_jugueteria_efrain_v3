import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/controller/connection_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_product.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/provider/crud_mysql_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/product/catalog_product_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase ImportProductMySQLProvider: Modela las operaciones CRUD sobre MySQL.
class ImportProductMySQLProvider extends StateNotifier<List<Triple<Product, Distributor, double>>> {
  //Atributos de clase
  final StateNotifierProviderRef<ImportProductMySQLProvider, List<Triple<Product, Distributor, double>>> ref;
  final String _sql = "SELECT "
        "json_object('p_id', p_id, 'p_codebar', p_codebar, 'p_title', p_title,"
                  " 'p_brand', p_brand, 'p_description', p_description, 'p_sizeblister', p_sizeblister, "
                  " 'p_sizeproduct', p_sizeproduct, 'p_category', p_category, 'p_subcategory', p_subcategory, "
                  " 'p_stock', p_stock, 'p_iva', p_iva, 'p_pricepublic', p_pricepublic, 'p_linkimage', p_linkimage,"
                  " 'p_datecreated', p_datecreated, 'p_dateupdated', p_dateupdated, 'p_minimumage', p_minimumage, 'p_internal_code', p_internal_code) as product, "
        "json_object('d_cuit', d_cuit) as distributor, "
        "json_object('p_dateupdated', p_dateupdated, 'p_pricebase', p_pricebase) as price_product "
       "FROM db_jugueteria_efrain.products, db_jugueteria_efrain.distributors WHERE p_distributor=d_id;";

  ///Constructor privado de ImportProductMySQLProvider
  ImportProductMySQLProvider(this.ref): super([]);

  ///ImportProductMySQLProvider: Inicializa el arreglo de producto.
  Future<void> initialize() async{
    try{
      await MySQLConnection.getConnection().connect(user: "Latouquette96", pass: "39925523");
      //Obtengo el cliente mysql activo.
      MySqlConnection conn = MySQLConnection.getConnection().getClient()!;

      List<Distributor> distributors = ref.read(catalogDistributorProvider);
      //Ejecuta la consulta SQL.
      var results = await conn.query(_sql);

      List<Triple<Product, Distributor, double>> list = [];
      List<Product> listProducts = ref.read(productCatalogProvider);
      //Para cada fila de los resultados obtenidos.
      for (ResultRow row in results){
        //Recupera las tres coluumnas principales de la consulta.
        Map<String, dynamic> mapProductRow = jsonDecode(row['product']);
        Map<String, dynamic> mapDistributorRow = jsonDecode(row['distributor']);
        Map<String, dynamic> mapProductPriceRow = jsonDecode(row['price_product']);
        //Construye el producto de acuerdo al producto de MySQL.
        Product productRow = ConvertProduct.getProductFromMySQL(mapProductRow);
        //Bandera para comprobar si se inserta el triple o no.
        bool insertTriple = false;
        //Se obtiene el producto existente de la lista o devuelve null.
        Product? productExisting = _isExistingProduct(listProducts, productRow);
        //Si el producto existe y ademas el producto fue modificado, o si el producto no existe, entonces se debe insertar el triple.
        insertTriple = (productExisting!=null) ? _isProductModified(productExist: productExisting, productMySQL: productRow) : true;      
        //Si se debe insertar triple, entonces...
        if (insertTriple){
          //Obtener la distribuidora del producto.
          Distributor distributorRow = distributors.firstWhere(
            (element) => element.getCUIT()==mapDistributorRow['d_cuit'].toString(), 
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
      //Actualiza el estado.
      state = [...list];
      //Notifica al catalogo.
      if (ref.read(stateManagerProductMySQLProvider)!=null){
        ref.read(stateManagerProductMySQLProvider)!.insertRows(0, state.map((e) => e.getValue1().getPlutoRow()!).toList());
      }
    }
    // ignore: empty_catches
    catch(e){}
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
  Future<void> refresh() async {
    //Limpia el catalogo de todas las filas.
    if (ref.read(stateManagerProductMySQLProvider)!=null){
      ref.read(stateManagerProductMySQLProvider)!.removeAllRows();
    }
    ref.read(catalogImportProvider.notifier).clear();
    //Limpia el estado actual.
    state = [];
    //Inicializa el catalogo.
    await initialize();
  }

  ///ImportProductMySQLProvider: Remueve el producto de la lista.
  void remove(Triple<Product, Distributor, double> triple){
    state.remove(triple);
  }
}

///importProductMySQLProvider es un proveedor que permite importar los productos almacenados en el servidor de MySQL.
final importProductMySQLProvider = StateNotifierProvider<ImportProductMySQLProvider, List<Triple<Product, Distributor, double>>>((ref) => ImportProductMySQLProvider(ref));
