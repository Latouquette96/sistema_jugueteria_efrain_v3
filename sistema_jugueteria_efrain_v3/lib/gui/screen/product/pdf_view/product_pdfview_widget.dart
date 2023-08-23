import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/style/style_form.dart';
import 'package:sistema_jugueteria_efrain_v3/gui/widgets/header_custom/header_information_widget.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/billing/billing_provider.dart';
import 'package:sistema_jugueteria_efrain_v3/provider/pdf_view/pdf_view_controller_provider.dart';
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
  
  late final PdfViewerController _pdfViewerController;

  @override
  void initState() {
    _pdfViewerController = ref.read(pdfViewControllerProvider);
    super.initState();
  }

  @override
  didChangeDependencies(){
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //ref.read(pdfViewControllerProvider.notifier).disposeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                    icon: Icon(MdiIcons.fromString("folder"), color: Colors.white, size: 24,),
                    onPressed: (){

                    },
                  )
                ),
                Positioned(
                  left: 30,
                  child: IconButton(
                    tooltip: "Abrir PDF por enlace de archivo en internet",
                    icon: Icon(MdiIcons.fromString("web")), color: Colors.white,
                    onPressed: (){
                      
                    },
                  )
                )
              ],
            ),
            Expanded(
              child: SfPdfViewer.network(
                "https://www.dropbox.com/scl/fi/u4jmep8ynoy3oc0wm6487/prueba.pdf?rlkey=83i5a3dzrfqs91a2se2lh0ez4&dl=1", 
                controller: _pdfViewerController,
                currentSearchTextHighlightColor: Colors.blue.withOpacity(0.5),
                otherSearchTextHighlightColor: Colors.blueAccent.withOpacity(0.3),
              )
            ),
            Container(
              color: Colors.black54,
              height: 50,
              child: Row(
                children: [
                  Expanded(child: 
                    IconButton(
                      tooltip: "Ir a resultado anterior",
                      icon: Icon(Icons.arrow_circle_left, color: Colors.blueGrey.shade100), 
                      onPressed: (){ 
                        if (ref.read(pdfTextSearchResultProvider)!=null){
                          ref.read(pdfTextSearchResultProvider)!.previousInstance();
                          setState((){});
                        }
                      },
                    )
                  ),
                  Expanded(child: 
                    (ref.read(pdfTextSearchResultProvider)!=null)
                    ? Center(child: Text("${ref.watch(pdfTextSearchResultProvider)!.currentInstanceIndex}/${ref.watch(pdfTextSearchResultProvider)!.totalInstanceCount}", style: StyleForm.getStyleTextField(),))
                    : Center(child: Text("Sin resultados", style: StyleForm.getStyleTextField()),)
                  ),
                  Expanded(child: 
                    IconButton(
                      tooltip: "Ir a resultado siguiente",
                      icon: Icon(Icons.arrow_circle_right, color: Colors.blueGrey.shade100),
                      onPressed: (){ 
                        if (ref.read(pdfTextSearchResultProvider)!=null){
                          ref.read(pdfTextSearchResultProvider.notifier).next();
                          setState(() {});
                        }
                      },
                    )
                  )
                ],
              ),
            )
          ]
      )
    );
  }
}