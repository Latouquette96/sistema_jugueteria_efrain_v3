import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

///Clase FormGroupDistributor: Modela la composicion de todos los controles de formulario de una distribuidora.
class FormGroupDistributor {
  
  ///FormGroupDistributor: Construye el FormGroup para un producto almacenado en un determinado provider de DistributorProvider.
  static buildFormGroup(WidgetRef ref, StateNotifierProvider<DistributorProvider, Distributor?> provider){
    
    return FormGroup({
      Distributor.getKeyID(): FormControl<int>(
        value: ref.read(distributorProvider)?.getID(),
      ),
      Distributor.getKeyCUIT(): FormControl<String>(
        value: ref.read(distributorProvider)?.getCUIT(),
        validators: [Validators.required, Validators.maxLength(13)]
      ),
      Distributor.getKeyName(): FormControl<String>(
        value: ref.read(distributorProvider)?.getName(),
        validators: [Validators.required]
      ),
      Distributor.getKeyAddress(): FormControl<String>(
        value: ref.read(distributorProvider)?.getAddress(),
        validators: []
      ),
      Distributor.getKeyCel(): FormControl<String>(
        value: ref.read(distributorProvider)?.getPhone(),
        validators: [Validators.pattern(RegExp(r'^\d\d*-?\d*\d$'))]
      ),     
      Distributor.getKeyEmail(): FormControl<String>(
        value: ref.read(distributorProvider)?.getEmail(),
        validators: [Validators.email]
      ),
      Distributor.getKeyIVA(): FormControl<double>(
        value: ref.read(distributorProvider)?.getIVA(),
        validators: [Validators.required, Validators.composeOR([Validators.equals(1.00), Validators.equals(1.21)])]
      ),
      Distributor.getKeyWebsite(): FormControl<String>(
        value: ref.read(distributorProvider)?.getWebsite(),
        validators: []
      )}, 
    );
  }
}