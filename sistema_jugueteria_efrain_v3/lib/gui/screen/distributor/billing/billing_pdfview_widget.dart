import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_list_tile.dart';

import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models/relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/structure_data/triple.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/utils/resource_link.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_operations_provider.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Factura de la distribuidora.
    DistributorBilling? db = ref.watch(billingSearchProvider);
    //Recupera el estado del archivo
    Triple<File?, ResourceLink, bool>? triple = ref.watch(billingOperationsProvider);

    ///Creación del widget
    Widget widgetPDF;
    if (db!=null && triple!=null){
      if (ref.watch(billingOperationsProvider)!.getValue1()==null && ref.watch(billingOperationsProvider)!.getValue3()==false){
        widgetPDF = Text("Error: Seleccione una factura para poder visualizarla en el visor.", style: StyleListTile.getTextStyleTitle(),);
      }
      else{
        if (ref.watch(billingOperationsProvider)!.getValue1()!=null){
          widgetPDF = _getPdfViewerFile(context);
        }
        else{
          widgetPDF = _getPdfViewerNetwork(context, db);
        }
      }
    }
    else{
      widgetPDF = Text("Seleccione una factura para poder visualizarla en el visor.", style: StyleListTile.getTextStyleTitle(),);
    }

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
              titleHeader: (db!=null) ? "Factura: ${db.getDatetime()}" : "Factura: -",
              tooltipClose: "Cerrar factura.",
              onClose: (db!=null) ? (){
                ref.read(billingSearchProvider.notifier).free();
              } : null,
              onSave: (db!=null && triple!=null && triple.getValue1()==null && triple.getValue3()==true)
                  ? () async {
                    await ref.read(billingOperationsProvider.notifier).download();
                    if (mounted){
                      setState(() {});
                    }
               }
               : null,
              onDelete: (db!=null && triple!=null && triple.getValue1()!=null)
                ? () async {
                    await ref.read(billingOperationsProvider.notifier).deleteFile();
                    if (mounted){
                      setState(() {});
                    }
                  }
                : null  ,
            ),
            Expanded(
              child: (db!=null)
                  ? widgetPDF
                  : Text("Seleccione una factura para poder visualizarla en el visor.", style: StyleListTile.getTextStyleTitle(),)
            )
          ]
      )
    );
  }


  Widget _getPdfViewerFile(BuildContext context){
    return SfPdfViewer.file(ref.watch(billingOperationsProvider)!.getValue1()!);
  }

  Widget _getPdfViewerNetwork(BuildContext context, DistributorBilling db){
    return SfPdfViewer.network(db.getUrlFile().getLink());
  }
}