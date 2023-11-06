import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_text_field.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_crud_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_operations_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

///Clase BillingCatalogWidget: Modela un catalogo de facturas para la distribuidora seleccionada.
class BillingCatalogWidget extends ConsumerWidget {
  const BillingCatalogWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return FutureBuilder(
        future: ref.watch(billingsByDistributorProvider.future),
        builder: (context, snap){
          if (snap.hasData){
            return Container(
                margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                decoration: StyleContainer.getContainerChild(),
                child: _getBillingsDistributor(context, ref, snap.data!)
            );
          }
          else{
            return const CircularProgressIndicator();
          }
        }
    );
  }

  ///BillingCatalogWidget: Devuelve un widget con el listado de las facturas para una determinada distribuidora.
  Widget _getBillingsDistributor(BuildContext context, WidgetRef ref, List<DistributorBilling> list){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Encabezado principal.
        HeaderInformationWidget(
          titleHeader: "Facturas cargadas",
          tooltipClose: "Cerrar información factura.",
          onNew: (){
            if (ref.watch(billingInformationProvider)==null){
              ref.read(billingInformationProvider.notifier).load(DistributorBilling.newBilling(distributorID: ref.watch(distributorStateBillingProvider)!.getID()));
            }
            else{
              ref.read(billingInformationProvider.notifier).free();
            }
          },
        ),
        Expanded(
            child: Container(
              margin: const EdgeInsets.all(4.0),
              child: SingleChildScrollView(
                  child: Column(
                    children: list.map((e){
                      return Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.grey.shade200, Colors.grey.shade300, Colors.grey.shade400]),
                            border: Border.all(color: Colors.grey)
                        ),
                        margin: const EdgeInsets.fromLTRB(0, 0.5, 0, 0.5),
                        child: ListTile(
                          iconColor: Colors.black,
                          title: Row(
                              children: [
                                Text("Fecha: ", style: StyleTextField.getTextStyleNormal(),),
                                Expanded(child: Text(e.getDatetime(), style: StyleTextField.getTextStyleNormal()))
                              ]
                          ),
                          subtitle: Text("Total: \$${e.getTotal().toStringAsFixed(2)}", style: StyleTextField.getTextStyleNormal(),),
                          trailing: SizedBox(
                            width: 75,
                            child: Row(
                              children: [
                                Expanded(child: IconButton(
                                  icon: Icon(
                                    MdiIcons.fromString("file-pdf-box"),
                                    color: (ref.watch(billingSearchProvider)==e) ? Colors.blue.shade600 : null,
                                  ),
                                  tooltip: "Visualizar factura",
                                  onPressed: (){
                                    if (ref.read(billingSearchProvider)==null){
                                      ref.read(billingSearchProvider.notifier).load(e);
                                      ref.read(billingOperationsProvider.notifier).initialize();
                                    }
                                    else{
                                      ref.read(billingOperationsProvider.notifier).free();
                                      ref.read(billingSearchProvider.notifier).free();
                                    }
                                  },
                                )),
                                Expanded(child: IconButton(
                                  icon: Icon(
                                    MdiIcons.fromString("information"),
                                    color: (ref.watch(billingInformationProvider)==e) ? Colors.green.shade600 : null,
                                  ),
                                  tooltip: "Ver información de factura",
                                  onPressed: (){
                                    if (ref.read(billingInformationProvider)==null){
                                      ref.read(billingInformationProvider.notifier).load(e);
                                    }
                                    else{
                                      ref.read(billingInformationProvider.notifier).free();
                                    }
                                  },
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
              ),
            )
        ),
      ],
    );
  }
}