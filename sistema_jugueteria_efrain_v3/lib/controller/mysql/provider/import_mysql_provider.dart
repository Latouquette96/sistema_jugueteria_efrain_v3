import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/controller/connection_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/product_mysql_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';

///Clase ImportProductMySQLProvider: Modela las operaciones CRUD sobre MySQL.
class ImportProductMySQLProvider extends StateNotifier<List<ProductMySQL>> {
  //Atributos de clase
  final StateNotifierProviderRef<ImportProductMySQLProvider, List<ProductMySQL>> ref;

  ///Constructor privado de ImportProductMySQLProvider
  ImportProductMySQLProvider(this.ref): super([]);

  ///ImportProductMySQLProvider: Inicializa el arreglo de producto.
  Future<void> initialize() async{
    try{
      await MySQLConnection.getConnection().connect(user: "Latouquette96", pass: "39925523");
      //Obtengo el cliente mysql activo.
      MySqlConnection conn = MySQLConnection.getConnection().getClient()!;

      String sql = "SELECT p_id, p_codebar, p_title, p_brand, p_description, p_sizeblister, p_sizeproduct, p_distributor, p_category, p_subcategory, p_stock, p_iva, p_pricebase, p_pricepublic, p_linkimage, p_datecreated, p_dateupdated, p_minimumage, p_internal_code " +
        "FROM db_jugueteria_efrain.products;";

      var results = await conn.query(sql);
      List<ProductMySQL> list = results.map((e){
        return ProductMySQL.loadResultRow(e);
      }).toList();
      state = [...list];
      //Notifica al catalogo.
      ref.read(stateManagerProductMySQLProvider)!.insertRows(0, state.map((e) => e.getPlutoRow()).toList());
    }
    catch(e){
      print(e.toString());
    }
  }

  ///ImportProductMySQLProvider: Refrezca el listado de productos.
  Future<void> refresh() async {
    //Limpia el catalogo de todas las filas.
    ref.read(stateManagerProductMySQLProvider)!.removeAllRows();
    //Limpia el estado actual.
    state = [];
    //Inicializa el catalogo.
    await initialize();
  }

  ///ImportProductMySQLProvider: Remueve el producto de la lista.
  void remove(ProductMySQL p){
    state.remove(p);
  }
}

///importProductMySQLProvider es un proveedor que permite importar los productos almacenados en el servidor de MySQL.
final importProductMySQLProvider = StateNotifierProvider<ImportProductMySQLProvider, List<ProductMySQL>>((ref) => ImportProductMySQLProvider(ref));
