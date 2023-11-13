import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/jsonizable.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';

///Clase DistributorBilling: Modela una factura de una distribuidora.
class DistributorBilling extends JSONalizable<DistributorBilling> {
  //Atributos de instancia
  late int _id; //RN-FD4.
  late ResourceLink _urlFile; //RN-FD1.
  late int _date; //RN-FD2.
  late double _total; //RN-FD3.
  late int _distributorID; //RN-FD2.

  //Atributos de clase
  static const String _keyID = "db_id";
  static const String _keyDistributor = "db_distributor";
  static const String _keyUrlFile = "db_url_file";
  static const String _keyDate = "db_datetime";
  static const String _keyTotal = "db_total";

  ///Constructor de DistributorBilling.
  DistributorBilling({required int id, required int distributorID, required String urlFile, int date = 0, double total = 0}) {
    _id = id;
    _distributorID = distributorID;
    _urlFile = ResourceLink(urlFile);
    _date = (date == 0) ? DatetimeCustom.getDatetimeIntegerNow() : date;
    _total = total;
  }

  ///Constructor de DistributorBilling.
  DistributorBilling.newBilling({required int distributorID}){
    _id = 0;
    _distributorID = distributorID;
    _urlFile = ResourceLink("");
    _date = DatetimeCustom.getDatetimeIntegerNow();
    _total = 0;
  }


  ///Constructor de DistributorBilling.
  DistributorBilling.fromJSON(Map<String, dynamic> map){
    fromJSON(map);
  }

  //---------------------------------------------------------

  ///DistributorBilling: Devuelve la clave para ID.
  static String getKeyID(){
    return _keyID;
  }

  ///DistributorBilling: Devuelve la clave para distribuidora.
  static String getKeyDistributor(){
    return _keyDistributor;
  }

  ///DistributorBilling: Devuelve la clave para distribuidora.
  static String getKeyDistributorName(){
    return "${_keyDistributor}Name";
  }

  ///DistributorBilling: Devuelve la clave para la url del archivo.
  static String getKeyUrlFile(){
    return _keyUrlFile;
  }

  ///DistributorBilling: Devuelve la clave para fecha/hora.
  static String getKeyDatetime(){
    return _keyDate;
  }

  ///DistributorBilling: Devuelve la clave para el total.
  static String getKeyTotal(){
    return _keyTotal;
  }

  //--------------------------ID-----------------------------

  ///DistributorBilling: Devuelve el ID del archivo.
  int getID(){
    return _id;
  }

  //-------------------------FILE----------------------------

  ///DistributorBilling: Establece los datos del archivo.
  void setUrlFile(String file) {
    _urlFile = ResourceLink(file);
  }

  ///DistributorBilling: Devuelve los bytes pertenecientes al archivo.
  ResourceLink getUrlFile() {
    return _urlFile;
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

  //----------------------FILE---------------------------

  ///DistributorBilling: Devuelve el nombre que tendrá el archivo creado.
  String getFileName(){
    return "${_date.toString()}.pdf";
  }

  //------------------------------------------------------

  ///DistributorBilling: Actualiza los valores de acuerdo a un mapeo.
  void fromJSONtoForm(Map<String, dynamic> map) {
    _id = map[_keyID];
    _urlFile = ResourceLink(map[_keyUrlFile]);
    _date = DatetimeCustom.parseStringDatetime(map[_keyDate]);
    _total = map[_keyTotal];
    _distributorID = map[_keyDistributor];
  }

  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = map[_keyID];
    _urlFile = ResourceLink(map[_keyUrlFile]);
    _date = int.parse(map[_keyDate]);
    _total = double.parse(map[_keyTotal]);
    _distributorID = map[_keyDistributor];
  }
  
  @override
  Map<String, dynamic> getJSON() {
    return {
      _keyID: _id,
      _keyUrlFile: _urlFile.getLink(),
      _keyDate: _date,
      _keyTotal: _total,
      _keyDistributor: _distributorID
    };
  }

  @override
  PlutoRow? buildPlutoRow() {
    return null;
  }

  @override
  void updatePlutoRow() {}
}
