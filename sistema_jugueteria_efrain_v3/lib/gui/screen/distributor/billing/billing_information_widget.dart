import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_catalog_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

///Clase BillingInformationWidget: Permite mostrar y actualizar la información de una distribuidora.
class BillingInformationWidget extends ConsumerStatefulWidget {
  const BillingInformationWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BillingInformationWidgetState();
  }
}

class _BillingInformationWidgetState extends ConsumerState<ConsumerStatefulWidget> {

  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    Distributor distributorActual = ref.read(distributorBillingProvider)!;
    DistributorBilling distributorBilling = ref.read(billingProvider)!;

    _form = FormGroup({
      DistributorBilling.getKeyID(): FormControl<int>(
        value: distributorBilling.getID(),
        
      ),
      DistributorBilling.getKeyDatetime(): FormControl<String>(
        value: distributorBilling.getDatetime(),
        validators: [Validators.required, Validators.pattern(DatetimeCustom.getPattern())]
      ),
      DistributorBilling.getKeyDistributor(): FormControl<int>(
        value: distributorActual.getID(),
        validators: [Validators.required],
      ),
      DistributorBilling.getKeyTotal(): FormControl<double>(
        value: distributorBilling.getTotal(),
        validators: [Validators.required]
      ),
      DistributorBilling.getKeyUrlFile(): FormControl<String>(
        value: distributorBilling.getUrlFile().getLink(),
        validators: [Validators.required]
      ),
      DistributorBilling.getKeyDistributorName(): FormControl<String>(
        value: distributorActual.getName(),
        disabled: true
      ),  
    });
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
              titleHeader: "Información Factura-Distribuidora",
              tooltipClose: "Cancelar creación factura-distribuidora.",
              onClose: (){
                ref.read(billingProvider.notifier).freeBilling();
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReactiveTextField(
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("Distribuidora"),
                      formControlName: DistributorBilling.getKeyDistributorName(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                        _form.focus(DistributorBilling.getKeyDatetime());
                      },
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Ingrese la fecha y hora de la factura.",
                        ValidationMessage.pattern: (error)=> "(Error) El formato válido es 'YYYY-MM-DD hh:mm:ss"
                      },
                    ),   
                    ReactiveTextField(
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("Fecha/Hora"),
                      formControlName: DistributorBilling.getKeyDatetime(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                        _form.focus(DistributorBilling.getKeyTotal());
                      },
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Ingrese la fecha y hora de la factura.",
                        ValidationMessage.pattern: (error)=> "(Error) El formato válido es 'YYYY-MM-DD hh:mm:ss"
                      },
                    ),
                    ReactiveTextField(
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("Monto Total (sin IVA)"),
                      formControlName: DistributorBilling.getKeyTotal(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                        _form.focus(DistributorBilling.getKeyUrlFile());
                      },
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Ingrese el monto de la factura.",
                      },
                    ),
                    ReactiveTextField(
                      style: StyleForm.getStyleTextField(),
                      decoration: StyleForm.getDecorationTextField("URL del archivo"),
                      formControlName: DistributorBilling.getKeyUrlFile(),
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_){
                        setState(() {});
                      },
                      validationMessages: {
                        ValidationMessage.required: (error) => "(Requerido) Ingrese el link del archivo.",
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: ElevatedButton(
                          style: StyleForm.getStyleElevatedButtom(),
                          onPressed: () {
                            if(_form.valid){
                              //Control para verificar si se produjo error o no.
                              bool isError = false;
                              //Carga los nuevos valores en el billingProvider.
                              ref.read(billingProvider)?.fromJSONtoForm(_form.value);

                              //Obtiene un valor async que corresponde a la respuesta futura de una peticion de modificacion.
                              AsyncValue<Response> response = ref.watch(newBillingWithAPIProvider);
                              
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

                                ref.read(billingProvider.notifier).freeBilling();
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
                    ),
                    const SizedBox(
                      height: 100,
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