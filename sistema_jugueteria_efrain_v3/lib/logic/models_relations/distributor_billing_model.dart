import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';

///Clase DistributorBilling: Modela una factura de una distribuidora.
class DistributorBilling with MixinJSONalizable<DistributorBilling> {
  //Atributos de instancia
  late int _id; //RN-FD4.
  late Uint8List? _bytesFile; //RN-FD1.
  late int _date; //RN-FD2.
  late double _total; //RN-FD3.
  late int _distributorID; //RN-FD2.

  //Atributos de clase
  static const String _keyID = "db_id";
  static const String _keyDistributor = "db_distributor";
  static const String _keyFile = "db_billing";
  static const String _keyDate = "db_datetime";
  static const String _keyTotal = "db_total";

  ///Constructor de DistributorBilling.
  DistributorBilling({required int id, required int distributorID, Uint8List? file, int date = 0, double total = 0}) {
    _id = id;
    _distributorID = distributorID;
    _bytesFile = file;
    _date = (date == 0) ? DatetimeCustom.getDatetimeIntegerNow() : date;
    _total = total;
  }

  //-------------------------FILE----------------------------

  ///DistributorBilling: Establece los datos del archivo.
  void setFile(Uint8List file) {
    _bytesFile = file;
  }

  ///DistributorBilling: Descarga el archivo, escribiendolo en el directorio dado.
  Future<void> downloadFile(String directory, Distributor d) async {
    if (_bytesFile != null) {
      File f = File("$directory/${d.getCUIT()} - $_date.pdf");
      f.writeAsBytes(_bytesFile!.toList());
    }
  }

  ///DistributorBilling: Devuelve los bytes pertenecientes al archivo.
  Uint8List? getFile() {
    return _bytesFile;
  }

  //------------------------DATETIME--------------------------

  ///DistributorBilling: Establece la fecha y hora dada por el datetime.
  void setDatetime(DateTime dt) {
    _date = DatetimeCustom.getDatetimeInteger(dt);
  }

  ///DistributorBilling: Establece la fecha y hora actual.
  void setDatetimeNow() {
    _date = DatetimeCustom.getDatetimeIntegerNow();
  }

  ///DistributorBilling: Devuelve el datetime.
  String getDatetime() {
    return DatetimeCustom.getDatetimeString(_date);
  }

  //------------------------TOTAL--------------------------

  ///DistributorBilling: Establece el total de la factura.
  void setTotal(double total) {
    _total = total;
  }

  ///DistributorBilling: Devuelve el total de la factura.
  double getTotal() {
    return _total;
  }

    //------------------------------------------------------
  
  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = int.parse(map[_keyID]);
    try{
      var fileBlob = map[_keyFile];
      _bytesFile = const Base64Codec().decode(fileBlob);
    }
    catch(e){
      _bytesFile = null;
    }
    _date = int.parse(map[_keyDate]);
    _total = double.parse(map[_keyTotal]);
    _distributorID = int.parse(map[_keyDistributor]);
  }
  
  @override
  Map<String, dynamic> getJSON() {
    return {
      _keyID: _id,
      _keyFile: _bytesFile,
      _keyDate: _date,
      _keyTotal: _total,
      _keyDistributor: _distributorID
    };
  }
}
