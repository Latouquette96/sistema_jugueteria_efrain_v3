import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

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
    _form = FormGroup({
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
      child: ReactiveForm(
        formGroup: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0.5, 0, 5),
                      padding: const EdgeInsets.all(10),
                      color: Colors.black,
                      height: 40,
                      child: const Text("Información Distribuidora", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
                    ))
                 ],
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: IconButton(
                    tooltip: "Cerrar información de la distribuidora.",
                    icon: const Icon(Icons.close_rounded, color: Colors.redAccent,), 
                    onPressed: (){ 
                      ref.read(distributorProvider.notifier).freeDistributor(ref);
                    },)
                )
              ],
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
                          onPressed: (){
                            if(_form.valid){
                              
                              bool isError = false;
                              
                              ref.read(distributorProvider)?.fromJSON(_form.value);

                              //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
                              AsyncValue<Response> response = (ref.read(distributorProvider)!.getID()==0) 
                                ? ref.watch(newDistributorWithAPIProvider)
                                : ref.watch(updateDistributorWithAPIProvider);
                              
                              //Realiza la peticion de modificacion y analiza la respuesta obtenida.
                              response.when(
                                data: (data){
                                  isError = false;
                                }, 
                                error: (err, stack){
                                  isError = true;
                                }, 
                                loading: (){null;}
                              );

                              //Si no ocurre error, entonces se procede a notificar del éxito de la operación y a cerrar el widget.
                              if (isError==false){
                                ElegantNotification.success(
                                  title:  const Text("Información"),
                                  description:  const Text("La información ha sido actualizada con éxito.")
                                ).show(context);

                                ref.read(lastUpdateProvider.notifier).state = DatetimeCustom.getDatetimeStringNow();
                                ref.read(distributorProvider.notifier).freeDistributor(ref);
                              }
                              else{
                                //Caso contrario, mostrar notificación de error.
                                ElegantNotification.error(
                                  title:  const Text("Error"),
                                  description:  const Text("Ocurrió un error y no fue posible actualizar la información.")
                                ).show(context);
                              }
                            }
                          } ,
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
}