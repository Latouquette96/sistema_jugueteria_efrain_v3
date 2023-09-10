import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/pair.dart';

///Clase DistributorFreeProductPriceProvider: Proveedor de servicios para almacenar las distribuidoras libres, esto es, sin ser asignadas a un producto.
class DistributorFreeProductPriceProvider extends StateNotifier<List<Distributor>> {

  //Constructor de DistributorFreeProductPriceProvider
  DistributorFreeProductPriceProvider(): super([]);

  ///DistributorFreeProductPriceProvider: Inicializa el arreglo de precios del producto.
  void load(List<Distributor> distributors, List<Pair<Distributor, ProductPrice>> pricesProduct) {
    //Obtiene la respuesta a la solicitud http.
    try{
      //Recupera un listado de distribuidoras libres para el producto.
      List<Distributor> distributorsFree = distributors.where((distr){
        bool isFree = true;
        if (pricesProduct.isNotEmpty){
          int i = 0;
          //Para cada distr, se comprueba si pertenece a la lista de productos.
          while(isFree && i<pricesProduct.length){
            //Está libre la distribuidora siempre y cuando no esté en la lista de productos.
            isFree = pricesProduct[i].getValue1().getID()!=distr.getID();
            i++;
          }
        }
        return isFree;
      }).toList();

      //Establece las distribuidoras.
      state = distributorsFree;
    }
    catch(e){
      state = [];
    }
  }

  ///DistributorFreeProductPriceProvider: Limpia el estado liberando todas las distribuidoras de la lista.
  void clear(){
    state = [];
  }
}

///distributorFreeProductPriceProvider es un proveedor que almacena la lista de distribuidoras sin asignarle un precio para un determinado producto.
final distributorFreeProductPriceProvider = StateNotifierProvider<DistributorFreeProductPriceProvider, List<Distributor>>((ref) => DistributorFreeProductPriceProvider());