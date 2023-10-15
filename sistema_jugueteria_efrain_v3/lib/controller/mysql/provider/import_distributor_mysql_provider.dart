import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/controller/mysql/convert/convert_from_mysql.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_json/response_api_json_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/catalog_distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/login/login_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase ImportDistributorMySQLProvider: Modela las operaciones CRUD sobre MySQL.
class ImportDistributorMySQLProvider extends StateNotifier<List<Distributor>> {
  //Atributos de clase
  final StateNotifierProviderRef<ImportDistributorMySQLProvider, List<Distributor>> ref;

  ///Constructor privado de ImportDistributorMySQLProvider
  ImportDistributorMySQLProvider(this.ref): super([]);

  ///ImportDistributorMySQLProvider: Inicializa el arreglo de distribuidora.
  Future<void> initialize({BuildContext? context}) async{
    //Obtiene la direccion del servidor.
    final url = ref.watch(urlAPIProvider);
    //Mapeo con el contenido a mostrar
    Map<String, dynamic> map;

    try{
      //Recupera, de ser posible, las distribuidoras del servidor de mysql.
      http.Response content = await http.get(Uri.http(url, "/mysql/distributors"));
      map = jsonDecode(content.body);

      List<Distributor> list = [];

      if (map['status']==200 || map['status']==201){
        List<Distributor> listDistributors = ref.read(catalogDistributorProvider);

        //Para cada fila de los resultados obtenidos.
        for (var row in map['value']){
          //Construye la distribuidora de acuerdo al distribuidora de MySQL.
          Distributor distributorRow = ConvertFromMySQL.getDitributorFromMySQL(row);

          //Si no hay distribuidoras actualmente en la base de datos, entonces insertar directamente.
          if (listDistributors.isEmpty){
            distributorRow.buildPlutoRow();
            list.add(distributorRow);
          }
          else{
            //Bandera para comprobar si se inserta la distribuidora o no.
            bool insertDistr = false;

            //Se obtiene la distribuidora existente de la lista o devuelve null.
            Distributor? distributorExisting = _isExistingDistributor(listDistributors, distributorRow);
            //Si la distribuidora existe y ademas la distribuidora fue modificado, o si la distribuidora no existe, entonces se debe insertar el triple.
            insertDistr = (distributorExisting!=null) ? _isDistributorModified(distributorExist: distributorExisting, distributorMySQL: distributorRow) : true;

            //Si se debe insertar, entonces...
            if (insertDistr){
              distributorRow.buildPlutoRow();
              list.add(distributorRow);
            }
          }
        }
      }

      //Notifica al catalogo.
      if (ref.read(stateManagerDistributorMySQLProvider)!=null){
        ref.read(stateManagerDistributorMySQLProvider)!.insertRows(0, list.map((e) => e.getPlutoRow()!).toList());
      }

      //Actualiza el estado.
      state = [...list];
    }
    catch(e){
      map = ResponseApiJSON.getProblemOccurredMessage();
    }

    if (context!=null && context.mounted){
      ElegantNotificationCustom.showNotificationAPI(context, map);
    }
  }

  ///ImportDistributorMySQLProvider: Dada una lista de distribuidoras, comprueba si un distribuidora (de un determinado código) pertenece a la lista y retorna el elemento de la lista.
  ///
  ///[listDistributor] Lista de distribuidoras.
  ///[distributorMySQL] Distribuidora proveniente de MySQL.
  Distributor? _isExistingDistributor(List<Distributor> listDistributor, Distributor distributorMySQL){
    Distributor distributor = listDistributor.firstWhere((element){
      return (
        element.getCUIT()==distributorMySQL.getCUIT()
      );
    },
    orElse: (){ 
      return Distributor();
    },);

    Distributor? toReturn = distributor;
    return toReturn;
  }

  ///ImportDistributorMySQLProvider: Dado un distribuidora existente y uno de mysql, comprueba si difieren en algún campo y devuelve True en caso afirmativo, de lo contrario, retorna False.
  ///
  ///[distributorExist] Distribuidora existente.
  ///[distributorMySQL] Distribuidora proveniente de MySQL.
  bool _isDistributorModified({required Distributor distributorExist, required Distributor distributorMySQL}){
    return (
      distributorExist.getCUIT()!=distributorMySQL.getCUIT() ||
      distributorExist.getName()!=distributorMySQL.getName() ||
      distributorExist.getIVA()!=distributorMySQL.getIVA() ||
      distributorExist.getEmail()!=distributorMySQL.getEmail() ||
      distributorExist.getAddress()!=distributorMySQL.getAddress() ||
      distributorExist.getPhone()!=distributorMySQL.getPhone() ||
      distributorExist.getWebsite()!=distributorMySQL.getWebsite()
    );
  }

  ///ImportDistributorMySQLProvider: Refrezca el listado de distribuidoras.
  Future<void> refresh({BuildContext? context}) async {
    //Limpia el catalogo de todas las filas.
    if (ref.read(stateManagerDistributorMySQLProvider)!=null){
      ref.read(stateManagerDistributorMySQLProvider)!.removeAllRows();
    }
    //Limpia el estado actual.
    state = [];
    //Inicializa el catalogo.
    await initialize(context: context);
  }

  ///ImportDistributorMySQLProvider: Remueve la distribuidora de la lista.
  void remove(Distributor distributor){
    state.remove(distributor);
  }

  void removeAll(){
    state.clear();
    state = [];
  }
}

///importDistributorMySQLProvider es un proveedor que permite importar las distribuidoras almacenados en el servidor de MySQL.
final importDistributorMySQLProvider = StateNotifierProvider<ImportDistributorMySQLProvider, List<Distributor>>((ref) => ImportDistributorMySQLProvider(ref));