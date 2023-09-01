import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/controller/connection_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/model/product_mysql_model.dart';

///Clase ImportProductMySQLProvider: Modela las operaciones CRUD sobre MySQL.
class ImportProductMySQLProvider extends StateNotifier<List<ProductMySQL>> {
  //Atributos de clase
  final StateNotifierProviderRef<ImportProductMySQLProvider, List<ProductMySQL>> ref;

  ///Constructor privado de ImportProductMySQLProvider
  ImportProductMySQLProvider(this.ref): super([]);

  ///ImportProductMySQLProvider: Inicializa el arreglo de producto.
  Future<void> initialize() async{
    try{
      //Obtengo el cliente mysql activo.
      MySqlConnection conn = MySQLConnection.getConnection().getClient()!;

      String sql = "SELECT products.* FROM products";

      var results = await conn.query(sql);
      List<ProductMySQL> list = results.map((e) => ProductMySQL.loadResultRow(e)).toList();
      state = [...list];
    }
    catch(e){
      print(e.toString());
    }
  }

  ///ImportProductMySQLProvider: Refrezca el listado de productos.
  Future<void> refresh() async {
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
