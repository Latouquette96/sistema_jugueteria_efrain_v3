import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/product_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/product_prices_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase FormGroupProductPrices: Modela la composicion de todos los controles de formulario de un producto.
class FormGroupProductPrices {

  ///FormGroupProductPrices: Construye el FormGroup para un producto almacenado en un determinado provider de ProductProvider.
  static buildFormGroupProductPrices(WidgetRef ref, StateNotifierProvider<ElementStateProvider<Product>, Product?> provider){

    return FormGroup({
      "${ProductPrice.getKeyDistributor()}Object": FormControl<Distributor>(
        value:  null,
      ),
      ProductPrice.getKeyDistributor() : FormControl<int>(
          value: 0
      ),
      ProductPrice.getKeyPriceBase(): FormControl<double>(
          value: 0.00
      ),
      ProductPrice.getKeyProduct(): FormControl<int>(
          value: ref.read(provider)!.getID()
      ),
      ProductPrice.getKeyDateUpdate(): FormControl<int>(
          value: DatetimeCustom.getDatetimeIntegerNow()
      ),
      ProductPrice.getKeyID(): FormControl<int>(
          value: 0
      ),
      ProductPrice.getKeyWebsite(): FormControl<String?>(
          value: null
      )
    });
  }
}