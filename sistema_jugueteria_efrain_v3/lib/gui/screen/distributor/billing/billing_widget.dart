import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_catalog_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/screen/distributor/billing/billing_pdfview_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_container.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_list_tile.dart';

import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/distributor/distributor_provider.dart';

class BillingWidget extends ConsumerStatefulWidget{
  const BillingWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BillingWidgetState();
  }

}

class _BillingWidgetState extends ConsumerState<BillingWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
        decoration: StyleContainer.getContainerRoot(),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Encabezado principal.
              HeaderInformationWidget(
                titleHeader: "Distribuidora: ${ref.watch(distributorStateBillingProvider)!.getName()}",
                tooltipClose: "Cerrar distribuidora.",
                onClose: (){
                  ref.read(distributorStateBillingProvider.notifier).free();
                },
              ),
              Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            Expanded(child: (ref.watch(distributorStateBillingProvider)!=null) ? const BillingCatalogWidget() : const Text("No hay factura seleccionada")),
                            Expanded(child: (ref.watch(billingInformationProvider)!=null)
                              ? const BillingInformationWidget()
                              : Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Center(child: Text("Seleccione una factura o cree una nueva para ver mas información.",textAlign: TextAlign.center, style: StyleListTile.getTextStyleTitle(),)),),
                                )
                          ],
                        ),
                      ),
                      const Expanded(child: BillingPDFViewWidget())
                    ],
                  )
              )
            ]
        )
    );
  }

}