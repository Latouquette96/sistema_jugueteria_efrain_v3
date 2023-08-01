import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Clase BillingPDFViewWidget: Permite mostrar y actualizar la información de una distribuidora.
class BillingPDFViewWidget extends ConsumerStatefulWidget {
  const BillingPDFViewWidget({super.key});
  
  @override
  ConsumerState<BillingPDFViewWidget> createState() {
    return _BillingPDFViewWidgetState();
  }
}

class _BillingPDFViewWidgetState extends ConsumerState<BillingPDFViewWidget> {
  
  @override
  Widget build(BuildContext context) {
    
    DistributorBilling db = ref.watch(billingSearchProvider)!;

    return Container(
      width: 600,
      margin: const EdgeInsets.fromLTRB(0, 10, 5, 10),
      decoration: const BoxDecoration(color: Colors.white, border: BorderDirectional(
        start: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        top: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        end: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
        bottom: BorderSide(color: Color.fromARGB(255, 211, 211, 211), width: 3),
      )),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Encabezado principal.
            HeaderInformationWidget(
              titleHeader: "Factura: ${db.getDatetime()}",
              tooltipClose: "Cerrar vista de factura.",
              onClose: (){
                ref.read(billingSearchProvider.notifier).freeBilling();
              },
            ),
            Expanded(
              child: SfPdfViewer.network(
                db.getUrlFile().getLink(), 
                controller: PdfViewerController()
              )
            )
          ]
      )
    );
  }
}