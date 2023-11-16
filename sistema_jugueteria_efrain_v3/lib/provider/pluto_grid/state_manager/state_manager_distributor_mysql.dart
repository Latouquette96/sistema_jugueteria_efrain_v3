import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/api_call.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_distributor.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_grid/state_manager/state_manager_generic_mysql.dart';

///Clase StateManagerDistributorMySQL: Sirve para administrar (sin provider) el catalogo de elementos.
class StateManagerDistributorMySQL extends StateManagerMySQL<Distributor, Distributor>{
  //Atributos de clases
  static final StateManagerDistributorMySQL _instance = StateManagerDistributorMySQL._(path: "/mysql/distributors");

  ///Constructor de StateManagerDistributorMySQL.
  StateManagerDistributorMySQL._({required super.path});

  ///StateManagerDistributorMySQL: Devuelve la instancia.
  static StateManagerDistributorMySQL getInstance(){
    return _instance;
  }

  @override
  Future<ResponseAPI> initialize(String url) async {
    //Elimina la lista de elementos.
    loadElements([]);
    //Respuesta a retornar.
    ResponseAPI response;

    try{
      List<Distributor> list = [];

      final content = await APICall.get(url: url, route: "/mysql/distributors");

      if (content.isResponseSuccess()){
        List<Distributor> listDistributors = StateManagerDistributor.getInstance().getElements();

        //Para cada fila de los resultados obtenidos.
        for (var row in content.getValue()){
          //Construye la distribuidora de acuerdo al distribuidora de MySQL.
          Distributor distributorRow = buildElement(row);

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
      if (getStateManager()!=null){
        getStateManager()!.insertRows(0, list.map((e) => e.getPlutoRow()).toList());
      }

      //Actualiza el estado.
      response = content;
      loadElements(list);
    }
    catch(e){
      response = ResponseAPI.manual(
          status: 404, 
          value: null, 
          title: "Error 404", 
          message: "Error: No se pudo recuperar los datos del servidor."
      );
    }

    return response;
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
            distributorExist.getEmail()!=distributorMySQL.getEmail() ||
            distributorExist.getAddress()!=distributorMySQL.getAddress() ||
            distributorExist.getPhone()!=distributorMySQL.getPhone() ||
            distributorExist.getWebsite()!=distributorMySQL.getWebsite()
    );
  }

  @override
  buildElement(Map<String, dynamic> data) {
    try{
      //Crea un producto limpio.
      Distributor distributor = Distributor();
      //Construcción del mapeo.
      Map<String, dynamic> map = {
        Distributor.getKeyID():       data['d_id'],
        Distributor.getKeyName():     data['d_name'],
        Distributor.getKeyAddress():  data['d_direction'],
        Distributor.getKeyCUIT():     data['d_cuit'],
        Distributor.getKeyIVA():      1.00,
        Distributor.getKeyCel():      data['d_phone'],
        Distributor.getKeyEmail():    data['d_email'],
        Distributor.getKeyWebsite():  null,
      };

      //Carga el mapeo en el producto y lo retorna.
      distributor.fromJSON(map);
      return distributor;
    }
    catch(e){
      return Distributor();
    }
  }

  @override
  Future<ResponseAPI> import(String url, List<Distributor> imports) async {
    ResponseAPI toReturn;

    try{
      final List<Distributor> listImport = imports;

      int errors = 0;

      for (Distributor d in listImport){
        //Realiza la petición POST para insertar el Distributoro.
        final response = await APICall.post(
          url: url, route: '/distributors',
          body: d.getJSON(),
        );

        //List<dynamic> json = jsonDecode(response.body);
        if (response.isResponseSuccess()==false){
          errors++;
        }
      }

      toReturn = ResponseAPI.manual(
          status: (errors==0) ? 200 : 501,
          value: null,
          title: (errors==0) ? "Importación exitosa" : "Error 501",
          message: (errors==0)
              ? "La importación de distribuidoras del Sistema v2 fue realizada con éxito."
              : "Error: ${ (errors<listImport.length) ? "Se importaron ${listImport.length-errors} distribuidoras." : "No se importó ninguna distribuidora del Sistema v2."}"
      );
    }
    catch(e){
      toReturn = ResponseAPI.manual(
          status: 404,
          value: null,
          title: "Error 404",
          message: "Error: No se pudo llevar a cabo la importación de distribuidoras del Sistema v2."
      );
    }

    return toReturn;
  }
}