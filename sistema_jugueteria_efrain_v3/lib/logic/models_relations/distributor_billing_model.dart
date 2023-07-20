import 'dart:io';
import 'dart:typed_data';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';

///Clase DistributorBilling: Modela una factura de una distribuidora.
class DistributorBilling {
  //Atributos de instancia
  late Uint8List? _bytesFile; //RN-FD1.
  late int _date; //RN-FD2.

  ///Constructor de DistributorBilling.
  DistributorBilling({Uint8List? file, int date = 0}) {
    _bytesFile = file;
    _date = (date == 0) ? DatetimeCustom.getDatetimeIntegerNow() : date;
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
}
