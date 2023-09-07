import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_notifier_provider/element_state_notifier.dart';

///Clase FormGroupDistributor: Modela la composicion de todos los controles de formulario de una distribuidora.
class FormGroupDistributor {
  
  ///FormGroupDistributor: Construye el FormGroup para un producto almacenado en un determinado provider de DistributorProvider.
  static buildFormGroup(WidgetRef ref, StateNotifierProvider<ElementStateProvider, Distributor?> provider){
    
    return FormGroup({
      Distributor.getKeyID(): FormControl<int>(
        value: ref.read(distributorStateProvider)?.getID(),
      ),
      Distributor.getKeyCUIT(): FormControl<String>(
        value: ref.read(distributorStateProvider)?.getCUIT(),
        validators: [Validators.required, Validators.maxLength(13)]
      ),
      Distributor.getKeyName(): FormControl<String>(
        value: ref.read(distributorStateProvider)?.getName(),
        validators: [Validators.required]
      ),
      Distributor.getKeyAddress(): FormControl<String>(
        value: ref.read(distributorStateProvider)?.getAddress(),
        validators: []
      ),
      Distributor.getKeyCel(): FormControl<String>(
        value: ref.read(distributorStateProvider)?.getPhone(),
        validators: [Validators.pattern(RegExp(r'^\d\d*-?\d*\d$'))]
      ),     
      Distributor.getKeyEmail(): FormControl<String>(
        value: ref.read(distributorStateProvider)?.getEmail(),
        validators: [Validators.email]
      ),
      Distributor.getKeyIVA(): FormControl<double>(
        value: ref.read(distributorStateProvider)?.getIVA(),
        validators: [Validators.required, Validators.composeOR([Validators.equals(1.00), Validators.equals(1.21)])]
      ),
      Distributor.getKeyWebsite(): FormControl<String>(
        value: ref.read(distributorStateProvider)?.getWebsite(),
        validators: []
      )}, 
    );
  }
}