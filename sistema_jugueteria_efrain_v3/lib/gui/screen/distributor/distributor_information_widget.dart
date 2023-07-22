import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
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
        validators: [Validators.required]
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
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [   
                    ReactiveTextField(
                      decoration: StyleForm.getDecorationTextField("CUIT"),
                      formControlName: Distributor.getKeyCUIT(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                        _form.focus(Distributor.getKeyName());
                      },
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Ingrese el CUIT de la distribuidora."
                      },
                    ),
                    ReactiveTextField(
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
                      decoration: StyleForm.getDecorationTextField("Dirección"),
                      formControlName: Distributor.getKeyAddress(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                        _form.focus(Distributor.getKeyCel());
                      },
                    ),
                    ReactiveTextField(
                      decoration: StyleForm.getDecorationTextField("Teléfono (celular o fijo)"),
                      formControlName: Distributor.getKeyCel(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                        _form.focus(Distributor.getKeyEmail());
                      },
                    ),
                    ReactiveTextField(
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
                    ReactiveTextField(
                      decoration: StyleForm.getDecorationTextField("Sitio web"),
                      formControlName: Distributor.getKeyWebsite(),
                      textInputAction: TextInputAction.none,
                      onSubmitted: (_){
                        setState(() {});
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _form.valid ? Colors.blue : Colors.grey),
                      onPressed: (){
                        if(_form.valid){
                          bool isError = false;

                          print(_form.value.toString());
                          ref.read(distributorProvider)?.fromJSON(_form.value);

                           AsyncValue<Response> response = ref.watch(
                                providerUpdateDistributor,
                            );

                            var resp = response.when(
                              data: (data){
                                isError = false;
                              }, 
                              error: (err, stack){
                                isError = true;
                                Text('Error: $err');
                              }, 
                              loading: (){null;}
                            );

                              if (isError==false){
                                ElegantNotification.success(
                                  title:  const Text("Información"),
                                  description:  const Text("La información ha sido actualizada con éxito.")
                                ).show(context);
                              }
                              else{
                                ElegantNotification.error(
                                  title:  const Text("Error"),
                                  description:  const Text("Ocurrió un error y no fue posible actualizar la información.")
                                ).show(context);
                              }
                          }
                        
                      } ,
                      child: const Text('Guardar cambios'),
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

class SecondRoute extends ConsumerWidget {
  const SecondRoute({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    print(ref.watch(distributorProvider)?.getJSON().toString());

    AsyncValue<Response> response = ref.watch(
        providerUpdateDistributor,
    );

    return response.when(
      data: (data){
        print('Response status: ${data.statusCode}');
        print('Response body: ${data.body}');
        return Text(data.body);
      }, 
      error: (err, stack) => Text('Error: $err'), 
      loading: (){return Text("Hola");});
  }
}