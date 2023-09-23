import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/enum/response_status_code.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_distributor.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pluto_state/pluto_grid_state_manager_provider.dart';

///Clase DistributorInformationWidget: Permite mostrar y actualizar la información de una distribuidora.
class DistributorInformationWidget extends ConsumerStatefulWidget {
  const DistributorInformationWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _DistributorInformationWidgetState();
  }
}

class _DistributorInformationWidgetState extends ConsumerState<ConsumerStatefulWidget> {

  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    _form = FormGroupDistributor.buildFormGroup(ref, distributorStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: ContainerStyle.getContainerRoot(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Encabezado principal.
          HeaderInformationWidget(
            titleHeader: "Información Distribuidora",
            tooltipClose: "Cerrar información de la distribuidora.",
            onClose: (){
              ref.read(distributorStateProvider.notifier).free();
            },
            onSave: () async{
              ref.read(distributorStateProvider)?.fromJSON(_form.value);
              bool isNew = ref.read(distributorStateProvider)!.getID()==0;
              if (isNew) {await _insert(context);}
              else  {await _update(context);}
            },
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: ContainerStyle.getContainerChild(),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  child: ReactiveForm(
                    formGroup: _form,
                    child: Column(
                      children: [
                        ReactiveTextField(
                          maxLength: 13,
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("CUIT"),
                          formControlName: Distributor.getKeyCUIT(),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_){
                            setState(() {});
                            _form.focus(Distributor.getKeyName());
                          },
                          validationMessages: {
                            ValidationMessage.maxLength: (error) => "Máxima longitud de CUIT de 13 caracteres.",
                            ValidationMessage.required: (error) => "(Requerido) Ingrese el CUIT de la distribuidora."
                          },
                        ),
                        ReactiveTextField(
                          maxLength: 50,
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("Nombre"),
                          formControlName: Distributor.getKeyName(),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_){
                            setState(() {});
                            _form.focus(Distributor.getKeyAddress());
                          },
                          validationMessages: {
                            ValidationMessage.required: (error) => "(Requerido) Ingrese el nombre de la distribuidora."
                          },
                        ),
                        ReactiveTextField(
                          maxLength: 75,
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("Dirección"),
                          formControlName: Distributor.getKeyAddress(),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_){
                            setState(() {});
                            _form.focus(Distributor.getKeyCel());
                          },
                        ),
                        ReactiveTextField(
                          maxLength: 15,
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("Teléfono (celular o fijo)"),
                          formControlName: Distributor.getKeyCel(),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_){
                            setState(() {});
                            _form.focus(Distributor.getKeyEmail());
                          },
                        ),
                        ReactiveTextField(
                          maxLength: 150,
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("Correo electrónico"),
                          formControlName: Distributor.getKeyEmail(),
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_){
                            setState(() {});
                            _form.focus(Distributor.getKeyIVA());
                          },
                          validationMessages: {
                            ValidationMessage.email: (error) => '(Opcional) Ingrese un correo electrónico válido.',
                          },
                        ),
                        ReactiveDropdownField<double>(
                          formControlName: Distributor.getKeyIVA(),
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("IVA aplicado a los productos."),
                          items: const [
                            DropdownMenuItem<double>(value: 1.00,child: Text("1.00 (sin IVA)"),),
                            DropdownMenuItem<double>(value: 1.21,child: Text("1.21 (con IVA)"),),
                          ],
                          onChanged: (control) {
                            setState(() {});
                            _form.focus(Distributor.getKeyWebsite());
                          },
                          validationMessages: {
                            ValidationMessage.required: (error) => "(Requerido) Seleccione el impuesto que aplica la distribuidora."
                          },
                        ),
                        const SizedBox(height: 15,),
                        ReactiveTextField(
                          maxLength: 150,
                          style: StyleForm.getStyleTextField(),
                          decoration: StyleForm.getDecorationTextField("Sitio web"),
                          formControlName: Distributor.getKeyWebsite(),
                          textInputAction: TextInputAction.none,
                          onSubmitted: (_){
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 15,),
                      ],
                    ),
                  ),
                ),
              ),
          )
        ],
      )
    );
  }

  ///DistributorInformationWidget: Inserta una nueva distribuidora.
  Future<void> _insert(BuildContext context) async{
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseStatusCode response = await ref.watch(newDistributorWithAPIProvider.future);

    if (response==ResponseStatusCode.statusCodeOK){
      //Inserta el nuevo registro por el actualizado.
      ref.read(stateManagerDistributorProvider.notifier).insert(distributorStateProvider);
      //Actualizar datos de ultima actualizacion
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      //Notifica con exito en la operacion
      if (context.mounted) ElegantNotificationCustom.showNotificationSuccess(context);

      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      ref.read(distributorStateProvider.notifier).free();
      setState(() {});
    }
    else{
      if (context.mounted) ElegantNotificationCustom.showNotificationError(context);
    }
  }

  ///DistributorInformationWidget: Actualiza una distribuidora existente.
  Future<void> _update(BuildContext context) async{
    //Carga los datos del formulario en la distribuidora.
    ref.read(distributorStateProvider)?.fromJSON(_form.value);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    ResponseStatusCode response = await ref.watch(updateDistributorWithAPIProvider.future);

    if (response==ResponseStatusCode.statusCodeOK){
      ref.read(stateManagerDistributorProvider.notifier).update(distributorStateProvider);
      //Actualizar datos de ultima actualizacion
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      if (context.mounted) ElegantNotificationCustom.showNotificationSuccess(context);

      //Libera el distribuidor del proveedor.
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      ref.read(distributorStateProvider.notifier).free();
      setState(() {});
    }
    else{ 
      if (context.mounted) ElegantNotificationCustom.showNotificationError(context);
    }
  }
}