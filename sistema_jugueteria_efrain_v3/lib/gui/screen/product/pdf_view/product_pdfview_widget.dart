import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/logic/models_relations/distributor_billing_model.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

///Clase ProductPDFViewWidget: Permite mostrar y actualizar la información de un producto.
class ProductPDFViewWidget extends ConsumerStatefulWidget {
  const ProductPDFViewWidget({super.key});
  
  @override
  ConsumerState<ProductPDFViewWidget> createState() {
    return _ProductPDFViewWidgetState();
  }
}

class _ProductPDFViewWidgetState extends ConsumerState<ProductPDFViewWidget> {
  
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
            Stack(
              children: [
                HeaderInformationWidget(
                  titleHeader: "Visor PDF",
                  tooltipClose: "Cerrar visor PDF.",
                  onClose: (){
                    ref.read(billingSearchProvider.notifier).free();
                  },
                ),
                Positioned(
                  child: IconButton(
                    tooltip: "Abrir PDF almacenado en el sistema.",
                    icon: Icon(MdiIcons.fromString("folder")),
                    onPressed: (){

                    },
                  )
                ),
                Positioned(
                  child: IconButton(
                    tooltip: "Abrir PDF por enlace de archivo en internet",
                    icon: Icon(MdiIcons.fromString("web")),
                    onPressed: (){
                      
                    },
                  )
                )
              ],
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