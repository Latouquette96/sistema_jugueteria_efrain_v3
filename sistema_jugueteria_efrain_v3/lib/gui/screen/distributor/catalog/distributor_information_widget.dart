import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/form_group/formgroup_distributor.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/state_manager/state_manager_provider.dart';

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
    _form = FormGroupDistributor.buildFormGroup(ref, distributorProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(
        start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      )),
      child: ReactiveForm(
        formGroup: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Encabezado principal.
            HeaderInformationWidget(
              titleHeader: "Información Distribuidora",
              tooltipClose: "Cerrar información de la distribuidora.",
              onClose: (){
                ref.read(distributorProvider.notifier).free();
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: _form.valid ? Colors.blue : Colors.grey),
                          onPressed: () async{
                            ref.read(distributorProvider)?.fromJSON(_form.value);
                            bool isNew = ref.read(distributorProvider)!.getID()==0;
                            if (isNew) {await _insert(context);}
                            else  {await _update(context);}
                          },
                          child: const Text('Guardar cambios'),
                        )),
                      ],
                    )
                  ]
                ),
              )
            ),
            const SizedBox(
              height: 25,
            )
        ],
      )
    ));
  }

  
  Future<void> _insert(BuildContext context) async{
    bool isError = false;
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    Response response = await ref.watch(newDistributorWithAPIProvider.future);

    //Ocurre error si no es el código 201.
    isError = response.statusCode!=201;
    if (!isError){
      //Inserta el nuevo registro por el actualizado.
      ref.read(stateManagerDistributorProvider.notifier).insert(distributorProvider);
      //Actualizar datos de ultima actualizacion
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      //Notifica con exito en la operacion
      if (context.mounted) ElegantNotificationCustom.showNotificationSuccess(context);

      //Libera el producto del proveedor.
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      ref.read(distributorProvider.notifier).free();
      setState(() {});
    }
    else{
      if (context.mounted) ElegantNotificationCustom.showNotificationError(context);
    }
  }

  Future<void> _update(BuildContext context) async{
    bool isError = false;
    //Carga los datos del formulario en el producto.
    ref.read(distributorProvider)?.fromJSON(_form.value);
    //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
    Response response = await ref.watch(updateDistributorWithAPIProvider.future);
    
    //Ocurre error si no es el código 200.
    isError = response.statusCode!=200;
    if (!isError){
      ref.read(stateManagerDistributorProvider.notifier).update(distributorProvider);
      //Actualizar datos de ultima actualizacion
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      if (context.mounted) ElegantNotificationCustom.showNotificationSuccess(context);

      //Libera el producto del proveedor.
      ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
      ref.read(distributorProvider.notifier).free();
      setState(() {});
    }
    else{ 
      if (context.mounted) ElegantNotificationCustom.showNotificationError(context);
    }
  }
}