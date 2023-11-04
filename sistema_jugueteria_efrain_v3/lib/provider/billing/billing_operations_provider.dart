import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/config/configuration_local.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

///Clase BillingOperationProvider: Proveedor de servicios para almacenar el estado de una distribuidora.
///
/// Almacena en el estado un elemento Triple<V1, V2, V3> donde
/// [V1] es un archivo (permite comprobar que el archivo existe en el sistema).
/// [V2] es el link del recurso.
/// [V3] es un booleano que indica si el archivo es recuperado de internet o del sistema.
class BillingOperationProvider extends StateNotifier<Triple<File?, ResourceLink, bool>?> {
  final StateNotifierProviderRef<BillingOperationProvider, Triple<File?, ResourceLink, bool>?> ref;

  BillingOperationProvider(this.ref): super(null);

  ///BillingOperationProvider: Carga un elemento nuevo como estado.
  Future<void> initialize() async {
    //Distribuidora actual
    Distributor? distributor = ref.read(distributorStateBillingProvider);
    //Factura de la distribuidora.
    DistributorBilling? db = ref.watch(billingSearchProvider);
    //Directorio (string).
    String distributorPath = '${ref.watch(configurationProvider).getValueBillingPath()}/${distributor!.getDirectoryName()}/';
    String filePath = "$distributorPath/${db!.getFileName()}";

    File? fileInSystem;
    //Comprueba si el archivo existe en el directorio
    if (await File(filePath).exists()){
      fileInSystem = File(filePath);
    }

    state = Triple<File?, ResourceLink, bool>(v1: fileInSystem, v2: db.getUrlFile(), v3: fileInSystem==null);
  }

  ///BillingOperationProvider: Realiza la descarga del elemento.
  Future<bool> download() async {
    bool resultado = true;

    try{
      //Distribuidora actual
      Distributor? distributor = ref.read(distributorStateBillingProvider);
      //Factura de la distribuidora.
      DistributorBilling? db = ref.watch(billingSearchProvider);

      String distributorPath = '${ref.watch(configurationProvider).getValueBillingPath()}/${distributor!.getDirectoryName()}/';
      //Crea el objeto directorio.
      Directory directory =  Directory(distributorPath);

      //Si no existe el archivo, entonces lo crea
      if (await directory.exists()==false){
        directory = await directory.create(recursive: true);
      }

      //Obtiene el archivo en cuestión.
      File file = File("$distributorPath/${db!.getFileName()}");

      Response<Uint8List> response = await Dio().get<Uint8List>(
          db.getUrlFile().getLink(),
          options: Options(responseType: ResponseType.bytes)
      );

      //Si se recuperó los datos, se escribe el archivo.
      if (response.data!=null){
        await file.writeAsBytes(response.data!);
        state?.setValue1(file);
        state?.setValue3(false);
        state = state;
      }
      else{
        resultado = false;
      }
    }
    catch(e){
      resultado = false;
    }

    return resultado;
  }

  ///BillingOperationProvider: Devuelve true en caso de que no hay archivo en el sistema, de lo contrario, false.
  bool isFileWeb(){
    return (state?.getValue3()==null) ? false : state!.getValue3()!;
  }

  ///BillingOperationProvider: Devuelve true si no hay archivo cargado (web o sistema) en el programa.
  bool isNoFileUploaded(){
    return (state!.getValue1()==null && state!.getValue3()==false);
  }

  ///BillingOperationProvider: Devuelve el archivo (o null en caso de no estar definido)
  File? getFile(){
    return state!.getValue1();
  }

  ///BillingOperationProvider: Libera el elemento actual, realizando un cambio de estado.
  void free(){
    state = null;
  }

  ///BillingOperationProvider: Remueve el archivo.
  Future<void> deleteFile() async {
    if (state!.getValue1()!=null){
      await state!.getValue1()!.delete();
      state!.setValue1(null);
      state!.setValue3(true);
      state = state;
    }

  }
}

final billingOperationsProvider = StateNotifierProvider<BillingOperationProvider, Triple<File?, ResourceLink, bool>?>((ref) => BillingOperationProvider(ref));