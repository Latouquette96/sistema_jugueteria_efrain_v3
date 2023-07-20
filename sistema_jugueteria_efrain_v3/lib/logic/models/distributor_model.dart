import 'package:sistema_jugueteria_efrain_v3/logic/mixin/mixin_jsonizable.dart';

///Clase Distributor: Modela la distribuidora de donde provienen los productos.
class Distributor with MixinJSONalizable<Distributor> {
  //Atributos de instancia
  late int _id;
  late String _cuit; //RN-D1.
  late String _name; //RN-D2.
  late String? _address; //RN-D3.
  late String? _email; //RN-D3.
  late String? _cel; //RN-D3.
  late String? _website; //RN-D7.
  late double _iva; //RN-D5.

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
  }

  ///Distributor: Constructor de distribuidora con datos JSON.
  Distributor.fromJSON(Map<String, dynamic> map) {
    fromJSON(map);
  }

  //-------------------------ID----------------------------

  ///Distributor: Devuelve el identificador.
  int getID() {
    return _id;
  }

  ///Distributor: Establece el identificador.
  void setID(int id) {
    _id = id;
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
      "d_id": _id,
      "d_cuit": _cuit,
      "d_name": _name,
      "d_address": _address,
      "d_email": _email,
      "d_cel": _cel,
      "d_website": _website,
      "d_iva": _iva,
    };
  }

  @override
  void fromJSON(Map<String, dynamic> map) {
    _id = map['d_id'];
    _cuit = map['d_cuit'];
    _name = map['d_name'];
    _address = map['d_address'];
    _email = map['d_email'];
    _cel = map['d_cel'];
    _website = map['d_website'];
    _iva = double.parse(map['d_iva']);
  }
}
