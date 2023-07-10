import 'package:jugueteriaefrain_logic_manager/mixin/mixin_mapping_model.dart';

///Clase Distributor: Modela la distribuidora de donde provienen los productos.
class Distributor with MixinMappingModel<Distributor> {
  //Atributos de instancia
  late int _id;
  late int _cuit;
  late String _name;
  late String? _address;
  late String? _email;
  late String? _cel;
  late String? _website;

  ///Constructor de Distributor.
  Distributor({
    int id = 0,
    int cuit = 0,
    String name = "",
    String? address,
    String? email,
    String? cel,
    String? website,
  }) {
    _id = id;
    _cuit = cuit;
    _name = name;
    _address = address;
    _email = email;
    _cel = cel;
    _website = website;
  }

  @override
  Map<String, dynamic> getMap() {
    return {
      "d_id": _id,
      "d_cuit": _cuit,
      "d_name": _name,
      "d_address": _address,
      "d_email": _email,
      "d_cel": _cel,
      "d_website": _website
    };
  }

  @override
  void loadingWithMap(Map<String, dynamic> map) {
    _id = map['d_id'];
    _cuit = map['d_cuit'];
    _name = map['d_name'];
    _address = map['d_address'];
    _email = map['d_email'];
    _cel = map['d_cel'];
    _website = map['d_website'];
  }
}
