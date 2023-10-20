import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/notification/elegant_notification_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/container_style.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/distributor_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/response_api/response_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/datetime_custom.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_crud_provider.dart';
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

  final SizedBox _sizedBoxHeight = const SizedBox(height: 15,);
  late final FormGroup _form;

  @override
  void initState() {
    super.initState();
    Distributor distributorActual = ref.read(distributorStateBillingProvider)!;
    DistributorBilling distributorBilling = ref.read(billingInformationProvider)!;

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
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      decoration: ContainerStyle.getContainerChild(),
      child: ReactiveForm(
        formGroup: _form,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Encabezado principal.
            HeaderInformationWidget(
              titleHeader: (ref.watch(billingInformationProvider)!.getID()!=0) ? "Factura ${ref.watch(billingInformationProvider)!.getDatetime()}" : "Nueva Factura",
              tooltipClose: "Cerrar información factura.",
              onClose: (){
                ref.read(billingInformationProvider.notifier).free();
              },
              onDelete: (ref.watch(billingInformationProvider)!.getID()!=0) ? () async{
                ResponseAPI response = await ref.read(removeBillingsProvider.future);
                
                if (context.mounted){
                  ElegantNotificationCustom.showNotificationAPI(context, response);

                  if (response.isResponseSuccess()){
                    // ignore: unused_result
                    ref.refresh(billingsByDistributorProvider.future);
                    ref.read(billingInformationProvider.notifier).free();
                  }
                }
              } : null,
              onSave: (ref.watch(billingInformationProvider)!.getID()!=0) ? null : () async{
                if(_form.valid){
                  //Carga los nuevos valores en el billingInformationProvider.
                  ref.read(billingInformationProvider)?.fromJSONtoForm(_form.value);
                  ResponseAPI response = await ref.watch(newBillingWithAPIProvider.future);

                  if (context.mounted){
                    ElegantNotificationCustom.showNotificationAPI(context, response);

                    if (response.isResponseSuccess()){
                      // ignore: unused_result
                      ref.refresh(billingsByDistributorProvider.future);
                      ref.read(billingInformationProvider.notifier).free();
                    }
                  }
                }
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sizedBoxHeight,
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
                        _sizedBoxHeight,
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
                        _sizedBoxHeight,
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
                        _sizedBoxHeight,
                      ]
                  ),
                ),
              )
            )
        ],
      )
    ));
  }
}