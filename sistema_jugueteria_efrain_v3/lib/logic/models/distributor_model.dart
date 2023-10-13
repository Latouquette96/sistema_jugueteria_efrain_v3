import 'package:pluto_grid/pluto_grid.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/mapeable/jsonizable.dart';

///Clase Distributor: Modela la distribuidora de donde provienen los productos.
class Distributor extends JSONalizable<Distributor> {
  //Atributos de instancia
  late int _id;
  late String _cuit; //RN-D1.
  late String _name; //RN-D2.
  late String? _address; //RN-D3.
  late String? _email; //RN-D3.
  late String? _cel; //RN-D3.
  late String? _website; //RN-D7.
  late double _iva; //RN-D5.
  //Atributos gráficos.

  //Atributos de clase
  static const String _keyID      = "d_id";
  static const String _keyCUIT    = "d_cuit";
  static const String _keyName    = "d_name";
  static const String _keyAddress = "d_address";
  static const String _keyEmail   = "d_email";
  static const String _keyCel     = "d_cel";
  static const String _keyWebsite = "d_website";
  static const String _keyIVA     = "d_iva";

  ///Constructor de Distributor.
  Distributor({
    int id = 0,
    String cuit = "0",
    String name = "",
    String? address,
    String? email,
    String? cel,
    String? website,
    double iva = 1.00,
  }) {
    _id = id;
    _cuit = cuit;
    _name = name;
    _address = address;
    _email = email;
    _cel = cel;
    _website = website;
    _iva = iva;
    plutoRow = buildPlutoRow();
  }

  ///Distributor: Constructor de distribuidora con datos JSON.
  Distributor.fromJSON(Map<String, dynamic> map) {
    fromJSON(map);
  }

  //-------------------------------------------------------

  ///Distributor: Devuelve la clave ID.
  static String getKeyID() {
    return _keyID;
  }

  ///Distributor: Devuelve la clave CUIT.
  static String getKeyCUIT(){
    return _keyCUIT;
  }

  ///Distributor: Devuelve la clave Address.
  static String getKeyAddress(){
    return _keyAddress;
  }

  ///Distributor: Devuelve la clave IVA.
  static String getKeyIVA(){
    return _keyIVA;
  }

  ///Distributor: Devuelve la clave Name.
  static String getKeyName(){
    return _keyName;
  }

  ///Distributor: Devuelve la clave Email.
  static String getKeyEmail(){
    return _keyEmail;
  }

  ///Distributor: Devuelve la clave Cel.
  static String getKeyCel(){
    return _keyCel;
  }

  ///Distributor: Devuelve la clave Website.
  static String getKeyWebsite(){
    return _keyWebsite;
  }

  //-------------------------ID----------------------------

  ///Distributor: Devuelve el identificador.
  int getID() {
    return _id;
  }

  //-------------------------CUIT----------------------------

  ///Distributor: Devuelve el numero de CUIT.
  String getCUIT() {
    return _cuit;
  }

  ///Distributor: Establece el numero de CUIT.
  void setCUIT(String value) {
    _cuit = value;
  }

  //-------------------------NOMBRE----------------------------

  ///Distributor: Devuelve el nombre de distribuidora.
  String getName() {
    return _name;
  }

  ///Distributor: Establece el nombre de distribuidora.
  void setName(String value) {
    _name = value;
  }

  //-------------------------DIRECCION----------------------------

  ///Distributor: Devuelve la dirección de distribuidora (o nulo).
  String? getAddress() {
    return _address;
  }

  ///Distributor: Establece la dirección de distribuidora.
  void setAddress(String? value) {
    _address = value;
  }

  //-------------------------EMAIL----------------------------

  ///Distributor: Devuelve el correo electrónico de distribuidora (o nulo).
  String? getEmail() {
    return _email;
  }

  ///Distributor: Establece el correo electrónico de distribuidora.
  void setEmail(String? value) {
    _email = value;
  }

  //-------------------------CELULAR----------------------------

  ///Distributor: Devuelve el celular de distribuidora (o nulo).
  String? getPhone() {
    return _cel;
  }

  ///Distributor: Establece el celular de distribuidora.
  void setPhone(String? value) {
    _cel = value;
  }

  //-------------------------SITIO WEB----------------------------

  ///Distributor: Devuelve el sitio web de la distribuidora (o nulo).
  String? getWebsite() {
    return _website;
  }

  ///Distributor: Establece el sitio web de la distribuidora.
  void setWebsite(String? value) {
    _website = value;
  }

  //-------------------------IVA----------------------------

  ///Distributor: Devuelve el porcentaje de IVA que aplica la distribuidora (generalmente, 1.00 o 1.21).
  double getIVA() {
    return _iva;
  }

  ///Distributor: Establece el porcentaje de IVA que aplica la distribuidora (generalmente, 1.00 o 1.21).
  void setIVA(double value) {
    _iva = value;
  }

  ///Distributor: Devuelve TRUE si la distribuidora aplica un IVA del 21%. Caso contrario, FALSE.
  bool isIVA121() {
    return _iva == 1.21;
  }

  @override
  Map<String, dynamic> getJSON() {
    return {
      _keyID: _id,
      _keyCUIT: _cuit,
      _keyName: _name,
      _keyAddress: _address,
      _keyEmail: _email,
      _keyCel: _cel,
      _keyWebsite: _website,
      _keyIVA: _iva,
    };
  }

  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = map[_keyID];
    _cuit = map[_keyCUIT];
    _name = map[_keyName];
    _address = map[_keyAddress];
    _email = map[_keyEmail];
    _cel = map[_keyCel];
    _website = map[_keyWebsite];
    try{
      _iva = map[_keyIVA];
    }
    catch(e){
      _iva = double.parse(map[_keyIVA]);
    }

    plutoRow = buildPlutoRow();
  }

  @override
  PlutoRow buildPlutoRow() {
    plutoRow = PlutoRow(
        type: PlutoRowType.normal(),
        checked: false,
        cells: {
          getKeyOptions(): PlutoCell(),
          Distributor.getKeyID(): PlutoCell(value: _id),
          Distributor.getKeyCUIT(): PlutoCell(value: _cuit),
          Distributor.getKeyName(): PlutoCell(value: _name),
          Distributor.getKeyAddress(): PlutoCell(value: _address ?? "-"),
          Distributor.getKeyCel(): PlutoCell(value: _cel ?? "-"),
          Distributor.getKeyEmail(): PlutoCell(value: _email ?? "-"),
          Distributor.getKeyIVA(): PlutoCell(value: _iva),
          Distributor.getKeyWebsite(): PlutoCell(value: _website ?? "-"),
       },
    );

    return plutoRow!;
  }
}
